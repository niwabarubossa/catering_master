//
//  SearchResultViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/05.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var sendIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    
    private var dataSource:[Dictionary<String,Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.getFirestoreData()
    }
}

extension SearchResultViewController: UITableViewDataSource,UITableViewDelegate {
    
    private func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath ) as! SearchResultCell
        cell.selectionStyle = .none
        cell.restaurantNameLabel.text = self.dataSource[indexPath.row]["restaurant_name"] as? String
        if let img_url_array = self.dataSource[indexPath.row]["image_url"] as? [String] {
            cell.img_storage_path = img_url_array[0]
        }
//        cell.img_storage_path = self.dataSource[indexPath.row]["image_url"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 180
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendIndexPath = indexPath
        self.performSegue(withIdentifier: "goToRestaurantDetailPage", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRestaurantDetailPage" {
            let nextVC = segue.destination as! UIViewController
//            nextVC.data = self.dataSource[self.sendIndexPath.row]
        }
    }
    
}

extension SearchResultViewController{
    private func getFirestoreData(){
        let db = Firestore.firestore()
        db.collection("restaurants").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.dataSource.append(document.data())
                }
                self.tableView.reloadData()
            }
        }
    }
}



