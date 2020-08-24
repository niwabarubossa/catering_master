//
//  RestaurantDetailViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/24.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    var data:Dictionary<String,Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("data")
        print("\(data)")
        NotificationCenter.default.addObserver(self, selector: #selector(piyoFunc(notification:)), name: .notifyTempDataToRestaurantDetail, object: nil)
    }
    
    @objc func piyoFunc(notification: NSNotification?) {
       let data = notification?.userInfo!["restaurant_name"]
    }
    
}
