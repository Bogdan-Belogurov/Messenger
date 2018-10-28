//
//  MultipeerCommunicator.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 27/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    var delegate: CommunicatorDelegate?
    
    var online: Bool
    let iPeerID: MCPeerID
    let discoveryInfo = ["userName": "Belogurov Bogdan"]
    let serviceType = "tinkoff-chat"
    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?
    var sessions: [String: MCSession] = [:]
    
    var foundPeers = [MCPeerID]()
    
    override init() {
        self.iPeerID = MCPeerID(displayName: UIDevice.current.identifierForVendor?.uuidString ?? UIDevice.current.name)
        self.online = true
        self.advertiser = MCNearbyServiceAdvertiser(peer: iPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: iPeerID, serviceType: serviceType)
        super.init()
        self.browser?.delegate = self
        self.browser?.startBrowsingForPeers()
        self.advertiser?.delegate = self
        self.advertiser?.startAdvertisingPeer()
        print("Start browser and advertiser")
        
    }
    
    func sendMessage(string: String, toUserID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
        if let session = sessions[toUserID] {
            let message = [
                "eventType" : "TextMessage",
                "messageId" : self.generateMessageID(),
                "text": string
            ]
        
            do {
                let data = try JSONSerialization.data(withJSONObject: message)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                completionHandler?(true, nil)
            } catch  {
                completionHandler?(false, error)
            }
        }
    }
    
    func generateMessageID() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func getSession(displayName: String) -> MCSession? {
        var session = self.sessions[displayName]
        
        if let session = session {
            return session
        } else {
            session = MCSession(peer: self.iPeerID, securityIdentity: nil, encryptionPreference: .none)
            session?.delegate = self
            self.sessions[displayName] = session
            return session
        }
    }
    
    deinit {
        self.advertiser?.stopAdvertisingPeer()
        self.browser?.stopBrowsingForPeers()
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Can not start advertising peer MultipeerCommunicator ~>\(#function)")
        self.delegate?.failedToStartAdvertising(error: error)
        self.online = false
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if let session = self.getSession(displayName: peerID.displayName) {
            if !session.connectedPeers.contains(peerID) {
                invitationHandler(true, session)
            }
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)

        if let session = self.getSession(displayName: peerID.displayName) {
            if !session.connectedPeers.contains(peerID) {
                browser.invitePeer(peerID, to: session, withContext: nil, timeout: 7)
                guard let info = info else { return }
                guard let name = info["userName"] else { return }
                self.delegate?.didFoundUser(userID: peerID.displayName, userName: name)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (index, Peer) in foundPeers.enumerated() {
            if Peer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
        sessions.removeValue(forKey: peerID.displayName)
        self.delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Can not start browsing for peers MultipeerCommunicator ~>\(#function)")
        self.delegate?.failedToStartBrowsingforUsers(error: error)
        self.online = false
    }
    
    
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Receive data from \(peerID) data: \(data)")
        do {
            let message = try JSONSerialization.jsonObject(with: data) as! [String : String]
            if let message = message["text"] {
                self.delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: iPeerID.displayName)
            }
        } catch {
            print(error)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
