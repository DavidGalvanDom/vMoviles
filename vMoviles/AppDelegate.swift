//
//  AppDelegate.swift
//  vMoviles
//
//  Created by David Galvan on 2/14/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

let kSyncEnabled = false
let kSyncGatewayUrl = URL(string: "http://localhost:4984/todo/")!
let kLoggingEnabled = false
let kUsePrebuiltDb = false
let kConflictResolution = false


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var database: CBLDatabase!
    var pusher: CBLReplication!
    var puller: CBLReplication!
    var syncError: NSError?
    var conflictsLiveQuery: CBLLiveQuery?
    var accessDocuments: Array<CBLDocument> = [];
    var vendedor: String!
    var compania: String!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        if kLoggingEnabled {
            enableLogging()
        }
        
        cargaConfiguracion()
        
        return true
    }

    func cargaConfiguracion () {
        vendedor = "David Galvan Dom"
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Base de datos
    func openDatabase(username:String, withKey key:String?,
                      withNewKey newKey:String?) throws {
        
        let dbname = username
        let options = CBLDatabaseOptions()
        options.create = true
        
        try database = CBLManager.sharedInstance().openDatabaseNamed(dbname, with: options)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.observeDatabaseChange), name:Notification.Name.cblDatabaseChange, object: database)
    }

    func closeDatabase() throws {
        //stopConflictLiveQuery()
        try database.close()
    }
    
    func observeDatabaseChange(notification: Notification) {
        if(!(notification.userInfo?["external"] as! Bool)) {
            return;
        }
        
        for change in notification.userInfo?["changes"] as! Array<CBLDatabaseChange> {
            if(!change.isCurrentRevision) {
                continue;
            }
            
            let changedDoc = database.existingDocument(withID: change.documentID);
            if(changedDoc == nil) {
                return;
            }
            
            let docType = changedDoc?.properties?["type"] as! String?;
            if(docType == nil) {
                continue;
            }
            
            if(docType != "task-list.user") {
                continue;
            }
            
            let username = changedDoc?.properties?["username"] as! String?;
            if(username != database.name) {
                continue;
            }
            
            accessDocuments.append(changedDoc!);
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.handleAccessChange), name: NSNotification.Name.cblDocumentChange, object: changedDoc);
        }
    }

    func handleAccessChange(notification: Notification) throws {
        let change = notification.userInfo?["change"] as! CBLDatabaseChange;
        let changedDoc = database.document(withID: change.documentID);
        if(changedDoc == nil || !(changedDoc?.isDeleted)!) {
            return;
        }
        
        let deletedRev = try changedDoc?.getLeafRevisions()[0];
        let listId = (deletedRev?["taskList"] as! Dictionary<String, NSObject>)["id"] as! String?;
        if(listId == nil) {
            return;
        }
        
        accessDocuments.remove(at: accessDocuments.index(of: changedDoc!)!);
        let listDoc = database.existingDocument(withID: listId!);
        try listDoc?.purgeDocument();
        try changedDoc?.purgeDocument()
    }
    
    // David GD : - Replication
    func startReplication(withUsername username:String, andPassword password:String? = "") {
        guard kSyncEnabled else {
            return
        }
        
        syncError = nil
        
        // Inicia push/pull replications
        pusher = database.createPushReplication(kSyncGatewayUrl)
        pusher.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller = database.createPullReplication(kSyncGatewayUrl)
        puller.continuous = true  // Runs forever in background
        NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
        pusher.start()
        puller.start()
    }
    
    func stopReplication() {
        guard kSyncEnabled else {
            return
        }
        
        pusher.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: pusher)
        
        puller.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: puller)
    }
    
    func replicationProgress(notification: NSNotification) {
        UIApplication.shared.isNetworkActivityIndicatorVisible =
            (pusher.status == .active || puller.status == .active)
        
        let error = pusher.lastError as? NSError;
        if (error != syncError) {
            syncError = error
            if let errorCode = error?.code {
                NSLog("Replication Error: \(error!)")
                if errorCode == 401 {
                    Ui.showMessageDialog(
                        onController: self.window!.rootViewController!,
                        withTitle: "Authentication Error",
                        withMessage:"Your username or password is not correct.",
                        withError: nil,
                        onClose: {
                            ///self.logout()
                    })
                }
            }
        }
    }

    // Logging
    func enableLogging() {
        CBLManager.enableLogging("CBLDatabase")
        CBLManager.enableLogging("View")
        CBLManager.enableLogging("ViewVerbose")
        CBLManager.enableLogging("Query")
        CBLManager.enableLogging("Sync")
        CBLManager.enableLogging("SyncVerbose")
    }
}

