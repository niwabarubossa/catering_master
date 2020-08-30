//
//  SearchRestaurantWhenAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SearchRestaurantWhenAddRateViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    private var sendIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    var dataSource:[Dictionary<String,Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.textFieldSetup()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.dataSource = []
        let db = Firestore.firestore()
        db.collection("restaurants").whereField("ICAOCodeArray", arrayContains: self.searchTextField.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.dataSource.append(document.data() as! [String : AnyObject])
                }
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
    }

}

extension SearchRestaurantWhenAddRateViewController: UITableViewDataSource,UITableViewDelegate {
    
    private func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SearchRestaurantNameTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchRestaurantNameTableViewCell")
        self.tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantNameTableViewCell", for: indexPath ) as! SearchRestaurantNameTableViewCell
        cell.selectionStyle = .none
        if let restaurantName = self.dataSource[indexPath.row]["restaurant_name"]{
            cell.restaurantNameLabel.text = restaurantName as! String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.sendIndexPath = indexPath
        self.performSegue(withIdentifier: "goToAddRatePage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddRatePage" {
            let nextVC = segue.destination as! WhenSearchRestaurantTempViewController
            nextVC.data = self.dataSource[self.sendIndexPath.row]
        }
    }
    
}

extension SearchRestaurantWhenAddRateViewController:UITextFieldDelegate{
    private func textFieldSetup(){
        self.searchTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
 }
