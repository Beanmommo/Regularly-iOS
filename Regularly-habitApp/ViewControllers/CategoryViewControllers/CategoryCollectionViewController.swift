//
//  HabitCollectionViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 26/4/2023.
//

import UIKit

private let habitCell = "habitCell"
private let dateCell = "dateCell"

class CategoryCollectionViewController: UICollectionViewController, DatabaseListener, DateSelectionDelegate, UITabBarControllerDelegate {
    
    var selectedDay: String?
    var listenerType: ListenerType = .categories
    
    weak var authenticateController: AuthenticateController?
    weak var firebaseController: FirebaseController?
    let DATE_SECTION = 0
    let CATEGORY_SECTION = 1
    
    //Page attributes
    var category: Category = Category()
    var habits: [Habit] = []
    var selectedHabit: [Habit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
        authenticateController = appDelegate?.authenticateController
        self.tabBarController?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    //Updates collection view when user changed date selection from the view controller
    func onDateChange(day: String) {
        self.habits = []
        var rawString = "Every "
        rawString += day
        selectedDay = rawString
        guard let selectedPeriod = HabitPeriod(rawValue: selectedDay ?? "Every Day") else {
            print("Error getting period from select date picker")
            return
        }
        
        let allHabits = self.category.habits
        var periodArrayEnum: [[HabitPeriod]] = []
        for habit in allHabits {
            let periodArray = habit.getHabitPeriodEnum()
            periodArrayEnum.append(periodArray)
        }
        
        //Show habit bool will return true false depending on period
        var showHabitBool: [Bool] = []
        
        //Implement habit filter.
        for habitPeriods in periodArrayEnum{
            if habitPeriods.contains(selectedPeriod){
                showHabitBool.append(true)
            }else{
                showHabitBool.append(false)
            }
        }
        
        //Get Habit in period
        var i = 0
        for habit in allHabits{
            if showHabitBool[i] {
                self.habits.append(habit)
            }
            i += 1
        }

        collectionView.reloadData()
        
    }

    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let mainTabBar = tabBarController as! MainTabBarViewController
        if mainTabBar.selectedIndex == 0 {
            mainTabBar.setRightBarButton()
            
        }else{
            mainTabBar.hideRightBarButton()
        }
    }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #Initialise each category as sections
        
        // 0: Date Section
        // 1: Habit Section
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if section == 0{
            return 1
        }
        if section >= 1{
            return self.habits.count
//            let category = self.category
//            return category.habits.count
        }
        return 0
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  UICollectionViewCell()
        
        //Initialise Date Cell 
        if indexPath.section == DATE_SECTION{
            if let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCell, for: indexPath) as? DateViewCell{
                dateCell.datePicker.locale = .current
                dateCell.datePicker.date = Date()
                dateCell.datePicker.addTarget(dateCell, action: #selector(dateCell.dateSelected) , for: .valueChanged)
                dateCell.dateFormatter.dateFormat = "EEEE"
                dateCell.delegate = self
                return dateCell
            }
        }
        
        if indexPath.section == CATEGORY_SECTION{
            let habit = self.habits[indexPath.row]
            if let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: habitCell, for: indexPath) as? HabitViewCell{
                let habitName = habit.title ?? "habit name"
                let habitDesc = habit.description ?? "habit desc"
                habitCell.setName(with: habitName)
                habitCell.setDescription(with: habitDesc)
                return habitCell
            }
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == DATE_SECTION {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? CategoryReusableView{
                sectionHeader.setTitle(with: "WELCOME")
                return sectionHeader
            }

        }
        if indexPath.section >= CATEGORY_SECTION{
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? CategoryReusableView{
                let category = self.category
                sectionHeader.setTitle(with: category.title ?? "category title")
                sectionHeader.setCategoryId(with: category.id ?? "")
                return sectionHeader
            }
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let habit = self.habits[indexPath.row]
        firebaseController?.didSelectHabit(habit: habit)
        //navigationController?.popViewController(animated: true)
        //dismiss(animated: true)
        performSegue(withIdentifier: "selectHabitSegue", sender: self)
        
    }
    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firebaseController?.removeListener(listener: self)
    }
    
    //MARK: Listeners function
    func onCategoriesChange(change: DatabaseChange, category: Category) {
        self.category = category
        self.habits = category.habits
        collectionView.reloadData()
    }
    
    func onHabitChange(change: DatabaseChange, habit: Habit) {
        //
    }

}
