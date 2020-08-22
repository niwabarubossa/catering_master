//
//  SearchResultViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/05.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource:[Dictionary<String,String>] = [
        ["resutaurantName":"レストランA",
         "adress": "adressA"
        ],
        ["resutaurantName":"レストランB",
         "adress": "adressB"
        ],
        ["resutaurantName":"レストランC",
         "adress": "adressC"
        ],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
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
        cell.restaurantNameLabel.text = self.dataSource[indexPath.row]["resutaurantName"]
        cell.adressLabel.text = self.dataSource[indexPath.row]["adress"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 180
     }

}




