//
//  User.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 16/5/2023.
//

import UIKit
import FirebaseFirestoreSwift

/*
 User Object
 Future implemetations:
    - User can create more than one categories
 */
class User: NSObject{
    @DocumentID var id: String?
    var uuid: String?
    var category: Category = Category()
    
    private enum CodingKeys: String, CodingKey{
        case id
        case uuid
        case categories
    }
}
