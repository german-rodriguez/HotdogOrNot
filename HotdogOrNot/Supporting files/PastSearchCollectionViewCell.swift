//
//  PastSearchCollectionViewCell.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/9/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import Spring

class PastSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchTermLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var springView: SpringView!
    
    func setUp(searchTerm: String, imageData: NSData){
        self.searchTermLabel.text = searchTerm.capitalized
        self.searchImage.image = UIImage(data: imageData as Data)
        springView.animation = "shake"
    }
    
    
}
