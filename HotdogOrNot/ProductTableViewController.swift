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
    var productURL: URL?
    
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
        product.getImage(thumbnailURL: product.thumbnailURL)
        cell.setUp(title: product.title, hasFreeShipping: product.hasFreeShipping, acceptsMercadoPago: product.acceptsMercadopago, averageRating: product.averageRating.value, thumbnail: product.thumbnail)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = productArray[indexPath.row]
        guard let url = URL(string: cell.link) else { return }
        productURL = url
        performSegue(withIdentifier: "goToWebView", sender: nil)
    }
    
    //add a better gesture
    @objc func swipedLeft(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "goToWebView":
            let destination = segue.destination as! ProductLinkViewController
            destination.productURL = productURL
        default:
            return
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
