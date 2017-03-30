//
//  BroadcastViewController.swift
//  Odd-e
//
//  Created by Jackson Zhang on 21/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import UIKit
import SocketIO
import LFLiveKit

class BroadcastViewController: UIViewController {
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .medium3)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()

    let socket = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forceWebsockets(true)])
    var room: LiveRoom!
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var inputTitleOverlay: UIVisualEffectView!
    

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        session.running = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = false
        stopBroadcasting()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func startBroadcasting(){
        room = LiveRoom(title: titleField.text!)
        
        socket.once("connect") { [weak self] data, ack in
            guard let this = self else {
                return
            }
            this.socket.emit("create_room", this.room.toDict())
        }
        socket.once("room_ready") { [weak self] data, ack in
            guard let this = self else {
                return
            }

            if let room = data[0] as? [String: Any] {
                let stream = LFLiveStreamInfo()
                stream.url = "\(Config.rtmpPushUrl)\(room["key"]!)"
                print(stream.url)
                this.session.startLive(stream)
            }
        }

        socket.connect()
    }
    
    private func stopBroadcasting(){
        guard room != nil else {
            return
        }
        session.stopLive()
        socket.disconnect()
    }

    @IBAction func startButtonPressed(_ sender: DesignableButton) {
        titleField.resignFirstResponder()
        startBroadcasting()
        UIView.animate(withDuration: 0.2, animations: {
            self.inputTitleOverlay.alpha = 0
        }, completion: { finished in
            self.inputTitleOverlay.isHidden = true
        })
    }
    
    @IBAction func closeButtonPressed(_ sender: DesignableButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension BroadcastViewController: LFLiveSessionDelegate {
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("State: \(state)")
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode)")
    }
}
