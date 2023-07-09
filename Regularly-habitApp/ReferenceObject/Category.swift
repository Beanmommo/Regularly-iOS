//
//  Category.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 8/5/2023.
//

import Foundation
import FirebaseFirestoreSwift

/*
 Category object
 Future implementation:
    - Created for user to hold multiple categories that holds habits
 */
class Category: Codable{

    @DocumentID var id: String?
    var title: String?
    var habits: [Habit] = []
    
    init(id: String? = nil, title: String? = nil) {
        self.id = id
        self.title = title

    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case habits
    }
}
