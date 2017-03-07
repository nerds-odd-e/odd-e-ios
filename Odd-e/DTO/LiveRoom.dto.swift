//
// Created by Jackson Zhang on 06/03/2017.
// Copyright (c) 2017 Odd-e. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct DTO{
    struct LiveRoom {
        var title: String = ""
    }
}

extension DTO.LiveRoom: Decodable {
    static func decode(_ json: JSON) -> Decoded<DTO.LiveRoom> {
        return curry(DTO.LiveRoom.init)
                <^> json <| "title"
    }
}

