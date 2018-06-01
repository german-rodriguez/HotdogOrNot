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

class ViewController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var imageView: UIImageView!
    
    let model = Inceptionv3()
    let modelInputSize = CGSize(width: 299, height: 299)
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        imagePicker.delegate = self
        
        tabBar.items!.forEach({
            $0.title = nil
            $0.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        })
    }
    
    // MARK: Tab bar
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("camera")
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
        Mercadolibre().searchProduct(withName: String(output.classLabel.split(separator: ",").first!), completion: nil)
//        output.classLabel.split(separator: ",").forEach({ Mercadolibre().searchProduct(withName: String($0)) })
    }
}
