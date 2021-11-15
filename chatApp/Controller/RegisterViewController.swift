//
//  RegisterViewController.swift
//  chatApp
//
//  Created by 佐藤勇太 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendProfileOKDelegate,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var sendToDBModel = SendToDBModel()
    var urlString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        sendToDBModel.sendProfileOKDelegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func touroku(_ sender: Any) {
        //emailTextFieldとpasswordTextFieldがimage空じゃないか確認
        if emailTextField.text!.isEmpty != true && passwordTextField.text!.isEmpty != true, let image = profileImageView.image{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil{
                    
                    print(error)
                    return
                }
                
                let data = image.jpegData(compressionQuality: 1.0)
                
                self.sendToDBModel.sendeProfileImageData(data: data!)
                
            }
        }
        //登録
        
        //email.textFireld,ProfileImage値
        
    }
    
    func sendProfileOkDelegate(url: String) {
        urlString = url
        if urlString.isEmpty != true{
            
            self.performSegue(withIdentifier: "chat", sender: nil)
        }
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        
        //カメラ、アルバム
        
        //アラートを出す
        showAlert()
    }
    
    //カメラ立ち上げメソッド
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    //アルバム
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if info[.originalImage] as? UIImage != nil{
                let selectedImage = info[.originalImage] as! UIImage
                profileImageView.image = selectedImage
                picker.dismiss(animated: true, completion: nil)
            }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
        //アラート
        func showAlert(){
            let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
                self.doCamera()
            }
            let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
                self.doAlbum()
            }
            let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }
}
