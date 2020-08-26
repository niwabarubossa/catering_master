//
//  InputAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class InputAddRateViewController: UIViewController {

    var data:Dictionary<String,Any> = [:]

     override func viewDidLoad() {
         super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(setData(notification:)), name: .notifyTempDataToAddRatePage, object: nil)
     }

     @objc func setData(notification: NSNotification?) {
//        let data = notification?.userInfo!["restaurant_name"]
        print("notification?.userInfo")
        print("\(notification?.userInfo)")
     }
}
