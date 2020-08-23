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
import FirebaseFirestore

class GetImageViewController: UIViewController {

    @IBOutlet weak var getImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getButtonTapped(_ sender: Any) {
        self.setFirestoreTestData(restaurant_name:"restaurant_A")
        self.setFirestoreTestData(restaurant_name:"restaurant_B")
        self.setFirestoreTestData(restaurant_name:"restaurant_C")
//        let storage = Storage.storage()
//        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
//        let islandRef = storageRef.child("image/00861DAC-393B-488B-A963-A93A188A687B/0.jpg")
//        islandRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
//          if let error = error {
//            // Uh-oh, an error occurred!
//            print("error")
//            print("\(error)")
//          } else {
//            // Data for "images/island.jpg" is returned
//            let image = UIImage(data: data!)
//            self.getImageView.image = image
//          }
//        }

    }
    

}

extension GetImageViewController{
    private func setFirestoreTestData(restaurant_name:String){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("restaurants").document()
        let document_id = ref!.documentID
        let submit_data = [
            "id": document_id,
            "restaurant_name": restaurant_name,
            "created_at": Date(),
            "review_score": 5,
            "image_url": ["urlA","urlB","最新３件のみ"],
            "latest_comments": ["comment_A","comment_B","comment_C"],
            "icao_code":["AAAA","BBBB","CCCC"]
        ] as [String : Any]
        ref?.setData(submit_data){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
