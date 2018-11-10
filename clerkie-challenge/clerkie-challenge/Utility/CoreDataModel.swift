//
//  CoreDataModel.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/6/18.
//

import UIKit
import CoreData

class CoreDataModel {
    static let shared = CoreDataModel()
    
    let appDelegate: AppDelegate// = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext
    var currUsername: String
    var currUserID: String {
        didSet {
            setLastLogin()
        }
    }
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        currUserID = ""
        currUsername = ""
    }
    
    func createUser(_ username: String, password: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "LoginCombos", in: context)
        let loginCombo = NSManagedObject(entity: entity!, insertInto: context)
        
        loginCombo.setValue(username, forKey: "username")
        loginCombo.setValue(password, forKey: "password")
        let userID = UUID().uuidString
        loginCombo.setValue(userID, forKey: "userID")
        
        do {
            try context.save()
        } catch {
            print("Failed adding login comobo")
            return false
        }
        print("added login combo for username:", username)
        currUserID = userID
        currUsername = username
        return true
    }
    
    func findUser(_ username: String, password: String) -> GetUserError? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginCombos")
        request.predicate = NSPredicate(format: "username = %@", username)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let object = result as! [NSManagedObject]
            
            if object.count == 0 {
                print("no user with username:", username)
                return .DNE
            }
            
            if object.count > 1 {
                print("ERROR got multiple state cookies for username:", username)
                return .Unknown
            }
            
            for data in object {
                print("found login combo in core data for username:", username)
                
                if password == data.value(forKey: "password") as! String {
                    currUserID = data.value(forKey: "userID") as! String
                    currUsername = username
                    return nil
                } else {
                    return .PasswordError
                }
            }
            
        } catch {
            print("Error accessing core data for LoginCombo")
            return .Unknown
        }
        return .Unknown
    }
    
    func setLastLogin() {
        let entity = NSEntityDescription.entity(forEntityName: "LastLogin", in: context)
        let lastLogin = NSManagedObject(entity: entity!, insertInto: context)
        
        lastLogin.setValue(currUsername, forKey: "username")
        lastLogin.setValue(currUserID, forKey: "userID")
        
        do {
            try context.save()
        } catch {
            print("Failed setting last login ID")
        }
    }
    
//    func checkLastLogin() {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LastLogin")
//        request.predicate = NSPredicate(format: "username = %@", username)
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            let object = result as! [NSManagedObject]
//
//            if object.count == 0 {
//                print("no user with username:", username)
//                return .DNE
//            }
//
//            if object.count > 1 {
//                print("ERROR got multiple state cookies for username:", username)
//                return .Unknown
//            }
//
//            for data in object {
//                print("found login combo in core data for username:", username)
//                
//                if password == data.value(forKey: "password") as! String {
//                    currUserID = data.value(forKey: "userID") as! String
//                    return nil
//                } else {
//                    return .PasswordError
//                }
//            }
//
//        } catch {
//            print("Error accessing core data for LoginCombo")
//            return .Unknown
//        }
//    }
}

public enum GetUserError {
    case DNE
    case PasswordError
    case Unknown
    
//    func value() -> Int {
//        switch self {
//        case .DNE:
//            return 0
//        case .PasswordError:
//            return 1
//        case .Unknown:
//            return 2
//        }
//    }
}
