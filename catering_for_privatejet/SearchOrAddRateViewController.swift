//
//  SearchOrAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/22.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class SearchOrAddRateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSearchResultPage", sender: nil)
    }
    
    @IBAction func addRateButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddRatePage", sender: nil)
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
