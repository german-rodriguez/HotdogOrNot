//
//  ViewController.swift
//  HotdogOrNot
//
//  Created by SP21 on 31/5/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SVProgressHUD

class ViewController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var imageView: UIImageView!

    let model = Inceptionv3()
    let modelInputSize = CGSize(width: 299, height: 299)
    let imagePicker = UIImagePickerController()
    
    var productArray: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        imagePicker.delegate = self
        
        tabBar.items!.forEach({
            $0.title = nil
            $0.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            print("no cam")
            tabBar.selectedItem = tabBar.items![1]
        } else {
            tabBar.selectedItem = tabBar.items![0]
        }
        
        super.viewWillAppear(animated)
    }
    
    // MARK: Tab bar

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("camera")
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                let alert = UIAlertController(title: nil, message: "Device camera is unavailable", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        case 1:
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            print("image")
        case 2:
            print("draw")
        default:
            return
        }
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
        let firstProduct = String(output.classLabel.split(separator: ",").first!)
        SVProgressHUD.show()
        API().searchProduct(withName: firstProduct) { productArray in
            self.productArray = productArray
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
}
