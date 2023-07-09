//
//  Activity.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 2/6/2023.
//

import UIKit
/*
 Activity Data
 Future Implemetations:
    - Ability to store and record activity for user
 */
class ActivityData: NSObject, Decodable{
    var activityTitle: String?
    var activityType: String?
    var participants: Int?
    var price: Double?
    var link: String?
    var key: String?
    var accessibility: Double?
    
    private enum ActivityKeys: String, CodingKey {
        case activityTitle = "activity"
        case activityType = "type"
        case participants
        case price
        case link
        case key
        case accessibility
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityKeys.self)
        self.activityTitle = try container.decodeIfPresent(String.self, forKey: .activityTitle)
        self.activityType = try container.decodeIfPresent(String.self, forKey: .activityType)
        self.participants = try container.decodeIfPresent(Int.self, forKey: .participants)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
        self.accessibility = try container.decodeIfPresent(Double.self, forKey: .accessibility)
    }
    
}
