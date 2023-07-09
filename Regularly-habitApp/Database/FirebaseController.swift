//
//  FirebaseController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 15/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore

//Database for Habit app
class FirebaseController: NSObject, DatabaseProtocol{
    
    var database: Firestore
    var categoriesRef: CollectionReference?
    var habitRef: CollectionReference?
    var userRef: CollectionReference?
    var activityRef: CollectionReference?
    var listeners = MulticastDelegate<DatabaseListener>()
    
    //Logged in user data.
    var categories: [Category]
    var habits: [Habit]
    
    //User Cookies
    var habit: Habit
    var category: Category
    
    override init() {
        //FirebaseApp.configure()
        self.database = Firestore.firestore()
        self.categoriesRef = database.collection("categories")
        self.habitRef = database.collection("habits")
        self.userRef = database.collection("users")
        self.activityRef = database.collection("logActivity")
        self.categories = [Category]()
        self.habits = [Habit]()
        self.habit = Habit()
        self.category = Category()
        
    }
    
    //MARK: Listener functionality
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .categories || listener.listenerType == .all{
            listener.onCategoriesChange(change: .update, category: category)
        }
        if listener.listenerType == .habit || listener.listenerType == .all{
            listener.onHabitChange(change: .update, habit: habit)
        }
        
    }
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    //Create get everything from logged in user id. ex:
    //Get categories from userID
    //MARK: Category functions
    @MainActor
    //Will return category object
    func getCategoryById(categoryId: String) async throws -> Category{
        let category = Category()
        var habitIdArray: [String] = []
        
        //Get category details
        do {
            let snapshot = try await categoriesRef?.document(categoryId).getDocument()
            guard let data = snapshot?.data() else{
                print("Error getting category snapshot")
                return category
            }
            category.id = snapshot?.documentID
            category.title = data["title"] as? String
            if let habitReference = snapshot?.data()?["habits"] as? [DocumentReference]{
                for reference in habitReference {
                    habitIdArray.append(reference.documentID)
                }
            }
        }catch{
            print(error)
        }
        
        //Append habits to category object
        for habitId in habitIdArray{
            do{
                let habit = try await self.getHabitById(habitId: habitId)
                category.habits.append(habit)
            }catch{
                print(error)
            }
            
        }
        return category

    }
    
    func addCategory(title: String) async throws -> Category{
        let category = Category()
        category.title = title
        do{
            if let categoryDocRef = try categoriesRef?.addDocument(from: category) {
                category.id = categoryDocRef.documentID
            }
        }catch{
            print(error)
        }
        return category
    }
    
    func setupCategories(forUser: String) {
        print("pressed2")
    }
    //MARK: Habit functions
    func getHabitById(habitId: String) async throws -> Habit{
        do{
            let habit = Habit()
            let snapshot = try await habitRef?.document(habitId).getDocument()
            guard let data = snapshot?.data() else{
                print("Error getting habit snapshot")
                return habit
            }
            habit.id = snapshot?.documentID
            habit.title = data["title"] as? String
            habit.description = data["description"] as? String
            habit.currentStreak = data["currentStreak"] as! Int
            habit.maxStreak = data["maxStreak"] as! Int
            habit.period = data["period"] as? [String]
            return habit
        }catch{
            print(error)
        }
        return Habit(id: habitId)
    }
    
    //Change parameter into Habit
    func addHabit(title: String, description: String, period: [String]) -> Habit {
        let habit = Habit()
        habit.title = title
        habit.description = description
        habit.period = period
        do{
            if let habitDocRef = try habitRef?.addDocument(from: habit){
                habit.id = habitDocRef.documentID
            }
        }catch{
            print("Failed to serialized habit")
        }
        return habit
        
    }
    
    func addHabitToCategory(habit: Habit, category: Category) {
        //Finish this Leo
        //Now test this
        guard let habitID = habit.id, let categoryID = category.id else{
            return
        }
        
        if let newHabitRef = habitRef?.document(habitID){
            categoriesRef?.document(categoryID).updateData(
                ["habits": FieldValue.arrayUnion([newHabitRef])])
        }
    }
    
    func logHabitActivity(uid: String, date: Date) async throws{
        /*
         Log habit activity for current date takes user uid and Habit for incrementation
         */
        
//        df.dateFormat = "dd/MM/yy"
//        guard let date = df.date(from: "09/06/2023") else{
//            return
//        }
        let df = DateFormatter()
        
        //get date component
        let currentDate = Date()
        df.dateFormat = "yyyy"
        let year = df.string(from: currentDate)
        df.dateFormat = "MMM"
        var month = df.string(from: currentDate)
        df.dateFormat = "dd"
        let day = df.string(from: currentDate)
        guard let dayInt = Int(day) else{
            return
        }
        
        //get collection id
        let activityLogID = uid+"-"+year+"-"+month
        
        //get num of days for the month
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        
        // get Activity log from firebase
        
        var logActivity: ActivityLog?
        do{
            logActivity = try await self.getActivityLogFromID(id: activityLogID)
        }catch{
            print(error)
        }

        if let logYear = logActivity?.year, let logMonth = logActivity?.month, var logDays = logActivity?.day {
            //Increment count
            logDays[dayInt-1] += 1
            logActivity?.day = logDays
            try activityRef?.document(activityLogID).setData(from: logActivity)
        }else{
            //Create new logActivity in Firebase
            logActivity = ActivityLog()
            logActivity?.year = year
            logActivity?.month = month
            logActivity?.day = [Int]()
            for _ in 0...numDays-1 {
                logActivity?.day?.append(0)
            }
            guard var logDay = logActivity?.day else{
                return
            }
            logDay[dayInt-1] += 1
            logActivity?.day = logDay
            
            logActivity?.id = activityLogID
            guard let newId = logActivity?.id else{
                return
            }
            do{
                try activityRef?.document(newId).setData(from: logActivity)
            }catch{
                print("Problem when creating data for new activity")
            }
            print("Created new Firebase logActivity")
        }
        
        
        
        
    }
    
    //MARK: User functions
    func addUser(belongsTo: String, category: Category) async throws -> User {
        let user = User()
        
        do{
            user.uuid = belongsTo
            let userReference = try await userRef?.addDocument(data: ["uuid": user.uuid ?? ""])
            
            
            //user.categories initialised as [] "empty string"
            
            user.id = userReference?.documentID
        }catch{
            print(error)
        }
        guard let userId = user.id else{
            return user
        }
        if let categoryRefDoc = categoriesRef?.document(category.id ?? "") {
            try await userRef?.document(userId).updateData(
                ["category": categoryRefDoc]
            )
        }
        user.category = category
        return user
    }
    
    func getUserByUuid(uuid: String) async throws -> User {
        let user = User()
        var categoryID: String = ""
        
        //Get user object
        do{
            let querySnapshot = try await userRef?.whereField("uuid", isEqualTo: uuid).getDocuments()
            //There will be only one document
            let document = querySnapshot!.documents[0]
            user.id = document.documentID
            user.uuid = document["uuid"] as? String
            if let categoryRef = document["category"] as? DocumentReference{
                categoryID = categoryRef.documentID
            }
        }catch{
            print(error)
        }
        do{
            let category = try await getCategoryById(categoryId: categoryID)
            user.category = category
        }catch{
            print(error)
        }
        
        return user
    }
    
    //MARK: Setup functions
    func setupDatabaseValue(forUser: String) async throws{
        //Function is called when user is signed in, Sets categories in database to be used in the app.
        //Get user value
        do{
            let user = try await getUserByUuid(uuid: forUser)
            let userCategory = user.category
            self.category = userCategory
            
            
        }catch{
            print(error)
        }
        
    }
    
    func didSelectHabit(habit: Habit){
        self.habit = habit
    }
    
    //MARK: ActivityLog
    func getActivityLogFromID (id: String) async throws -> ActivityLog {
        do{
            let logActivity = try await activityRef?.document(id).getDocument(as: ActivityLog.self)
            return logActivity!
        }catch{
            print(error)
        }
        return ActivityLog()
    }
    
}
