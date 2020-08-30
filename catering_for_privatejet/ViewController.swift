//
//  ViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/05.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething(notification:)), name: .dismissLegalPage, object: nil)
    }
    
    @objc func doSomething(notification: NSNotification?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension Notification.Name {
   static let dismissLegalPage = Notification.Name("dismissLegalPage")
}
