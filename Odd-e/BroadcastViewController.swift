//
//  BroadcastViewController.swift
//  Odd-e
//
//  Created by Jackson Zhang on 21/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import UIKit
import SocketIO

class BroadcastViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forceWebsockets(true)])
    var room: LiveRoom!
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var inputTitleOverlay: UIVisualEffectView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        socket.connect()
        socket.once("connect") { [weak self] data, ack in
            guard let this = self else {
                return
            }
            this.socket.emit("create_room", this.room.toDict())
        }
    }
    
    private func stopBroadcasting(){
        guard room != nil else {
            return
        }
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
