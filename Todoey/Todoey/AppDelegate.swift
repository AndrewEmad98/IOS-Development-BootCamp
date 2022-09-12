//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialize realm dataBase")
        }
        return true
    }



    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       // saveContext()
    }



    //MARK: - Core Data
    
    /*
    lazy var persistentData : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ItemDataModel")
        container.loadPersistentStores(){ storeDescription,error in
            if let error = error as? NSError {
                fatalError("UnResolved error: \(error) , \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext(){
        let context = persistentData.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                let error = error as NSError
                fatalError("UnResolved error: \(error) , \(error.userInfo)")
            }
        }
    }
     */
}

