//
//  Run.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-05-31.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var date = NSDate()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    public private(set) var locations = List<Location>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace", "duration", "date"]
    }
    
    convenience init(pace: Int, duration: Int, distance: Double, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, duration: duration, distance: distance, locations: locations)
            do {
                let realm = try Realm(configuration: RealmConfig.realmConfig)
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            } catch {
                debugPrint("Error adding object to Realm")
            }
        }
    }
    
    static func getRuns() -> Results<Run>? {
        do {
            let realm = try Realm(configuration: RealmConfig.realmConfig)
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }
        catch {
            return nil
        }
    }
    
    
}
