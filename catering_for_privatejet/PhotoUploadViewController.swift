//
//  PhotoUploadViewController.swift
//  catering_for_privatejet
//
//  Created by Ni Ryogo on 2020/08/21.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage

class PhotoUploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = UserDefaults.standard
        ud.set(0, forKey: "count")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func selectImageWithLibrary(_ sender: AnyObject) {
        self.pickImageFromLibrary()
    }

    func countPhoto() -> String {
        let ud = UserDefaults.standard
        let count = ud.object(forKey: "count") as! Int
        ud.set(count + 1, forKey: "count")
        return String(count)
    }
}


// MARK: UINavigationControllerDelegate
extension PhotoUploadViewController: UINavigationControllerDelegate {
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension PhotoUploadViewController: UIImagePickerControllerDelegate {
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
        let reference = storageRef.child("image/" + NSUUID().uuidString + "/" + self.countPhoto() + ".jpg")
        reference.putData(data, metadata: nil, completion: { metaData, error in
            print(metaData)
            print(error)
        })
    }
}
