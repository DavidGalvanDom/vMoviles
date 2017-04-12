//
//  AppDelegate.swift
//  vMoviles
//
//  Created by David Galvan on 2/14/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

let kSyncEnabled = true
let kLoggingEnabled = true
let kUsePrebuiltDb = false
let kConflictResolution = false
let ESTATUS_PEDIDO_CAPTURADO = "Capturado"
let ESTATUS_PEDIDO_ENVIADO = "Enviado"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var database: CBLDatabase!
    var databaseImg: CBLDatabase! 
    var pusher: CBLReplication!
    var puller: CBLReplication!
    var pullerimg: CBLReplication!
    var syncError: NSError?
    var conflictsLiveQuery: CBLLiveQuery?
    var accessDocuments: Array<CBLDocument> = [];
    var compania: String!
    var cveCompania: String!
    var config: Configuracion!
    var showMensaje = false
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       /* let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self*/
        
        // Habilita el log para monitorear la replicacion
        if kLoggingEnabled {
            enableLogging()
        }
        
        self.validConfig()
        self.showCompanias()
        return true
    }

    func validConfig() {
        
        let dataConfig = ConfiguracionDatos()
        _ = self.cargaConfiguracion(dataConfig: dataConfig)
        if (self.config == nil) {
            _ = dataConfig.createConfiguracion()
            _ = self.cargaConfiguracion(dataConfig: dataConfig)
        }
    }
    
    func cargaConfiguracion (dataConfig: ConfiguracionDatos) -> CBLDocument? {
        var doc :CBLDocument!
        
        do {
            let configQuery = dataConfig.setupViewAndQuery() as CBLQuery
            // var erro: NSError?
            let result  = try configQuery.run()
        
            doc = result.nextRow()?.document
            if( doc != nil) {
                self.config = Configuracion(for: (doc)!)
            }
        }
        catch {
            
        }
        
        return doc
    }
    
    // Base de datos
    func openDatabase(companias:[String]) throws {
        let dbname = companias[0]
        let dbnameImg = companias[1]
        
        let options = CBLDatabaseOptions()
        options.create = true
        
        try database = CBLManager.sharedInstance().openDatabaseNamed(dbname, with: options)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.observeDatabaseChange), name:Notification.Name.cblDatabaseChange, object: database)
        
        try databaseImg = CBLManager.sharedInstance().openDatabaseNamed(dbnameImg, with: options)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.observeDatabaseChange), name:Notification.Name.cblDatabaseChange, object: databaseImg)
        
    }

    func closeDatabase() throws {
        //stopConflictLiveQuery()
        if(database != nil) {
            try database.close()
        }
        
        if(databaseImg != nil) {
            try databaseImg.close()
        }
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
        
        accessDocuments.remove(at: accessDocuments.index(of: changedDoc!)!);
        try changedDoc?.purgeDocument()
    }
    
    // David GD : - Replication
    func startReplication(compania:String) {
        guard kSyncEnabled else {
            return
        }
        
        let companias = compania.components(separatedBy: "-")
        
        do {
            try closeDatabase()
            try openDatabase(companias: companias)
        } catch let error as NSError {
            NSLog("No se puede cerrar la base de datos: %@", error)
        }

        syncError = nil
        //se asigna la copania
        let url = URL(string: "\(self.config.urlSync)/\(companias[0])")
        let urlImg = URL(string: "\(self.config.urlSync)/\(companias[1])")
        
        if(database != nil) {
            // Inicia push/pull replications
            pusher = database.createPushReplication(url!)
            pusher.continuous = true  // Runs forever in background
        
            NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: pusher)
        
            puller = database.createPullReplication(url!)
            puller.channels = ["general",config.lineaVenta as String, "saldo-\(config.agente)","saldo2-\(config.agente)","stpedido-\(config.agente)"]
            puller.continuous = true  // Runs forever in background
            NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                               name: NSNotification.Name.cblReplicationChange, object: puller)
            //puller imagenes
            if( databaseImg != nil) {
                pullerimg = databaseImg.createPullReplication(urlImg!)
                pullerimg.continuous = true
             
                NotificationCenter.default.addObserver(self, selector: #selector(replicationProgress(notification:)),
                                                       name: NSNotification.Name.cblReplicationChange, object: pullerimg)
            }
            
            pusher.start()
            puller.start()
            pullerimg.start()
        }
    }
    
    func stopReplication() {
        guard kSyncEnabled else {
            return
        }
        
        if (pusher != nil) {
        pusher.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: pusher)
        }
        
        if( puller != nil) {
        puller.stop()
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.cblReplicationChange, object: puller)
        }
        
        if(pullerimg != nil) {
            pullerimg.stop()
            NotificationCenter.default.removeObserver(
                self, name: NSNotification.Name.cblReplicationChange, object: pullerimg)
        }
        
        showMensaje = false

    }
    
    func replicationProgress(notification: NSNotification) {
        UIApplication.shared.isNetworkActivityIndicatorVisible =
            (pusher.status == .active || puller.status == .active || pullerimg.status == .active)
       /*
        //Oculta mensaje
        if UIApplication.shared.isNetworkActivityIndicatorVisible == false {
            Ui.hideReplicando( onController: self.window!.rootViewController!)
            showMensaje = false
        }
        
        //Despliega mensaje de Sincronizando datos
        if UIApplication.shared.isNetworkActivityIndicatorVisible  && showMensaje == false {
            Ui.showReplicando( onController: self.window!.rootViewController!,
                               withMessage:"Sincronizando datos...",
                               onComplete: {
                                //Cuando termina de cargar el sincronizando valida si ya termino para ocultar la ventana
                                if UIApplication.shared.isNetworkActivityIndicatorVisible == false {
                                    Ui.hideReplicando( onController: self.window!.rootViewController!)
                                    NSLog("hide oncompleate:")
                                }
            })
            showMensaje = true
        }
        */
        
        let error = pusher.lastError as NSError?;
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
    
    //Despliega la lista principal
    func showInicial() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        window!.rootViewController = controller
        //controller?.performSegue(withIdentifier: "segueCompania", sender: nil)
    }
    
    func showCompanias() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        window!.rootViewController = controller
    }
    
    func showClientes()
    {
        let storyboard = UIStoryboard(name: "Clientes", bundle: nil)
        // Override point for customization after application launch.
        let controller = storyboard.instantiateInitialViewController()
        window!.rootViewController = controller
    }
    
    func showProductos()
    {
        let storyboard = UIStoryboard(name: "Productos", bundle: nil)
        // Override point for customization after application launch.
        let controller = storyboard.instantiateInitialViewController()
        window!.rootViewController = controller
    }

    
    func formatCurrency(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "PMX"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
    }
    
    // MARK: - Split view
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        /*
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        
        guard let topAsDetailController = secondaryAsNavController.topViewController as? PrincipalDetalleViewController else { return false }
        
        
        if topAsDetailController == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }*/
        
        return false
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
    



}

