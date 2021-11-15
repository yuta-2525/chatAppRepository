//
//  SendToDBModel.swift
//  chatApp
//
//  Created by 佐藤勇太 on 2021/11/14.
//

import Foundation
import FirebaseStorage

protocol SendProfileOKDelegate {
    
    func sendProfileOkDelegate(url:String)
    
}

class SendToDBModel {
    
    var sendProfileOKDelegate:SendProfileOKDelegate?
    
    
    init(){
        
    }
    
    func sendeProfileImageData(data:Data){
        let image = UIImage(data: data)
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(profileImageData!, metadata: nil) { (metaData, error) in
            if error != nil{
                
                print(error.debugDescription)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    
                    print(error.debugDescription)
                    return
                }
                
                UserDefaults.standard.set(url?.absoluteString, forKey: "userImage")
                self.sendProfileOKDelegate?.sendProfileOkDelegate(url: url!.absoluteString)
            }
        }
        
        
    }
    
}
