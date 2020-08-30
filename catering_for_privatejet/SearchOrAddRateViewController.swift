//
//  SearchOrAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/22.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class SearchOrAddRateViewController: UIViewController {

    
    @IBOutlet weak var ICAOTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          let defaults = UserDefaults.standard
          defaults.register(defaults: ["FirstLaunch" : true])
          if defaults.bool(forKey: "FirstLaunch") == true {
              UserDefaults.standard.set(false, forKey: "FirstLaunch")
              print("初回ログイン")
            let myViewController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirstLegalPage") as! UIViewController
            self.present(myViewController, animated: true, completion: {
                    UserDefaults.standard.set(false, forKey: "FirstLaunch")
            })
          }else{
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            print("２回目以降のログインです")

          }
      }

    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSearchResultPage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchResultPage" {
            let nextVC = segue.destination as! SearchResultViewController
            nextVC.searchingICAOCode = ICAOTextField.text!
        }
    }

}

extension SearchOrAddRateViewController:UITextFieldDelegate{
    private func textFieldSetup(){
        self.ICAOTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        self.view.endEditing(true)
        self.searchButtonTapped(Any.self)
        return true
    }
 }
