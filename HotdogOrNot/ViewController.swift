//
//  ViewController.swift
//  HotdogOrNot
//
//  Created by German Rodriguez on 6/14/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class ViewController: UIViewController {
    
    // MARK: Variables
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellWobble: Bool = false
    var pastSearchList = [PastSearch]()
    var productArray: [Product]?
    let imagePicker = UIImagePickerController()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        let nib = UINib.init(nibName: "PastSearchCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "pastSearchCollectionViewCell")

        imagePicker.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(startWobblingCells))
        collectionView.addGestureRecognizer(longTap)
        let shortTap = UITapGestureRecognizer(target: self, action: #selector(stopWobblingCells))
        imageView.addGestureRecognizer(shortTap)
    }
    
    @objc func startWobblingCells(){
        cellWobble = true
        collectionView.visibleCells.forEach({ cell in
            guard let cell = cell as? PastSearchCollectionViewCell else { return }
            cell.startWobbling()
        })
    }
    
    @objc func stopWobblingCells(){
        cellWobble = false
        collectionView.visibleCells.forEach({ cell in
            guard let cell = cell as? PastSearchCollectionViewCell else { return }
            cell.stopWobbling()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPastSearchData()
        collectionView.reloadData()
    }
    
    // MARK: Search
    func performSearch(withName productName: String){
        SVProgressHUD.show()
        API.shared.searchProduct(withName: productName) { productArray in
            self.productArray = productArray
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let search = PastSearch()
                let image = self.imageView.image!.cropToBounds(width: 299, height: 299)
                search.imageData = NSData(data: UIImagePNGRepresentation(image)!)
                search.name = productName
                search.products = List<Product>()
                search.products.append(objectsIn: productArray)
                RealmManager.shared.create(object: search)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToProducts", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "goToProducts":
            guard let navController = segue.destination as? UINavigationController, let destination = navController.viewControllers.first as? ProductTableViewController else { return }
            destination.productArray = productArray
        default:
            return
        }
    }
    
    func loadPastSearchData(){
        pastSearchList = []
        let managedItems = RealmManager.shared.search(type: PastSearch.self)
        managedItems.forEach({
            let search = PastSearch(value: $0)
            pastSearchList.append(search) })
        pastSearchList.forEach({ $0.products.forEach({ $0.getImage() }) })
    }
}

// MARK: - CollectionView Methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastSearchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastSearchCollectionViewCell", for: indexPath) as! PastSearchCollectionViewCell
        let pastSearch = pastSearchList[indexPath.row]
        cell.setUp(searchTerm: pastSearch.name, imageData: pastSearch.imageData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PastSearchCollectionViewCell else { return }
        if cell.isWobbling {
            let alert = UIAlertController(title: nil, message: "Delete \(cell.searchTermLabel.text!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                let search = self.pastSearchList[indexPath.row]
                RealmManager.shared.delete(type: PastSearch.self, key: search.name)
                self.loadPastSearchData()
                self.collectionView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in self.stopWobblingCells() }))
            self.present(alert, animated: true)
        } else {
            var products = [Product]()
            products.append(contentsOf: pastSearchList[indexPath.row].products)
            self.productArray = products
            imageView.image = UIImage(data: pastSearchList[indexPath.row].imageData as Data)
            performSegue(withIdentifier: "goToProducts", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PastSearchCollectionViewCell else { return }
        if cellWobble, !cell.isWobbling {
            cell.startWobbling()
        } else {
            cell.stopWobbling()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PastSearchCollectionViewCell else { return }
        cell.stopWobbling()
    }
}

// MARK: ImagePicker
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        fatalError("Override")
    }
}
