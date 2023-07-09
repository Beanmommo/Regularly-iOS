//
//  ViewActivityViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 2/6/2023.
//

import UIKit


//Shows retrieved activity in Modal View
class ViewActivityViewController: UIViewController {
    
    var activity: ActivityData?
    
    @IBOutlet weak var activityTitleLabel: UILabel!
    override func viewDidLoad() {
        
        guard let activity = activity else{
            return
        }
        super.viewDidLoad()
        
        activityTitleLabel.text = activity.activityTitle
        activityTitleLabel.sizeToFit()
        activityTitleLabel.numberOfLines = 0
        

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
