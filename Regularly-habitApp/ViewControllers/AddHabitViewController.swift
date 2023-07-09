//
//  AddHabitViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 22/5/2023.
//

import UIKit

//ViewController that handles adding habit to their account
class AddHabitViewController: UIViewController, SelectedPeriodDelegate {
    
    func setSelectedPeriod(_ selectedPeriod: [String]) {
        self.selectedPeriod = selectedPeriod
        var periodText = ""
        for period in selectedPeriod{
            periodText += period
            periodText += ", "
        }
        periodTextLabel.text = periodText
    }

    @IBOutlet weak var habitNameField: UITextField!
    @IBOutlet weak var habitDescField: UITextField!
    weak var firebaseController: FirebaseController?
    var selectedPeriod: [String] = []
    
    @IBOutlet weak var periodTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addHabit(_ sender: Any) {
        
        //Check input values
        guard let habitTitle = habitNameField.text, !habitTitle.isEmpty, let habitDesc = habitDescField.text, !habitDesc.isEmpty, selectedPeriod.count > 0 else{
            let title = "error"
            let message = "Please check input values were valid"
            
            displayMessage(title: title, message: message)
            return
        }
        
        //Call database addHabit and addHabitToCategory function
        
        //Test to add category from
        guard let newHabit = firebaseController?.addHabit(title: habitTitle, description: habitDesc, period: selectedPeriod) as? Habit, let category = firebaseController?.category else {
            print("Error add habit and getting category")
            return
        }
        firebaseController?.addHabitToCategory(habit: newHabit, category: category)
        firebaseController?.category = category
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        //performSegue(withIdentifier: "addHabitSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectPeriodSegue"{
            let periodTableViewController = segue.destination as! PeriodTableViewController
            periodTableViewController.delegate = self
            periodTableViewController.selectedItems = []
        }
    }

    
    @IBAction func choosePeriod(_ sender: Any) {
        self.selectedPeriod = []
        performSegue(withIdentifier: "selectPeriodSegue", sender: sender)
        
    }
    

}
