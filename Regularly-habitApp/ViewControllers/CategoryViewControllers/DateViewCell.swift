//
//  DateViewCell.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 29/5/2023.
//

import UIKit

protocol DateSelectionDelegate: AnyObject {
    func onDateChange(day: String)
}

//Date picker view cell for section = 0 in CategoryCollection View Controller
class DateViewCell: UICollectionViewCell {
    weak var delegate: DateSelectionDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()
    
    //Calls whenever a date is changed.
    @objc func dateSelected(){
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        delegate?.onDateChange(day: dateString)
        
    }
 
}
