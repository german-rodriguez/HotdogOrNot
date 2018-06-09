//
//  RealmManager.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/9/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared = RealmManager()
    private var realm = try! Realm()
    
    func create(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(object: Object) {
        realm.delete(object)
    }
    
    func search<T: Object>(type: T.Type) -> Results<T>{
        return realm.objects(type)
    }
}
