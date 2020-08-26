//
//  SearchRestaurantWhenAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class SearchRestaurantWhenAddRateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var sendIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    var dataSource:[Dictionary<String,Any>] = [
        ["test":"test"],
        ["test":"test"],
        ["test":"test"],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        //did select使うやつ
        self.tableView.isHidden = false
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
        if let restaurantName = self.dataSource[indexPath.row]["test"]{
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

