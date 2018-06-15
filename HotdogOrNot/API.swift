//
//  Mercadolibre.swift
//  HotdogOrNot
//
//  Created by SP21 on 31/5/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SVProgressHUD
import Gloss

class API {
 
    static var shared = API()
    
    func fetchImage(withURL url: String, completion: ((UIImage?) -> Void)?) {
        Alamofire.request(url.replacingOccurrences(of: "http", with: "https")).responseData { (response) in
            switch response.result {
            case .success(let data):
                completion?(UIImage(data: data))
            case .failure(let error):
                print(error)
                completion?(nil)
            }
        }
    }
    
    func searchProduct(withName product: String, completion: (([Product]) throws -> Void)?) {
        let url = "https://api.mercadolibre.com/sites/MLA/search?q=\(product.replacingOccurrences(of: " ", with: "+"))"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                let json = json as! JSON
                let results = json["results"] as! [JSON]
                print(results)
                var resultsArray = [Product]()
                results.forEach({ if let result = Product(json: $0) {
                    result.getImage()
                    resultsArray.append(result)
                    }})
                try? completion?(resultsArray)
            case .failure(let error):
                print(error)
            }
        }
    }
}
