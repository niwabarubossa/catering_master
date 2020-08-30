//
//  RestaurantDetailViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/24.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseFirestore
import FirebaseStorage

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var ICAOCodeLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var mailadressLabel: UILabel!
    @IBOutlet weak var contactPersonLabel: UILabel!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    
    @IBOutlet weak var adressTextView: UITextView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var canSpeakEnglishLabel: UILabel!
    @IBOutlet weak var canDelivveryToTheAirportLabel: UILabel!
    @IBOutlet weak var halalAvailableLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var letImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    
    var data:Dictionary<String,Any> = [:]{
        didSet{
            self.setInputValue(data: data)
            self.getLatestImagePath()
            self.createLinkToMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setData(notification:)), name: .notifyTempDataToRestaurantDetail, object: nil)
        self.setUpImageView()
    }
    
    @objc func setData(notification: NSNotification?) {
        self.data = notification?.userInfo! as! Dictionary<String, Any>
    }
    
    private func setInputValue(data:Dictionary<String,Any>){
        self.restaurantNameLabel.text = data["restaurant_name"] as? String
        if let ICAOArray:[String] = data["ICAOCodeArray"] as? [String]{
            self.ICAOCodeLabel.text = ICAOArray[0] + ICAOArray[1] +  ICAOArray[2]
        }
        self.telephoneNumberLabel.text = data["telephone_number"] as? String
        self.mailadressLabel.text = data["email_adress"] as? String
//        self.adressTextView.text = data["adress"] as? String
        self.contactPersonLabel.text = data["contact_person"] as? String
        self.canSpeakEnglishLabel.text = data["speak_english"] as? String
        self.halalAvailableLabel.text = data["halal_available"] as? String
        self.canDelivveryToTheAirportLabel.text = data["delivery_to_the_airport"] as? String
        if let comments:[String] = data["comment"] as? [String] {
            var displayComment:String = ""
            for comment in comments {
                displayComment += comment + "\n"
            }
            self.commentsLabel.text = displayComment
        }
        self.ratingView.settings.fillMode = .precise
        var ratingScore = (data["total_rating_score_amount"] as? Int ?? 0 ) / (data["review_amount"] as? Int ?? 1)
        if ratingScore == 0 { ratingScore = 5 }
        self.ratingView.settings.totalStars = ratingScore
        
    }
    
    private func getLatestImagePath(){
        let restaurantDocumentId:String = data["restaurant_id"] as? String ?? "data"
        let db = Firestore.firestore()
        db.collection("restaurants").document(restaurantDocumentId).collection("images").order(by: "created_at", descending: true).limit(to: 3).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.getStorageImage(img_storage_path:document.data()["path"] as? String ?? "")
                }
            }
        }
    }
    
    private func getStorageImage(img_storage_path:String){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
        let islandRef = storageRef.child("image/" + img_storage_path)
        islandRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
          if let error = error {
            print("\(error)")
          } else {
            let image = UIImage(data: data!)
            self.setImageToImageView(image: image!)
          }
        }
    }
    
    private func setUpImageView(){
        for imageview in [letImageView,centerImageView,rightImageView] {
            imageview?.isHidden = true
        }
    }
    
    private func setImageToImageView(image:UIImage){
        for imageview in [letImageView,centerImageView,rightImageView] {
            if imageview?.isHidden == true{
                imageview?.isHidden = false
                imageview?.image = image
            }
        }
    }
}

extension RestaurantDetailViewController:UITextViewDelegate{
    private func createLinkToMap(){
        let baseString = data["adress"] as? String ?? ""
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: baseString,
                                      range: NSString(string: baseString).range(of: baseString))
        adressTextView.attributedText = attributedString
        adressTextView.isSelectable = true
        adressTextView.isEditable = false
        adressTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
