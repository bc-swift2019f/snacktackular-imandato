//
//  Photo.swift
//  Snacktacular
//
//  Created by Ivelisse Mandato on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var DocumentUUID: String //Universal Unique Identifier
    var dictionary: [String: Any] {
        return ["description": description, "postedBy": postedBy, "date": date ]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, DocumentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.DocumentUUID = DocumentUUID
    }
    
    convenience init() {
    let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
    self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), DocumentUUID: "")
    }
        
    convenience init(dictionary: [String: Any]) {
        let title = dictionary ["description"] as! String? ?? ""
        let text = dictionary["postedBy"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, DocumentUUID: "")
    }
        
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert photo.image to a Data type so it can be saved by Firebase storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print ("*** ERROR: Could not convert image to data format")
            return completed(false)
        }
        DocumentUUID = UUID().uuidString //generate a unique ID to use for the photo image's name
        //create a ref to upload stoarge to spot.documentID's folder (bucket), with the name we created
        let storageRef = storage.reference().child(spot.documentID).child(self.DocumentUUID)
        let uploadTask = storageRef.putData(photoData)
        
        uploadTask.observe(.success) {(snapshot) in
            // Create the dictionary representing the data we want to save
            let dataToSave = self.dictionary
            // this will either create a new doc at documentUUID or update the existing doc with that name 
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.DocumentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.DocumentUUID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed (true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print ("*** ERROR: upload task for file \(self.DocumentUUID) failed, in spot \(spot.documentID)")
            }
            return completed (false)
        }
            
        storageRef.putData(photoData)
        
    }
}

