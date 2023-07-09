//
//  CategoryReusableView.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 8/5/2023.
//

import UIKit

//Used for header of each section in CategoryCollectionView
class CategoryReusableView: UICollectionReusableView {
    
    var categoryId: String = ""
    
    @IBOutlet weak var headerTitle: UILabel!
    
    @IBAction func addHabitToCategory(_ sender: Any) {
        
    }
    func setTitle(with title: String){
        headerTitle.text = title
    }
    
    func setCategoryId(with categoryId: String) {
        self.categoryId = categoryId
    }
    //Ask how to call FirebaseController when adding habit 
}
