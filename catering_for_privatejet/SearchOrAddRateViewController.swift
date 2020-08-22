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
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSearchResultPage", sender: nil)
    }
    
    @IBAction func addRateButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddRatePage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let vc = segue.destination as? UIViewController {
            vc.modalPresentationStyle = .fullScreen
        }
    }
}
