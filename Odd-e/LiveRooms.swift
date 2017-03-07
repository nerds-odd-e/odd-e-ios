//
// Created by Jackson Zhang on 06/03/2017.
// Copyright (c) 2017 Odd-e. All rights reserved.
//

import Foundation

class LiveRooms {
    private var rooms = Array<DTO.LiveRoom>()
    private var api: Api

    var count: Int {
        return rooms.count
    }

    convenience init(){
        self.init(api: Api())
    }

    init(api: Api){
        self.api = api
    }

    func fetch(to action: @escaping () -> Void){
        api.getRooms() { [unowned self] rooms in
            self.rooms = rooms
            action()
        }
    }

    subscript(index: Int) -> LiveRoom {
        get {
            return LiveRoom.from(rooms[index])
        }
    }
}
