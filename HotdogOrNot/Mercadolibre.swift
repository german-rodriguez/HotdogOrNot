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
import SwiftyJSON

class Mercadolibre {
 
    func searchProduct(withName product: String) {
        let url = "https://api.mercadolibre.com/sites/MLA/search?q=\(product)"
        Alamofire.request(url).responseJSON { (json) in
            let json = json as! JSON
            let resultArray = json["results"]
            print(resultArray)
        }
    }
}
