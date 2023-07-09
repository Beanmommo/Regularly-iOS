//
//  HabitViewCell.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 8/5/2023.
//

import UIKit

class HabitViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    func setName(with habitTitle: String){
        name.text = habitTitle
    }
    
    func setDescription(with habitDesc: String){
        desc.text = habitDesc
    }
    
    
}
