//
//  WhenSearchRestaurantTempViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//
import UIKit

class WhenSearchRestaurantTempViewController: UIViewController {
    
    var data:Dictionary<String,Any> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData(data: self.data)
    }
    
    private func setData(data:Dictionary<String,Any>){
        NotificationCenter.default.post(name: .notifyTempDataToAddRatePage, object: nil, userInfo: data)
    }

}

extension Notification.Name {
   static let notifyTempDataToAddRatePage = Notification.Name("notifyTempDataToAddRatePage")
}
