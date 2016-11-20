//
//  AppDelegate.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

      return true
   }

   func applicationWillResignActive(_ application: UIApplication) {
   }

   func applicationDidEnterBackground(_ application: UIApplication) {
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
   }

   func applicationWillTerminate(_ application: UIApplication) {
   }

   // MARK: - Core Data Stack

   lazy var applicationDocumentsDirectory: URL = {

      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }()

   lazy var managedObjectModel: NSManagedObjectModel = {

      let modelURL = Bundle.main.url(forResource: "BookModel", withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
   }()

   lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.appendingPathComponent("Books.sqlite")

      do {

         try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)

      } catch {

         NSLog("persistentStoreCoordinator: Error!")
      }

      return coordinator
   }()

   lazy var managedObjectContext: NSManagedObjectContext = {

      var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

      return managedObjectContext
   }()
}
