//
//  AppDelegate.swift
//  Note App
//
//  Created by Tristan Bui on 12/7/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        IQKeyboardManager.shared.enable = true
        return true
    }

    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
     
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Note_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()



    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

