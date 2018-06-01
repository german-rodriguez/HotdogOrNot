//
//  Mercadolibre.swift
//  HotdogOrNot
//
//  Created by SP21 on 31/5/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import Gloss

class Mercadolibre {
 
    func searchProduct(withName product: String, completion: (([Result]) -> Void)?){
        let url = "https://api.mercadolibre.com/sites/MLA/search?q=\(product)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                let json = json as! JSON
                let results = json["results"] as! [JSON]
                var resultsArray = [Result]()
                results.forEach({ if let result = Result(json: $0) { resultsArray.append(result) }})
            case .failure(let error):
                print(error)
            }
//            let resultArray = json["results"]
//            print(resultArray)
        }
    }
}
