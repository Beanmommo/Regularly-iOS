//
//  GenActivityViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 2/6/2023.
//

import UIKit

// Enum for activity type present in API
private enum ActivityType: String, CaseIterable{
    case random = "Random"
    case educational = "Education"
    case recreational = "Recreational"
    case social = "Social"
    case diy = "DIY"
    case charity = "Charity"
    case cooking = "Cooking"
    case relaxation = "Relaxation"
    case music = "Music"
    case busywork = "Busywork"
}

//View controller to generate Activity from Bored API: https://www.boredapi.com/
//Function name self describe
class GenActivityViewController: UIViewController, UITabBarControllerDelegate {

    weak var firebaseController: FirebaseController?
    var activityData: ActivityData?
    var activityTypeString: String?
    @IBOutlet weak var typeSelectMenu: UIButton!
    var requestURLComponents = URLComponents()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
        self.tabBarController?.delegate = self
        
        //Setup reqest url
        requestURLComponents.scheme = "https"
        requestURLComponents.host = "www.boredapi.com"
        requestURLComponents.path = "/api/activity"
        
        setupTypeSelectButton()
        
        // Do any additional setup after loading the view.
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let mainTabBar = tabBarController as! MainTabBarViewController
        if mainTabBar.selectedIndex == 0 {
            mainTabBar.setRightBarButton()
            
        }else{
            mainTabBar.hideRightBarButton()
        }
        
    }
    
    @IBAction func getActivity(_ sender: Any) {
        Task{
            await requestActivity()
            performSegue(withIdentifier: "viewActivitySegue", sender: sender)
        }
        
    }
    
    func requestActivity() async {
        // Add query
        if activityTypeString != nil {
            self.requestURLComponents.queryItems = [
                URLQueryItem(name: "type", value: self.activityTypeString)
            ]
        }
        
        guard let requestURL = self.requestURLComponents.url else{
            print("Invalid URL.")
            return
        }
        let urlRequest = URLRequest(url: requestURL)
        do{
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let decorder = JSONDecoder()
            self.activityData = try decorder.decode(ActivityData.self, from: data)
        }catch let error{
            print(error)
        }
        
    }
    
    //Handles habit type selection
    func setupTypeSelectButton(){
        let optionClosure = {(action: UIAction) in
            let activityType = ActivityType(rawValue: action.title)
            switch activityType {
            case .random:
                self.activityTypeString = nil
            case .educational:
                self.activityTypeString = "education"
            case .recreational:
                self.activityTypeString = "recreational"
            case .social:
                self.activityTypeString = "social"
            case .diy:
                self.activityTypeString = "diy"
            case .charity:
                self.activityTypeString = "charity"
            case .cooking:
                self.activityTypeString = "cooking"
            case .relaxation:
                self.activityTypeString = "relaxation"
            case .music:
                self.activityTypeString = "music"
            case .busywork:
                self.activityTypeString = "busywork"
            default:
                self.activityTypeString = nil
            }
        }
        
        var menuChildren = [UIAction(title: "Select", state: .on, handler: optionClosure)]
        
        for activityType in ActivityType.allCases {
            menuChildren.append(UIAction(title: activityType.rawValue, state: .off, handler: optionClosure))
        }
        typeSelectMenu.menu = UIMenu(children: menuChildren)
        typeSelectMenu.showsMenuAsPrimaryAction = true
        typeSelectMenu.changesSelectionAsPrimaryAction = true
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewActivitySegue"{
            let destination = segue.destination as! ViewActivityViewController
            destination.activity = self.activityData
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
