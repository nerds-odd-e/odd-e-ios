//
//  LiveRoomTableViewController.swift
//  Odd-e
//
//  Created by Jackson Zhang on 05/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import UIKit
import SVProgressHUD

class LiveRoomsTableViewController: UITableViewController {
    
    private var rooms = LiveRooms()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRooms()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRoomCell", for: indexPath)

        let room = rooms[indexPath.row]
        cell.textLabel!.text = room.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        joinRoom(room)
    }
    
    @IBAction func refreshButtonClick(_ sender: Any) {
        fetchRooms()
    }

    private func joinRoom(_ room: LiveRoom){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let audienceVC = sb.instantiateViewController(withIdentifier: "audience") as! AudienceViewController
        audienceVC.modalPresentationStyle = .popover
        //detailVC.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        audienceVC.room = room
        
        self.present(audienceVC, animated: true, completion: {})
    }

    private func fetchRooms() {
        rooms.fetch(to: refresh)
    }

    private func refresh(){
        DispatchQueue.main.async { [unowned me = self] in
            me.tableView.reloadData()
        }
    }

}
