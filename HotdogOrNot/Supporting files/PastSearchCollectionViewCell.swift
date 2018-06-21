//
//  PastSearchCollectionViewCell.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/9/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit

class PastSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchTermLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!

    var isWobbling: Bool = false

    func setUp(searchTerm: String, imageData: NSData){
        self.searchTermLabel.text = searchTerm.capitalized
        self.searchImage.image = UIImage(data: imageData as Data)
    }

    func startWobbling () {
        guard self.transform == CGAffineTransform.identity else { return }  // Stop a duplicated animation
        let r = CGFloat(arc4random_uniform(1)) - 0.5
        let rotateDegree: CGFloat = 2.0
        let leftWobble = CGAffineTransform.identity.rotated(by: self.radians(degrees: rotateDegree * -1 - r))
        let rightWobble = CGAffineTransform.identity.rotated(by: self.radians(degrees: rotateDegree + r))
        self.transform = leftWobble
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse],
                       animations: {
                        self.transform = rightWobble
        }, completion: { _ in
        })
        self.isWobbling = true
    }
    
    func stopWobbling () {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform.identity
        self.isWobbling = false
    }

    func radians(degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat.pi) / 180.0
    }
}
