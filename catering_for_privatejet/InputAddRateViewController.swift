//
//  InputAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseStorage

class InputAddRateViewController: UIViewController {

    var data:Dictionary<String,Any> = [:]

     override func viewDidLoad() {
         super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(setData(notification:)), name: .notifyTempDataToAddRatePage, object: nil)
     }

     @objc func setData(notification: NSNotification?) {
//        let data = notification?.userInfo!["restaurant_name"]
        print("notification?.userInfo")
        print("\(notification?.userInfo)")
     }
    @IBAction func testButtonTapped(_ sender: Any) {
    }
    @IBAction func testButton2Tapped(_ sender: Any) {
    }
    @IBAction func testButton3Tapped(_ sender: Any) {
    }
    
    
    @IBAction func submitRate(_ sender: Any) {
    }
    
}


extension InputAddRateViewController: UINavigationControllerDelegate {
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
//ok
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension InputAddRateViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let selectedUIImage = info[.originalImage] as! UIImage
        if let pngImage = selectedUIImage.pngData() {
            self.saveToFireStorage(data: pngImage)
        }
            dismiss(animated: true, completion: nil)
    }
    private func saveToFireStorage(data: Data){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
        let reference = storageRef.child("image/" + NSUUID().uuidString + "/" + String(Int.random(in: 1 ... 100)) + ".jpg")
        reference.putData(data, metadata: nil, completion: { metaData, error in
            print(metaData)
            print(error)
        })
    }
}
