//
//  ViewController.swift
//  HotdogOrNot
//
//  Created by SP21 on 31/5/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import CoreML
import RealmSwift

// TODO: Images not loading at first in tableviewcontroller

class ImageViewController: ViewController {
    
    let model = Inceptionv3()
    let modelInputSize = CGSize(width: 299, height: 299)

    // MARK: Image picker
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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

        performSearch(withName: firstProductName)
    }
    
    @IBAction func actionAddImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
