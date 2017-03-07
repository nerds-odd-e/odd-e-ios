//
//  LiveRoom.dto.swift
//  Odd-e
//
//  Created by Jackson Zhang on 05/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import Foundation

class LiveRoom {
    var title: String?
    var key: String?

    class func from(_ dto: DTO.LiveRoom) -> LiveRoom! {
        let room = LiveRoom()
        room.title = dto.title
        return room
    }
}
