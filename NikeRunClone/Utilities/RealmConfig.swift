//
//  RealmConfig.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-06-03.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var realmConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
                    
                }
        }
        )
        return config
    }
}
