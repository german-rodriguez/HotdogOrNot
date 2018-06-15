//
//  ViewController.swift
//  HotdogOrNot
//
//  Created by SP21 on 31/5/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import CoreML
import SVProgressHUD
import RealmSwift

// TODO: Images not loading at first in tableviewcontroller

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = Inceptionv3()
    let modelInputSize = CGSize(width: 299, height: 299)
    let imagePicker = UIImagePickerController()
    
    var productArray: [Product]?
    var pastSearchList: [PastSearch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "PastSearchCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "pastSearchCollectionViewCell")
        
        imagePicker.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        pastSearchList = []
        let mangedItems = RealmManager.shared.search(type: PastSearch.self)
        mangedItems.forEach({
            let search = PastSearch(value: $0)
            pastSearchList.append(search) })
        pastSearchList.forEach({ $0.products.forEach({ $0.getImage() }) })
        collectionView.reloadData()
    }

    // MARK: Image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard var image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imageView.contentMode = .scaleAspectFit
        image = image.cropToBounds(width: 299, height: 299)
        imageView.image = image
        dismiss(animated: true, completion: nil)
        let resizedImage = image.resizeImage(targetSize: modelInputSize)
        guard let cgImage = resizedImage.cgImage, let pixelBuffer = ImageConverter.pixelBuffer(from: cgImage)?.takeRetainedValue(),
        let output = try? model.prediction(image: pixelBuffer) else { return }
        print(output.classLabel.split(separator: ","))
        let firstProductName = String(output.classLabel.split(separator: ",").first!)

        if let search = pastSearchList.filter({ return $0.name == firstProductName }).first {
            self.productArray = [Product](search.products)
            self.performSegue(withIdentifier: "goToProducts", sender: nil)
        } else {
            SVProgressHUD.show()
            API.shared.searchProduct(withName: firstProductName) { productArray in
                self.productArray = productArray
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let search = PastSearch()
                    search.imageData = NSData(data: UIImagePNGRepresentation(image)!)
                    search.name = firstProductName
                    search.products = List<Product>()
                    search.products.append(objectsIn: productArray)
                    RealmManager.shared.create(object: search)
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToProducts", sender: nil)
                }
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
    
    @IBAction func actionAddImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        var products = [Product]()
        products.append(contentsOf: pastSearchList[indexPath.row].products)
        self.productArray = products
        imageView.image = UIImage(data: pastSearchList[indexPath.row].imageData as Data)
        performSegue(withIdentifier: "goToProducts", sender: nil)
    }
}
