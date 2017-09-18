//
//  Block.swift
//  Modify
//
//  Created by Alex Shevlyakov on 07.09.17.
//  Copyright © 2017 Envent. All rights reserved.
//

import RealmSwift
import CoreLocation

class Block: RealmSwift.Object, Codable {
    @objc dynamic var objectId: String = NSUUID().uuidString
    @objc dynamic var author: User?
    @objc dynamic var artifact: Artifact?
    
    @objc dynamic var latitude:  CLLocationDegrees  = 0
    @objc dynamic var longitude: CLLocationDegrees  = 0
    @objc dynamic var altitude:  CLLocationDistance = 0
    
    @objc dynamic var horizontalAccuracy: CLLocationAccuracy = -2
    @objc dynamic var verticalAccuracy:   CLLocationAccuracy = -2
    @objc dynamic var groundDistance:     CLLocationDistance = 0
    
    @objc dynamic var hexColor: String?
    @objc dynamic var createdAt: Date?
    
    override static func primaryKey() -> String? {
        return "objectId"
    }
}


extension Block {
    
    var color: UIColor {
        return UIColor.fromHex(hexColor)
    }
    
    var locationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        return CLLocation(coordinate: locationCoordinate2D, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, timestamp: createdAt ?? Date())
    }
}

