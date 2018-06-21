//
//  PastSearch.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/7/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class PastSearch: Object {
    
    dynamic var imageData: NSData = NSData()
    dynamic var name: String = ""
    dynamic var products = List<Product>()
    
    convenience init(name: String, imageData: NSData, products: [Product] = []){
        self.init()
        self.name = name
        self.imageData = imageData
        self.products.append(objectsIn: products)
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
