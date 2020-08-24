//
//  TempViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/24.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    var data:Dictionary<String,Any> = [:] {
        didSet{
            print("data!!")
            print(data)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
