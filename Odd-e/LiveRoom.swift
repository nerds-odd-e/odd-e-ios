//
//  LiveRoom.dto.swift
//  Odd-e
//
//  Created by Jackson Zhang on 05/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import Foundation

class LiveRoom {
    var title = ""
    var key = ""
    var url = ""

    init(title: String){
        self.title = title
    }
    
    class func from(_ dto: DTO.LiveRoom) -> LiveRoom! {
        let room = LiveRoom(title: dto.title)
        room.key = dto.key
        room.url = dto.url
        return room
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "title": title as AnyObject,
            "key": key as AnyObject,
            "url": url as AnyObject
        ]
    }
}
