//
//  Result.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/1/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import Gloss

class Result: Glossy {
    
    var title: String?
    var acceptsMercadopago: Bool?
    var quantity: Int?
    var link: String?
    var averageRating: Double?
    var freeShipping: Bool?
    var thumbnailURL: String?

    required init?(json: JSON) {
        title = "title" <~~ json
        acceptsMercadopago = "accepts_mercadopago" <~~ json
        quantity = "available_quantity" <~~ json
        link = "permalink" <~~ json
        averageRating = "reviews.rating_average" <~~ json
        freeShipping = "shipping.free_shipping" <~~ json
        thumbnailURL = "thumbnail" <~~ json
    }
    
    func toJSON() -> JSON? {
        return nil
    }
    
    
}
