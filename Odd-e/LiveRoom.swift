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

    init(title: String){
        self.title = title
    }
    
    class func from(_ dto: DTO.LiveRoom) -> LiveRoom! {
        let room = LiveRoom(title: dto.title)
        return room
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "title": title as AnyObject,
            "key": key as AnyObject
        ]
    }
}
