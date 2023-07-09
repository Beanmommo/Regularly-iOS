//
//  DatabaseDelegate.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 9/5/2023.
//

import Foundation



enum DatabaseChange{
    case add
    case delete
    case update
}

enum ListenerType{
    case categories
    case habit
    case all
}

protocol DatabaseListener: AnyObject{
    var listenerType: ListenerType {get set}
    
    //categories listener on Categoruy View Controller
    func onCategoriesChange(change: DatabaseChange, category: Category)
    
    //habit listener on Habit View Controller
    func onHabitChange(change: DatabaseChange, habit: Habit)
}

protocol DatabaseProtocol: AnyObject {
    
    //Listener Protocols
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    //Getter
    func setupCategories(forUser: String)
    func getCategoryById(categoryId: String) async throws -> Category
    func getHabitById(habitId: String) async throws -> Habit
    func getUserByUuid(uuid: String) async throws -> User
    func setupDatabaseValue(forUser: String) async throws
    
    //Setter
    func addUser(belongsTo: String, category: Category) async throws -> User
    func addHabit(title: String, description: String, period: [String]) -> Habit
    func addHabitToCategory(habit: Habit, category: Category)
    func addCategory(title: String) async throws-> Category
    func didSelectHabit(habit: Habit)
}
