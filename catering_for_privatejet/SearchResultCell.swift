//
//  SearchResultCell.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/05.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseStorage
import Cosmos

class SearchResultCell: UITableViewCell {

    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ICAOCodeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var adressTextView: UITextView!
    
//    @IBOutlet weak var adressLabel: UILabel!
    var img_storage_path: String = "" {
        didSet {
            self.getStorageImage(img_storage_path: img_storage_path)
        }
    }
    var firestoreData:Dictionary<String,Any> = [:]{
        didSet{
            self.setDataToDisplay(data:firestoreData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setDataToDisplay(data:Dictionary<String,Any>){
        self.restaurantNameLabel.text = data["restaurant_name"] as? String
        if let ICAOCodeArray:[String] = data["ICAOCodeArray"] as? [String] {
            self.ICAOCodeLabel.text = ICAOCodeArray[0] + "  " + ICAOCodeArray[1] + " " + ICAOCodeArray[2]
        }
//        self.adressLabel.text = data["adress"] as? String
        self.createLinkToMap()
        self.calculateRate()
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

extension SearchResultCell:UITextViewDelegate{
    private func createLinkToMap(){
        let baseString = firestoreData["adress"] as? String ?? ""
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: baseString,
                                      range: NSString(string: baseString).range(of: baseString))
        adressTextView.attributedText = attributedString
        adressTextView.isSelectable = true
        adressTextView.isEditable = false
        adressTextView.delegate = self
    }
    
    private func calculateRate(){
        self.cosmosView.settings.fillMode = .precise
        var ratingScore = (firestoreData["total_rating_score_amount"] as? Int ?? 0 ) / (firestoreData["review_amount"] as? Int ?? 1)
        if ratingScore == 0 { ratingScore = 5 }
        self.cosmosView.settings.totalStars = ratingScore
    }
}
