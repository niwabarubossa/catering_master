//
//  InputAddRateViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/26.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Cosmos

class InputAddRateViewController: UIViewController{
    
    @IBOutlet weak var restaurantTextField: UITextField!
    @IBOutlet weak var firstICAOTextField: UITextField!
    @IBOutlet weak var secondICAOTextField: UITextField!
    @IBOutlet weak var thirdICAOTextField: UITextField!
    @IBOutlet weak var telephoneNumberTextField: UITextField!
    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var restaurantAdressTextField: UITextField!
    @IBOutlet weak var contactPersonTextField: UITextField!
    @IBOutlet weak var isDeliveryToAirportSwitch: UISegmentedControl!
    @IBOutlet weak var canSpeakEnglishSwitch: UISegmentedControl!
    @IBOutlet weak var halalAvailableSwitch: UISegmentedControl!
    let segmentIndexConvertToString:Dictionary<Int,String> = [0:"yes",1:"no"]
    @IBOutlet weak var otherTipsTextView: UITextView!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var cosmosView: CosmosView!
    var cosmosViewRateValue:Double = 0.0
    
    var data:Dictionary<String,Any> = [:]
    var pngImageArray:[Data] = []
    var restaurantDocumentId = ""
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    

     override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewSetup()
        self.inputSetUp()
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
    
    private func inputSetUp(){
        let textFieldArray:[UITextField] = [restaurantTextField,firstICAOTextField,secondICAOTextField,thirdICAOTextField,telephoneNumberTextField,emailAdressTextField,restaurantAdressTextField,contactPersonTextField]
        for textField in textFieldArray {
            textField.delegate = self
        }
        self.cosmosView.settings.fillMode = .half
        cosmosView.didFinishTouchingCosmos = { rating in
            self.cosmosViewRateValue = rating
        }
    }

     @objc func setData(notification: NSNotification?) {
//        let data = notification?.userInfo!["restaurant_name"]
        print("notification?.userInfo")
        print("\(notification?.userInfo)")
     }
    
    @IBAction func submitRate(_ sender: Any) {
        if let restaurantDocumentId = data["restaurant_id"]{
            //２回め以降の場合
            self.restaurantDocumentId = restaurantDocumentId as! String
            //self.updateToFirestore(ref: newRestaurantDocumentRef, data: newRestaurantData)
        }else{
            let newRestaurantDocumentRef = Firestore.firestore().collection("restaurants").document()
            self.restaurantDocumentId = newRestaurantDocumentRef.documentID
            let newRestaurantData:[String:Any] = [
                "restaurant_id": newRestaurantDocumentRef.documentID,
                "restaurant_name": self.restaurantTextField.text!,
                "ICAOCodeArray": [self.firstICAOTextField.text!,self.secondICAOTextField.text!,self.thirdICAOTextField.text!],
                "telephone_number": self.telephoneNumberTextField.text!,
                "email_adress": self.emailAdressTextField.text!,
                "adress": self.restaurantAdressTextField.text!,
                "contact_person": self.contactPersonTextField.text!,
                "delivery_to_the_airport":self.segmentIndexConvertToString[self.isDeliveryToAirportSwitch.selectedSegmentIndex]!,
                "speak_english": self.segmentIndexConvertToString[self.canSpeakEnglishSwitch.selectedSegmentIndex]!,
                "halal_available": self.segmentIndexConvertToString[self.halalAvailableSwitch.selectedSegmentIndex]!,
                "rating": self.cosmosViewRateValue,
                "other_tips": self.otherTipsTextView.text,
                "comment": self.commentTextView.text,
                "created_at": Date()
            ]
            self.saveToFirestore(ref: newRestaurantDocumentRef, data: newRestaurantData)
        }
        //restaurantに
        for pngImage in pngImageArray {
            self.saveToFireStorage(data: pngImage)
            //ひもづいてfirestoreにも保存している（image＿urlを）
        }
    }
    
}

extension InputAddRateViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
      self.view.endEditing(true)
      return true
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
        let reference = storageRef.child("image/" + String(Int.random(in: 1 ... 100000)) + ".jpg")
        reference.putData(data, metadata: nil, completion: { metaData, error in
            if let path = metaData?.name{
                self.saveImagePathToFirestore(path: path)
            }
        })
    }
    
    private func saveImagePathToFirestore(path:String){
        // submit -------------------------------------------------------------------------------------
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("restaurants").document(self.restaurantDocumentId).collection("images").document()
        let document_id = ref?.documentID as! String
        let submit_data = [
            "id": document_id,
            "path":path,
            "created_at": Date(),
        ] as [String : Any]
        self.saveToFirestore(ref: ref, data: submit_data)
    }
    
    private func saveToFirestore(ref:DocumentReference?,data:[String:Any]){
        ref?.setData(data){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}
