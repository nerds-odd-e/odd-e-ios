//
//  AudienceViewController.swift
//  Odd-e
//
//  Created by Jackson Zhang on 29/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import UIKit
import SocketIO

class AudienceViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    var room: LiveRoom!

    var player: IJKFFMoviePlayerController!
    let socket = SocketIOClient(socketURL: URL(string: Config.serverUrl)!, config: [.log(true), .forcePolling(true)])


    override func viewDidLoad() {
        super.viewDidLoad()


        let urlString = Config.rtmpPlayUrl + room.key
        print(urlString)
        player = IJKFFMoviePlayerController(contentURLString: urlString, with: IJKFFOptions.byDefault())  //contetURLStrint helps you making a complete stream at rooms with special characters.

        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)


        player.prepareToPlay()

        socket.on("connect") {[weak self] data, ack in
            self?.joinRoom()
        }

        socket.on("close_room") { [weak self] data, ack in
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
        }

    }

    private func joinRoom() {
        socket.emit("join_room", room.key)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
        socket.connect()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in

            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
            default:
                this.statusLabel.text = "Playing"
            }
        })

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.shutdown()
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeButtonPressed(_ sender: DesignableButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

}
