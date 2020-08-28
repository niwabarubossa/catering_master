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
    var pngImageArray:[Data] = []
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    

     override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewSetup()
     }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.pickImageFromLibrary()
    }
    
    private func imageViewSetup(){
        let imageViewArray = [leftImageView,centerImageView,rightImageView]
        for imageview in imageViewArray {
            imageview?.isHidden = true
        }
    }

     @objc func setData(notification: NSNotification?) {
//        let data = notification?.userInfo!["restaurant_name"]
        print("notification?.userInfo")
        print("\(notification?.userInfo)")
     }
    
    @IBAction func submitRate(_ sender: Any) {
        for pngImage in pngImageArray {
            self.saveToFireStorage(data: pngImage)
        }
    }
    
}


extension InputAddRateViewController: UINavigationControllerDelegate {
    @objc func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension InputAddRateViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedUIImage = info[.originalImage] as! UIImage
        if let pngImage = selectedUIImage.pngData() {
            self.pngImageArray.append(pngImage)
            let imageViewArray:[UIImageView] = [self.leftImageView,self.centerImageView,self.rightImageView]
            for imageview in imageViewArray {
                if imageview.isHidden == true {
                    imageview.image = selectedUIImage
                    imageview.isHidden = false
                    break;
                }
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    private func saveToFireStorage(data: Data){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://catering-for-private-jet.appspot.com")
        let reference = storageRef.child("image/" + String(Int.random(in: 1 ... 100)) + ".jpg")
        reference.putData(data, metadata: nil, completion: { metaData, error in
            print(metaData?.name)
        })
    }
}
