//
//  Artifact.swift
//  Modify
//
//  Created by Олег Адамов on 24.08.17.
//  Copyright © 2017 Envent. All rights reserved.
//

import RealmSwift
import CoreLocation

class Artifact: RealmSwift.Object, Codable {
    @objc dynamic var objectId: String = NSUUID().uuidString
    @objc dynamic var initialBlock: Block?
    
    let blocks = List<Block>()
    
    override static func primaryKey() -> String? {
        return "objectId"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}