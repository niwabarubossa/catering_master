//
//  SearchRestaurantWhenAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class SearchRestaurantWhenAddRateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddRatePage", sender: nil)
        //did select使うやつ
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
