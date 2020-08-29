//
//  SearchResultCell.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/05.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseStorage

class SearchResultCell: UITableViewCell {

    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    var img_storage_path: String = "" {
        didSet {
            self.getStorageImage(img_storage_path: img_storage_path)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension SearchResultCell{
    private func getStorageImage(img_storage_path:String){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
        let islandRef = storageRef.child("image/" + img_storage_path)
        islandRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
          if let error = error {
            print("\(error)")
          } else {
            let image = UIImage(data: data!)
            self.restaurantImageView.image = image
          }
        }

    }
}
