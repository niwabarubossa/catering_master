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
    
    var data:Dictionary<String,Any> = [:]{
        didSet{
            print("\(data)")
            self.setInputValue(data: data)
        }
    }
    var pngImageArray:[Data] = []
    var restaurantDocumentId = ""
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    

     override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewSetup()
        self.inputSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(setData(notification:)), name: .notifyTempDataToAddRatePage, object: nil)
     }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.pickImageFromLibrary()
    }
    
    private func setInputValue(data:Dictionary<String,Any>){
        self.restaurantTextField.text = data["restaurant_name"] as? String
        if let ICAOArray:[String] = data["ICAOCodeArray"] as? [String]{
            self.firstICAOTextField.text = ICAOArray[0]
            self.secondICAOTextField.text = ICAOArray[1]
            self.thirdICAOTextField.text = ICAOArray[2]
        }
        self.telephoneNumberTextField.text = data["telephone_number"] as? String
        self.emailAdressTextField.text = data["email_adress"] as? String
        self.restaurantAdressTextField.text = data["adress"] as? String
        self.contactPersonTextField.text = data["contact_person"] as? String
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
        let data = notification?.userInfo!["restaurant_name"]
        print("notification?.userInfo")
        print("\(notification?.userInfo)")
        self.data = notification?.userInfo! as! Dictionary<String, Any>
     }
    
    @IBAction func submitRate(_ sender: Any) {
        if let restaurantDocumentId = data["restaurant_id"]{
            //２回め以降の場合
            self.restaurantDocumentId = restaurantDocumentId as! String
            //self.updateToFirestore(ref: newRestaurantDocumentRef, data: newRestaurantData)
            let updateRestaurantDocRef = Firestore.firestore().collection("restaurants").document(self.restaurantDocumentId)
            let updateData:[String:Any] = [
                "review_amount":FieldValue.increment(Int64(1)),
                "total_rating_score_amount": self.cosmosViewRateValue,
                "comment": FieldValue.arrayUnion([self.commentTextView.text])
            ]
            self.updateFirestoreData(ref: updateRestaurantDocRef, data:updateData)
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
                "total_rating_score_amount": self.cosmosViewRateValue,
                "review_amount": 1,
                "comment": [self.commentTextView.text],
                "image_path": "",
                "created_at": Date()
            ]
            self.saveToFirestore(ref: newRestaurantDocumentRef, data: newRestaurantData)
        }
        //reviewデータの保存
        let newReviewRef = Firestore.firestore().collection("restaurants").document(self.restaurantDocumentId).collection("reviews").document()
        let newReviewData:[String:Any] = [
            "comment": self.commentTextView.text,
            "other_tips": self.otherTipsTextView.text,
        ]
        self.saveToFirestore(ref: newReviewRef, data: newReviewData)
        //restaurantに
        for pngImage in pngImageArray {
            self.saveToFireStorage(data: pngImage)
            //ひもづいてfirestoreにも保存している（image＿urlを) restaurants/restaurantA/images / image_url
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
        let ref: DocumentReference? = db.collection("restaurants").document(self.restaurantDocumentId).collection("images").document()
        let document_id = ref?.documentID as! String
        let submit_data = [
            "id": document_id,
            "path":path,
            "created_at": Date(),
        ] as [String : Any]
        self.saveToFirestore(ref: ref, data: submit_data)
        //検索結果を表示するときに、読み込み節約のため、restaurantドキュメントにあらかじめ最新の画像情報を持たせておく
        let updateRestaurantDocRef = db.collection("restaurants").document(self.restaurantDocumentId)
        self.updateFirestoreData(ref: updateRestaurantDocRef, data: ["image_path":path])
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
    
    private func updateFirestoreData(ref:DocumentReference?,data:[String:Any]){
        ref?.setData(data, merge: true){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
}
