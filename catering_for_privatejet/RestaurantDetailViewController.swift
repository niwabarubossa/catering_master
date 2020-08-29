//
//  RestaurantDetailViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/24.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var ICAOCodeLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var mailadressLabel: UILabel!
    @IBOutlet weak var contactPersonLabel: UILabel!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var canSpeakEnglishLabel: UILabel!
    @IBOutlet weak var canDelivveryToTheAirportLabel: UILabel!
    @IBOutlet weak var halalAvailableLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    var data:Dictionary<String,Any> = [:]{
        didSet{
            self.setInputValue(data: data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setData(notification:)), name: .notifyTempDataToRestaurantDetail, object: nil)
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
        self.adressLabel.text = data["adress"] as? String
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
    
}
