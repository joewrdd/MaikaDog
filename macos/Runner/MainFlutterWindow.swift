import Cocoa
import FlutterMacOS
import MultipeerConnectivity

class MainFlutterWindow: NSWindow {
  override var canBecomeKey: Bool { true }
  override var canBecomeMain: Bool { true }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.styleMask = [.borderless]
    self.isOpaque = false
    self.backgroundColor = .clear
    self.hasShadow = false
    self.level = .floating
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    self.isMovableByWindowBackground = false
    flutterViewController.backgroundColor = .clear

    RegisterGeneratedPlugins(registry: flutterViewController)
    YardChannel.register(messenger: flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()
  }
}

class YardChannel: NSObject, FlutterStreamHandler, MCSessionDelegate,
  MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate
{
  static let serviceType = "maika-yard"
  static let maxContextBytes = 2048
  static let maxFrameBytes = 4096

  private var events: FlutterEventSink?
  private var peerID: MCPeerID?
  private var session: MCSession?
  private var advertiser: MCNearbyServiceAdvertiser?
  private var browser: MCNearbyServiceBrowser?
  private var pendingInvites: [String: (Bool, MCSession?) -> Void] = [:]
  private var knownPeers: [String: MCPeerID] = [:]
  private var listedName = "Maika"
  private var hosting = false
  private var capacity = 6

  static func register(messenger: FlutterBinaryMessenger) {
    let instance = YardChannel()
    let method = FlutterMethodChannel(name: "maika/yard", binaryMessenger: messenger)
    method.setMethodCallHandler { call, result in instance.handle(call, result: result) }
    let event = FlutterEventChannel(name: "maika/yard/events", binaryMessenger: messenger)
    event.setStreamHandler(instance)
    NSWorkspace.shared.notificationCenter.addObserver(
      instance,
      selector: #selector(instance.didWake),
      name: NSWorkspace.didWakeNotification,
      object: nil
    )
  }

  func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    events = sink
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    events = nil
    return nil
  }

  private func emit(_ payload: [String: Any]) {
    DispatchQueue.main.async { [weak self] in
      self?.events?(payload)
    }
  }

  private func idFor(_ peer: MCPeerID) -> String {
    return "\(peer.displayName)#\(UInt(bitPattern: peer.hash))"
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "configure":
      let raw = (args["name"] as? String ?? "Maika")
      listedName = String(raw.prefix(24))
      let suffix = String(UInt32.random(in: 0x1000...0xFFFF), radix: 16)
      let unique = "\(String(raw.prefix(20)))-\(suffix)"
      peerID = MCPeerID(displayName: String(unique.prefix(48)))
      capacity = max(2, min(8, args["cap"] as? Int ?? 6))
      result(nil)
    case "openDoor":
      teardownSession()
      guard let me = ensurePeer() else {
        result(FlutterError(code: "no_peer", message: "configure first", details: nil))
        return
      }
      hosting = true
      let s = MCSession(peer: me, securityIdentity: nil, encryptionPreference: .required)
      s.delegate = self
      session = s
      let adv = MCNearbyServiceAdvertiser(
        peer: me,
        discoveryInfo: ["v": "1", "name": listedName],
        serviceType: YardChannel.serviceType
      )
      adv.delegate = self
      adv.startAdvertisingPeer()
      advertiser = adv
      result(nil)
    case "closeDoor", "leave":
      hosting = false
      advertiser?.stopAdvertisingPeer()
      advertiser = nil
      teardownSession()
      pendingInvites.removeAll()
      result(nil)
    case "startBrowsing":
      guard let me = ensurePeer() else {
        result(FlutterError(code: "no_peer", message: "configure first", details: nil))
        return
      }
      browser?.stopBrowsingForPeers()
      let b = MCNearbyServiceBrowser(peer: me, serviceType: YardChannel.serviceType)
      b.delegate = self
      b.startBrowsingForPeers()
      browser = b
      result(nil)
    case "stopBrowsing":
      browser?.stopBrowsingForPeers()
      browser = nil
      knownPeers.removeAll()
      result(nil)
    case "knock":
      guard let me = ensurePeer(),
        let id = args["id"] as? String,
        let target = knownPeers[id],
        let hello = (args["hello"] as? FlutterStandardTypedData)?.data,
        hello.count <= YardChannel.maxContextBytes,
        let b = browser
      else {
        result(FlutterError(code: "bad_knock", message: "unknown den", details: nil))
        return
      }
      teardownSession()
      hosting = false
      let s = MCSession(peer: me, securityIdentity: nil, encryptionPreference: .required)
      s.delegate = self
      session = s
      b.invitePeer(target, to: s, withContext: hello, timeout: 25)
      result(nil)
    case "approve", "ignore":
      guard let id = args["id"] as? String, let handler = pendingInvites.removeValue(forKey: id)
      else {
        result(nil)
        return
      }
      if call.method == "approve", let s = session,
        s.connectedPeers.count < capacity - 1
      {
        handler(true, s)
      } else {
        handler(false, nil)
      }
      result(nil)
    case "send":
      guard let s = session,
        let bytes = (args["data"] as? FlutterStandardTypedData)?.data,
        bytes.count <= YardChannel.maxFrameBytes,
        !s.connectedPeers.isEmpty
      else {
        result(nil)
        return
      }
      do {
        try s.send(bytes, toPeers: s.connectedPeers, with: .reliable)
      } catch {
        emit(["type": "error", "message": "send failed"])
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func ensurePeer() -> MCPeerID? {
    return peerID
  }

  private func teardownSession() {
    session?.disconnect()
    session?.delegate = nil
    session = nil
  }

  @objc private func didWake() {
    if let adv = advertiser {
      adv.stopAdvertisingPeer()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        guard let self, self.advertiser === adv else { return }
        adv.startAdvertisingPeer()
      }
    }
    if let b = browser {
      b.stopBrowsingForPeers()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        guard let self, self.browser === b else { return }
        b.startBrowsingForPeers()
      }
    }
  }

  func advertiser(
    _ advertiser: MCNearbyServiceAdvertiser,
    didReceiveInvitationFromPeer peer: MCPeerID,
    withContext context: Data?,
    invitationHandler: @escaping (Bool, MCSession?) -> Void
  ) {
    guard hosting, let s = session else {
      invitationHandler(false, nil)
      return
    }
    guard s.connectedPeers.count < capacity - 1,
      let hello = context,
      hello.count <= YardChannel.maxContextBytes
    else {
      invitationHandler(false, nil)
      return
    }
    let id = idFor(peer)
    knownPeers[id] = peer
    pendingInvites[id] = invitationHandler
    emit([
      "type": "knock",
      "id": id,
      "hello": FlutterStandardTypedData(bytes: hello),
    ])
    DispatchQueue.main.asyncAfter(deadline: .now() + 24) { [weak self] in
      guard let self, let handler = self.pendingInvites.removeValue(forKey: id) else { return }
      handler(false, nil)
      self.emit(["type": "knockExpired", "id": id])
    }
  }

  func advertiser(
    _ advertiser: MCNearbyServiceAdvertiser,
    didNotStartAdvertisingPeer error: Error
  ) {
    emit(["type": "error", "message": "advertise failed"])
  }

  func browser(
    _ browser: MCNearbyServiceBrowser,
    foundPeer peer: MCPeerID,
    withDiscoveryInfo info: [String: String]?
  ) {
    guard info?["v"] == "1" else { return }
    let id = idFor(peer)
    knownPeers[id] = peer
    let name = String((info?["name"] ?? "a den").prefix(24))
    emit(["type": "denFound", "id": id, "name": name])
  }

  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peer: MCPeerID) {
    let id = idFor(peer)
    knownPeers.removeValue(forKey: id)
    emit(["type": "denLost", "id": id])
  }

  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    emit(["type": "error", "message": "browse failed"])
  }

  func session(_ session: MCSession, peer peerIDChanged: MCPeerID, didChange state: MCSessionState)
  {
    guard session === self.session else { return }
    let id = idFor(peerIDChanged)
    knownPeers[id] = peerIDChanged
    let name: String
    switch state {
    case .connecting: name = "connecting"
    case .connected: name = "connected"
    default: name = "gone"
    }
    emit(["type": "peerState", "id": id, "state": name])
  }

  func session(_ session: MCSession, didReceive data: Data, fromPeer peer: MCPeerID) {
    guard session === self.session, data.count <= YardChannel.maxFrameBytes else { return }
    emit([
      "type": "data",
      "id": idFor(peer),
      "bytes": FlutterStandardTypedData(bytes: data),
    ])
  }

  func session(
    _ session: MCSession, didReceive stream: InputStream, withName streamName: String,
    fromPeer peerID: MCPeerID
  ) {}

  func session(
    _ session: MCSession, didStartReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID, with progress: Progress
  ) {}

  func session(
    _ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?
  ) {}
}
