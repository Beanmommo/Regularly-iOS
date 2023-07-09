//
//  MainTabBarViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 4/6/2023.
//

import UIKit

//Tab Bar in main page that holds: Home, Activity, Profile tabs
class MainTabBarViewController: UITabBarController {

    @IBOutlet var AddButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        

        // Do any additional setup after loading the view.
    }
    
    //Show "+" button for AddHabitViewController
    func setRightBarButton(){
        self.navigationItem.rightBarButtonItem = self.AddButton
    }
    
    //Hide button
    func hideRightBarButton(){
        self.navigationItem.rightBarButtonItem = nil
    }
    
    //Destroy tab bar - used for signOut functionality
    func popTabBar(){
        self.selectedViewController?.navigationController?.popToRootViewController(animated: true)
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
