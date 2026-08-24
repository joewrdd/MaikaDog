# The Yard

How the peer to peer den works, and why it needs no server. This is the design note the implementation follows; read it alongside [SECURITY.md](../SECURITY.md), which covers what actually crosses the wire.

Peer to peer rooms for Maika. Two or more Macs in the same space, one shared den, everyone's dog walks in and flexes their coat, breed and wardrobe. No server, no internet, no accounts, nothing persisted.

## Why this works without a server

A drawn dog is not an image, it is a parameter list. Everything a peer needs to render your dog is about sixty bytes: breed id, coat id, accessory id, mood, name, position, current action. Each Mac re-renders every visitor with its own local ink engine, so nothing heavy ever crosses the wire and every Mac sees the same dogs in its own hand drawn wobble.

Transport is Apple MultipeerConnectivity (MC): Bluetooth plus peer to peer WiFi plus LAN, built into macOS, serverless by design, sessions of up to 8 peers.

## UX

The door lives in the den (den mode ships separately). States:

1. Door closed. Normal den. A small drawn door on the wall.
2. Open the door (tap door, or tray item "Open the yard"). Your den starts advertising as `<petName>'s den`. The door visibly opens; a "waiting by the door" caption shows.
3. Browsing. Anyone with the door UI open also sees a list of nearby open dens by pet name. Tap one to knock.
4. Knock and approve. The host gets a bubble: "<name> is at the door!" with approve or ignore. Approval admits the guest.
5. The room. Guests' dogs walk in through the door of the HOST's house (the host's houseId is broadcast, so guests see the host's interior; houses become flex too). Name tags float above visitors. Everyone wanders the shared floor. Taps perform locally and broadcast, so a trick or bark plays on every screen.
6. Leaving. A guest taps their door chip to walk out. The host closing the door ends the room for everyone; dogs walk out, den returns to normal.

Rules: at most 6 dogs in a room (visual sanity, MC caps at 8 peers anyway). The host owns the room. No chat, no text input beyond what already exists (pet names). Sidekick bubbles pause while the yard is open.

## Architecture

```
Dart                              Swift
--------                          --------
YardService  <->  MethodChannel   YardChannel (MCSession owner)
             <-   EventChannel    advertiser + browser + session events
```

One room = one MCSession. The host advertises, guests browse and invite themselves via the knock flow (MC invitation carries the guest hello payload; the host approves in UI before accepting the invitation).

### Swift layer: `YardChannel` in `macos/Runner/MainFlutterWindow.swift`

Owns MCPeerID (display name = pet name), MCNearbyServiceAdvertiser, MCNearbyServiceBrowser, MCSession. Service type: `maika-yard` (MC service types must be 1 to 15 lowercase characters or hyphens).

MethodChannel `maika/yard` methods:

- `openDoor(name: String) -> void` start advertising, create session as host
- `closeDoor() -> void` stop advertising, disconnect session
- `startBrowsing() -> void` / `stopBrowsing() -> void`
- `knock(peerId: String, hello: Uint8List) -> void` invite self to that den with hello as context
- `approve(peerId: String) -> void` / `ignore(peerId: String)` host answer to a pending knock
- `leave() -> void` guest disconnects
- `send(data: Uint8List) -> void` broadcast to all session peers (reliable mode for events, unreliable fine for heartbeats; v1 uses reliable for everything, revisit only if lag shows)

EventChannel `maika/yard/events` emits maps:

- `{type: denFound, id, name}` / `{type: denLost, id}`
- `{type: knock, id, name, hello: bytes}` (host side)
- `{type: joined}` (guest side, session connected)
- `{type: peerJoined, id}` / `{type: peerLeft, id}`
- `{type: data, id, bytes}`
- `{type: error, message}`

Info.plist additions (macOS Sequoia and later prompt for local network):

- `NSLocalNetworkUsageDescription`: "Maika uses your local network so nearby dens can find each other. Nothing leaves the room."
- `NSBonjourServices`: `_maika-yard._tcp`, `_maika-yard._udp`

App is not sandboxed, so no extra entitlements are needed.

### Dart layer: `lib/yard.dart`

- `YardService` wraps the channels. States: closed, open (advertising, empty), browsing, knocking, hosting (n guests), visiting.
- `YardPeer` model: id, name, breedId, coatId, accessoryId, mood, x, flip, action, lastSeen.
- Heartbeat loop: 4 Hz timer sends the local dog state; receive path updates `YardPeer` entries; positions interpolate between heartbeats (lerp toward target x, cel quantized by the existing ticker so motion stays hand drawn).
- Peer eviction: no heartbeat for 10 seconds removes the dog with a walk out animation.
- Version gate: every message carries `v`. Unknown major version shows a soft caption "their Maika is newer, update to play" and ignores the peer politely.

### The protocol (JSON, tiny, explicit)

Heartbeat, about 4 per second per dog:

```json
{"v":2,"t":"hb","name":"Maika","breed":"golden","coat":"galaxy","acc":"blindfold","mood":"signature","x":0.42,"flip":false,"act":"idle"}
```

`act` is one of idle, walk, sit, sleep. Events, sent once:

```json
{"v":2,"t":"perform"}
{"v":2,"t":"bark"}
{"v":2,"t":"hello","name":"Maika","breed":"golden","coat":"galaxy","acc":"blindfold"}
{"v":2,"t":"host","house":"teahouse","cap":6}
{"v":2,"t":"bye"}
```

The host sends `host` to each new guest so they render the host's house. Unknown fields are ignored, unknown `t` is ignored, so v1.x can grow without breaking rooms.

### Rendering visitors

The den scene painter gains a visitor pass: for each `YardPeer`, `dogCharacter(dogBreedById(breed), coatById(coat), accessory: accessoryByName(acc))` drawn with `FoodCharacterPainter` at the shared floor scale, x mapped across the floor zone, walk parameter driven while act is walk, name tag drawn above in the display font. Coats or breeds the viewer has not unlocked still render for visitors, that is the flex. Locked content is a rendering parameter, not a secret.

## Testing it with two Macs

- Discovery both directions, WiFi on
- Discovery with WiFi off on one machine (pure Bluetooth path, expect slower)
- Knock, approve, walk in, name tags correct both sides
- Skin flex: exotic coat plus anime accessory renders identically on the other Mac
- Bark and perform propagate both directions
- Guest leave, host sees walk out
- Host closes door, guest den returns to normal cleanly
- One Mac sleeps: peer evicts after 10 seconds, rejoin works after wake
- Six dog cap: seventh knock politely refused
- Local network permission prompt appears once and the copy reads right

