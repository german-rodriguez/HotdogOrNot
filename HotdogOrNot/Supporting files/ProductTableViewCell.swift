//
//  ProductTableViewCell.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/1/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var ratingStars: [UIImageView]!
    @IBOutlet weak var mercadoPago: UIImageView!
    @IBOutlet weak var freeShipping: UIImageView!
    @IBOutlet weak var productThumbnail: UIImageView!
    @IBOutlet weak var productName: UILabel!

    func setUp(title: String, hasFreeShipping: Bool, acceptsMercadoPago: Bool, averageRating: Double?, thumbnail: UIImage?){
        self.productName.text = title
        self.freeShipping.isHidden = !hasFreeShipping
        self.mercadoPago.isHidden = !acceptsMercadoPago
        self.productThumbnail.image = thumbnail ?? UIImage(named: "image-not-found")
        if let averageRating = averageRating {
            ratingStars.forEach({
                if ratingStars.index(of: $0)! < Int(averageRating) {
                    $0.image = UIImage(named: "star-filled")
                } else {
                    $0.image = UIImage(named: "star")
                }
            })
        } else {
            ratingStars.forEach { $0.isHidden = true }
        }
    }
}
