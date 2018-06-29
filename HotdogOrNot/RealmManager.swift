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
    
    func create(object: Object, key: String) {
        guard realm.object(ofType: PastSearch.self, forPrimaryKey: key) == nil else { return }
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(key: String) {
        guard let result = realm.object(ofType: PastSearch.self, forPrimaryKey: key) else { return }
        
        do {
            try realm.write {
                result.products.forEach({ realm.delete($0) })
                realm.delete(result)
            }
        } catch(let error) {
            print(error)
        }
    }
    
    func search<T: Object>(type: T.Type) -> Results<T>{
        return realm.objects(type)
    }
}
