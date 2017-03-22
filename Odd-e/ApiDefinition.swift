//
//  ApiDefinition.swift
//  Odd-e
//
//  Created by Jackson Zhang on 06/03/2017.
//  Copyright © 2017 Odd-e. All rights reserved.
//

import Foundation
import Moya

enum ApiDefinition {
    case getRooms
}

protocol Authorizable {
    var shouldAuthorize: Bool { get }
}

// MARK: - TargetType Protocol Implementation
extension ApiDefinition: TargetType, Authorizable {
    /// Provides stub data for use in testing.
    public var sampleData: Data {
        return Data()
    }

    internal var shouldAuthorize: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var baseURL: URL { return URL(string: Config.serverUrl)! }
    var path: String {
        switch self {
        case .getRooms:
            return "/rooms"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getRooms:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .getRooms:
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    var task: Task {
        return .request
    }
}
