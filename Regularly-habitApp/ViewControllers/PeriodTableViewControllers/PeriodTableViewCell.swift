//
//  PeriodTableViewCell.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 29/5/2023.
//

import UIKit

class PeriodTableViewCell: UITableViewCell {

    @IBOutlet weak var periodLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(title: String) {
        periodLabel.text = title
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
