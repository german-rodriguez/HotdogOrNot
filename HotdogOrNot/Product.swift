//
//  Result.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/1/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import Gloss

class Product: Glossy {
    
    var title: String?
    var acceptsMercadopago: Bool?
    var link: String?
    var averageRating: Double?
    var hasFreeShipping: Bool?
//    var thumbnailURL: String?
    var thumbnail: UIImage?
    
    required init?(json: JSON) {
        title = "title" <~~ json
        acceptsMercadopago = "accepts_mercadopago" <~~ json
        link = "permalink" <~~ json
        averageRating = "reviews.rating_average" <~~ json
        hasFreeShipping = "shipping.free_shipping" <~~ json
        let thumbnailURL: String? = "thumbnail" <~~ json
        API().fetchImage(withURL: thumbnailURL!) { (image) in
            if let image = image {
                self.thumbnail = image
            } else {
                self.thumbnail = UIImage(named: "image-not-found")
            }
        }
    }
    
    func toJSON() -> JSON? {
        return nil
    }
    
    
}
