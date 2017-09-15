//
//  ApiArtifact.swift
//  Modify
//
//  Created by Alex Shevlyakov on 15/09/2017.
//  Copyright © 2017 Envent. All rights reserved.
//

import Foundation
import Moya

extension Api.Artifact {
    struct Response: Decodable {
        let status: String
        let result: [Artifact]
    }
}

extension Api.Artifact: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return Api.baseURL }
    var headers: [String: String]? { return Api.headers }
    var sampleData: Data { return Api.sampleData }
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
