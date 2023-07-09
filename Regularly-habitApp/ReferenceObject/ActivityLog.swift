//
//  ActivityLog.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 9/6/2023.
//

import Foundation
import FirebaseFirestoreSwift
/*
 ActivityLog Object
 Future Implemetations:
    - User can see their stats from previous months
 */
class ActivityLog: NSObject, Codable{
    @DocumentID var id: String?
    var year: String?
    var month: String?
    var day: [Int]?
    
    
    private enum ActivityLogKeys: String, CodingKey {
        case id
        case year 
        case month
        case day
    }
    
    override init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.year = try container.decodeIfPresent(String.self, forKey: .year)
        self.month = try container.decodeIfPresent(String.self, forKey: .month)
        self.day = try container.decodeIfPresent([Int].self, forKey: .day)
    }
}
