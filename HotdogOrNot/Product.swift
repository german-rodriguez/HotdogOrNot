//
//  Result.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/1/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift
import Realm

class Product: Object, Glossy {
    
    @objc dynamic var title: String = ""
    @objc dynamic var acceptsMercadopago: Bool = false
    @objc dynamic var link: String = ""
    var averageRating = RealmOptional<Double>()
    @objc dynamic var hasFreeShipping: Bool = false
    @objc dynamic var thumbnailURL: String = ""
    var thumbnail: UIImage?
    
    convenience required init?(json: JSON) {
        self.init()
        title = ("title" <~~ json ?? "")
        acceptsMercadopago = ("accepts_mercadopago" <~~ json ?? false)
        link = ("permalink" <~~ json ?? "")
        averageRating.value = "reviews.rating_average" <~~ json
        hasFreeShipping = ("shipping.free_shipping" <~~ json ?? false)
        self.thumbnailURL = ("thumbnail" <~~ json ?? "")
        self.getImage()
    }
    
    func getImage() {
        guard self.thumbnail != #imageLiteral(resourceName: "image-not-found") else { return }
        API.shared.fetchImage(withURL: self.thumbnailURL) { (image) in
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
