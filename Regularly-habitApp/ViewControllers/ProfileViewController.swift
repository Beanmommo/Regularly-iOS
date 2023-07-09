//
//  ProfileViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 5/6/2023.
//

import UIKit

/*
 View controller that shows profile options
 Future Implementation:
    - Confirm message to sign out
 */
class ProfileViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet var profileLabel: UILabel!
    weak var firebaseController: FirebaseController?
    weak var authenticateController: AuthenticateController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
        authenticateController = appDelegate?.authenticateController
        tabBarController?.delegate = self
        profileLabel.text = authenticateController?.authController.currentUser?.email

        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewProfileStatistic(_ sender: Any) {
        performSegue(withIdentifier: "viewStats", sender: nil)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        Task { @MainActor in
            let mainTabBar = tabBarController as! MainTabBarViewController
            try await authenticateController?.signOut()
            
            //Pop to loginViewPage
            mainTabBar.popTabBar()
        }
        
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let mainTabBar = tabBarController as! MainTabBarViewController
        if mainTabBar.selectedIndex == 0 {
            mainTabBar.setRightBarButton()
            
        }else{
            mainTabBar.hideRightBarButton()
        }
        
    }
    
    @IBAction func visitHabitFact(_ sender: Any) {
        
        if let URLtoOpen = URL(string: "https://www.samuelthomasdavies.com/book-summaries/self-help/atomic-habits/#:~:text=An%20atomic%20habit%20is%20a,the%20wrong%20system%20for%20change.") {
            //Open the url
            UIApplication.shared.open(URLtoOpen)
        }
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
