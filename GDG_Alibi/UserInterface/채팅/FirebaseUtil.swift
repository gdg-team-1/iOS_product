//
//  FirebaseUtil.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/10.
//

import Foundation
import Firebase

class FirebaseUtil {
    
    static var photos = [String: UIImage]()
    
    class func imageUpload(image: UIImage, completion: @escaping (String?) -> Void) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let reviewImageReference = Storage.storage().reference().child(UUID().uuidString)
        let data = image.jpegData(compressionQuality: 0.1)!
        
        reviewImageReference.putData(data, metadata: metadata) { (_, error) in
            
            if let _ = error {
                completion(nil)
                
            } else {
                // 이미지 업로드 후 url 정보 저장
                reviewImageReference.downloadURL { (url, error) in
                    if let _ = error {
                        completion(nil)
                        
                    } else {
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
    
    
    
    class func imageDownload(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        
        if let image = self.photos[imageURL] {
            completion(image)
            
        } else {
            Storage
                .storage()
                .reference(forURL: imageURL)
                .getData(maxSize: Int64.max) { (data, error) in
                    
                    if let _ = error {
                        completion(nil)
                        
                    } else {
                        if let data = data, let image = UIImage(data: data) {
                            self.photos[imageURL] = image
                            completion(image)
                            
                        } else {
                            completion(nil)
                        }
                    }
                }
        }
    }
    
    
    
    class func imageDownload(userID: String, completion: @escaping (UIImage?) -> Void) {
        
        if let image = self.photos[userID] {
            completion(image)
            
        } else {
            Storage
                .storage()
                .reference()
                .child(userID)
                .getData(maxSize: Int64.max) { (data, error) in
                    
                    if let _ = error {
                        completion(nil)
                        
                    } else {
                        if let data = data, let image = UIImage(data: data) {
                            self.photos[userID] = image
                            completion(image)
                            
                        } else {
                            completion(nil)
                        }
                    }
                }
        }
    }
    
    
    class func addChat(requestUser: String, helpUser: String, category: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = ["requestUser": requestUser,
                                   "helpUser": helpUser,
                                   "category": category,
                                   "date": Date()]
        
        Firestore
            .firestore()
            .collection("chatList")
            .addDocument(data: data) { error in
                completion(error)
            }
    }
}
