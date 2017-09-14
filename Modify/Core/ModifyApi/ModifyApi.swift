//
//  ModifyApi.swift
//  Modify
//
//  Created by Alex Shevlyakov on 08/09/2017.
//  Copyright © 2017 Envent. All rights reserved.
//

import Foundation
import Moya
import CoreLocation

struct ModifyApi {
    enum User {
        case login(deviceId: String)
        case update(locale: String?, pushToken: String?, platform: String?, position: CLLocationCoordinate2D?)
        case updatePosition(CLLocationCoordinate2D)
    }

    enum Artifact {
        case getByBounds(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    }
    
    enum Block {
        case add(data: Data)
        case delete(blockId: String)
    }
}

extension ModifyApi {
    static let baseURL = { URL(string: "http://192.168.1.130:1323")! }()
    static let headers = ["Content-type": "application/json"]
    static let sampleData = { "{\"status\": \"ok\", \"result\": {}".utf8Encoded }()
}

extension ModifyApi.User {
    struct Response: Decodable {
        let status: String
        let result: LoginResult
    }
    struct LoginResult: Decodable {
        let token: String
    }
}

extension ModifyApi.Artifact {
    struct Response: Decodable {
        let status: String
        let result: [Artifact]
    }
}

extension ModifyApi.User: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return ModifyApi.baseURL }
    var headers: [String: String]? { return ModifyApi.headers }
    var sampleData: Data { return ModifyApi.sampleData }
    var method: Moya.Method { return .post }
    
    var path: String {
        switch self {
        case .login:  return "/user/login"
        case .update: return "/user/update"
        case .updatePosition: return "/user/updatePosition"
        }
    }
    
    var task: Task {
        switch self {
        case .login(let deviceId):
            return .requestParameters(parameters: ["device_id": deviceId], encoding: JSONEncoding.default)
            
        case .update(let locale, let pushToken, let platform, let position):
            var params = [String: Any]()
            if let loc    = locale    { params["locale"]     = loc }
            if let push   = pushToken { params["push_token"] = push }
            if let pltfrm = platform  { params["platform"]   = pltfrm }
            if let pos    = position  { params["position"]   = ["latitude": pos.latitude, "longitude": pos.longitude] }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .updatePosition(let position):
            return .requestParameters(parameters: ["latitude": position.latitude, "longitude": position.longitude], encoding: JSONEncoding.default)
        }
    }
    
    var authorizationType: AuthorizationType {
        if case .login = self { return .none }
        return .bearer
    }
}

extension ModifyApi.Artifact: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return ModifyApi.baseURL }
    var headers: [String: String]? { return ModifyApi.headers }
    var sampleData: Data { return ModifyApi.sampleData }
    var method: Moya.Method { return .post }
    var authorizationType: AuthorizationType { return .bearer }
    
    var path: String { return "/artifact/getByBounds" }
    
    var task: Task {
        switch self {
        case .getByBounds(let from, let to):
            return .requestParameters(parameters: [
                    "from": from.toDictionary,
                    "to": to.toDictionary
                ], encoding: JSONEncoding.default)
        }
    }
}

extension ModifyApi.Block {
    struct Response:Decodable {
        let status: String
    }
}
extension ModifyApi.Block: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return ModifyApi.baseURL }
    var headers: [String: String]? { return ModifyApi.headers }
    var sampleData: Data { return ModifyApi.sampleData }
    var method: Moya.Method { return .post }
    var authorizationType: AuthorizationType { return .bearer }
    
    var path: String {
        switch self {
        case .add:    return "/block/add"
        case .delete: return "/block/delete"
        }
    }
    
    var task: Task {
        switch self {
        case .add(let data):       return .requestParameters(parameters: ["block": data],       encoding: JSONEncoding.default)
        case .delete(let blockId): return .requestParameters(parameters: ["block_id": blockId], encoding: JSONEncoding.default)
        }
    }
}


// MARK: - Helpers
private extension CLLocationCoordinate2D {
    var toDictionary: [String:CLLocationDegrees] {
        return ["latitude": self.latitude, "longitude": self.longitude]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
