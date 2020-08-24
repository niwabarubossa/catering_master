//
//  TempViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/24.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    var data:Dictionary<String,Any> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData(data: self.data)
    }
    
    private func setData(data:Dictionary<String,Any>){
        //containerviewの中身を実装しているVCへデータを伝送。UserNotification Post経由で
        NotificationCenter.default.post(name: .notifyTempDataToRestaurantDetail, object: nil, userInfo: data)
    }

}

extension Notification.Name {
   static let notifyTempDataToRestaurantDetail = Notification.Name("notifyTempDataToRestaurantDetail")
}
