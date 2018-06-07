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

}
