//
//  PastSearch.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/7/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import Realm

class PastSearch: RLMObject {
    
    @objc dynamic var image: UIImage?
    @objc dynamic var name: String?
    var products: [Product]?
    
}
