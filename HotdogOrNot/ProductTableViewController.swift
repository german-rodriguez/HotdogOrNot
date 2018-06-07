//
//  ProductTableViewController.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/1/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {

    var productArray: [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell
        let product = productArray[indexPath.row]
        guard let title = product.title, let hasFreeShipping = product.hasFreeShipping, let acceptsMercadopago = product.acceptsMercadopago, let averageRating = product.averageRating, let thumbnail = product.thumbnail else { return cell }
        cell.productName.text = title
        cell.freeShipping.isHidden = hasFreeShipping
        cell.mercadoPago.isHidden = acceptsMercadopago
        cell.productThumbnail.image = thumbnail
        cell.ratingStars.forEach({
            if cell.ratingStars.index(of: $0)! < Int(averageRating) {
                $0.image = UIImage(named: "star-filled")
            } else {
                $0.image = UIImage(named: "star")
            }
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = productArray[indexPath.row]
        guard let url = URL(string: cell.link!) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //add a better gesture
    @objc func swipedLeft(){
        self.dismiss(animated: true, completion: nil)
    }
}
