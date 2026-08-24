# Security and privacy

Maika reads your Claude Code transcripts, runs without the macOS sandbox, and
can open peer-to-peer connections on your local network. Those are three good
reasons to be suspicious of a desk toy. This document says exactly what she
does, including the awkward parts, and shows you how to check rather than take
my word for it.

## The short version

**Maika never contacts a server.** No analytics, no telemetry, no crash
reporting, no update check, no account. There is no HTTP client anywhere in the
app.

The one exception to "nothing leaves your Mac" is the Yard, and it is
local-network only: when *you* open the door, she announces herself over
Bonjour/mDNS so nearby Macs can find her, and exchanges small frames directly
with them. macOS will ask for **Local Network** permission the first time. The
door is closed on launch and stays closed until you open it.

## What it reads

Maika reads the Claude Code transcripts already on your disk:

- `~/.claude/projects/**/*.jsonl` — every session transcript.

Be precise about what "reads" means here. To count tokens and notice events she
parses token counts, timestamps, tool names, the working folder, the git branch,
**the shell commands you ran** (to tell a commit from a test run), **the file
paths you edited** (for the language), and the first line of assistant text (to
spot an API error). All of that is turned into counts and thrown away.

**None of it is ever displayed or stored as text.** Sessions are labeled by
folder, then folder and branch, then a numbered seat (`myproject (2)`) — never
by content. Your prompts and Claude's replies never reach the screen. A test
named *"labels never leak prompt text, whatever the transcript says"* in
`test/sidekick_test.dart` fails the build if that changes.

## What it stores

**The ledger:** `~/Library/Application Support/Maika/usage_state.json`. Lifetime
and per-day token totals, per-day counts of events (commits, test runs, edits,
deletes, errors), a late-night flag, the languages you worked in, and
de-duplication keys so a transcript entry is never counted twice.

One thing worth knowing: it keys files by **absolute transcript path**, so that
file effectively lists every project directory you have used Claude Code in.
Day and event entries older than 120 days are pruned; the path list is not
pruned while the transcripts still exist. It contains no prompt text, no code,
and no file contents.

**Cards you export:** pressing share on Field Notes or the Dog Tag writes a PNG
to your Desktop. Those contain your stats and your dog, never transcript text.

**Preferences:** her name, coat, breed and toggles, in standard macOS user
defaults under `com.wrddio.maika`.

Deleting the ledger is safe for your privacy but **not free**: Maika treats a
missing ledger as a fresh install, so lifetime XP returns to zero, your level
resets, and level-gated coats and breeds re-lock. Past transcripts are marked as
already-counted rather than re-read, so the XP does not come back. Delete it if
you want the record gone; just know that is the trade.

## What crosses the network

Only the Yard, and only once you open the door. Three separate things happen,
and they deserve to be told apart:

**1. Announcing (unencrypted, to your whole local network).** While the door is
open, macOS advertises the service `maika-yard` over mDNS with **your dog's
name** in it. Anyone on the same network can list it — try
`dns-sd -B _maika-yard._tcp`. That is how nearby dens find each other, and it is
the one thing that is public before anyone approves anything. Name her something
you don't mind a coffee shop seeing.

**2. Knocking (before approval).** When you knock on a den, your `hello` frame —
name, breed, coat, accessory and a random session id — is delivered to that host
so they can decide. Only to that host.

**3. In a room (encrypted, after approval).** Rooms use MultipeerConnectivity
with encryption required. Every byte about you is built in `lib/yard.dart`, and
it is this and nothing else:

| Field | What it is |
|---|---|
| `name` | your dog's name, sanitized |
| `breed`, `coat`, `acc` | which drawing to render |
| `mood` | which face to draw |
| `x`, `flip`, `act` | where she is standing and whether she is walking |
| `house` | which room the host is showing |
| `sid` | a random per-run id, so a kick can target one guest |

No XP, no token counts, no project names, no branch names, no session
information, and no transcript-derived data of any kind is ever sent.

The trust model: a guest knocks, **the host must approve**, and the host can
send anyone home. Incoming values are validated against the real registries with
safe fallbacks, so a malformed or hostile frame renders a default dog rather
than doing anything. Floods are rate-limited per peer and silent peers are
dropped. Treat it like any local-network feature: good among friends on a
network you trust, and it is off unless you turn it on.

## Why it runs unsandboxed

The macOS App Sandbox is deliberately disabled in
`macos/Runner/Release.entitlements`. A sandboxed app cannot read `~/.claude`,
which is the entire point. That is a real trade-off and you should know you are
making it.

Maika also runs four system tools: `ps` and `lsof` to see which Claude Code
sessions are genuinely running, `lsappinfo` to notice when your terminal is
focused so she stays quiet, and `open -R` to reveal an exported card in Finder
when you press share. The first three are read-only and their output is held in
memory and discarded.

## Verify it yourself

Don't trust the paragraphs above. Clone the repo and run these:

```bash
# No HTTP/socket client anywhere. Prints nothing.
grep -rnE "HttpClient|WebSocket|package:http|package:dio|InternetAddress|Socket\.connect" lib/

# Every outside process it can launch. Five call sites, four tools.
grep -rn "Process.run" lib/

# Everything sent inside a room, and everything advertised on the network.
sed -n '/static Uint8List hello/,/^}/p' lib/yard.dart
grep -n "discoveryInfo\|MCPeerID(" macos/Runner/MainFlutterWindow.swift

# Everything it writes to disk.
grep -rn "writeAsString\|writeAsBytes\|setString\|setBool\|setInt" lib/
```

`test/no_network_test.dart` asserts the first one permanently, and also
allowlists every dependency so a networking package cannot appear quietly. It
checks Dart and Swift source; it cannot vouch for what Apple's
MultipeerConnectivity framework does internally, which is why the Yard is
described above rather than claimed away.

## Reporting a vulnerability

Open a [security advisory](https://github.com/joewrdd/MaikaDog/security/advisories/new).
Please don't file a public issue for anything exploitable.

This is a hobby project maintained by one person — expect a friendly reply, not
an enterprise SLA.
