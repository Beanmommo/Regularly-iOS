//
//  HabitViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 25/5/2023.
//

import UIKit

//ViewController that shows habit info
class HabitViewController: UIViewController, DatabaseListener {
    var listenerType: ListenerType = .habit
    var habit: Habit = Habit()
    var firebaseController: FirebaseController?
    var authenticateController: AuthenticateController?
    
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var habitDesc: UILabel!
    
    //MARK: TO be implemented in the future!!
    //Output that will show streaks in habit
    @IBOutlet weak var currentStreak: UILabel!
    @IBOutlet weak var maxStreak: UILabel!
    //Image height will changed according to the value of streaks
    @IBOutlet var currentStreakCircle: UIImageView!
    @IBOutlet var maxStreakImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
        authenticateController  = appDelegate?.authenticateController
        
        let image = currentStreakCircle.image!
        let screenSize = UIScreen.main.bounds
        currentStreakCircle.frame = CGRectMake(0, 0, 50, currentStreakCircle.frame.height * 0.2)
        
        // Do any additional setup after loading the view.
    }
    
    func onCategoriesChange(change: DatabaseChange, category: Category) {
        //
    }
    func onHabitChange(change: DatabaseChange, habit: Habit) {
        self.habit = habit
        habitTitle.text = habit.title
        habitDesc.text = habit.description
        
        //Streak
        currentStreak.text = "\(String(describing: habit.currentStreak))"
        
        maxStreak.text = "\(String(describing: habit.maxStreak))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firebaseController?.removeListener(listener: self)
    }
    
    @IBAction func logActivity(_ sender: Any) {
        
        let uid = authenticateController?.getSignedInUserUUID() ?? ""
        Task {
            try await firebaseController?.logHabitActivity(uid: uid, date: Date())
        }
        
    }
    
    
    //Funtion for dynamic visualisation of streaks
    //MARK: To be implemented in the future, (DOES NOT WORK)
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size
       
       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height
       
       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
       }
       
       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
       
       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       return newImage!
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
