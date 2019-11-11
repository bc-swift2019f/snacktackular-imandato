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
    
    init(image: UIImage, description: String, postedBy: String, date: Date, DocumentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.DocumentUUID = DocumentUUID
    }
}
