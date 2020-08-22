//
//  GetImageViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/21.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class GetImageViewController: UIViewController {

    @IBOutlet weak var getImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getButtonTapped(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
        let islandRef = storageRef.child("image/00861DAC-393B-488B-A963-A93A188A687B/0.jpg")
        islandRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print("error")
            print("\(error)")
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.getImageView.image = image
          }
        }
    }
    

}
