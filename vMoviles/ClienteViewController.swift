//
//  ClienteViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/18/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ClienteViewController: UITableViewController,UISearchResultsUpdating {
    
    var clienteRows : [CBLQueryRow]?
    var clienteLiveQuery: CBLLiveQuery!
    var dbChangeObserver: AnyObject?
    var searchController: UISearchController!
    var detailViewController: ClienteDetalleViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup SearchController:
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar

        
        // Inicializa las vistas y querys couchbase lite:
        iniciaBaseDatos()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ClienteDetalleViewController
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if clienteLiveQuery != nil {
            clienteLiveQuery.removeObserver(self, forKeyPath: "rows")
            clienteLiveQuery.stop()
        }
        
        if dbChangeObserver != nil {
            NotificationCenter.default.removeObserver(dbChangeObserver!)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueClienteDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow
            if indexPath!.row > 0 {
                let cliente = Cliente(for: (clienteRows?[indexPath!.row].document)!)
                
                let controller = (segue.destination as! UINavigationController).topViewController as! ClienteDetalleViewController
                
                controller.detalleCliente = cliente
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == clienteLiveQuery {
            recargarClientes()
        }
    }

    
    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        
        if !text.isEmpty {
            clienteLiveQuery.postFilter = NSPredicate(format: "key CONTAINS[cd] %@", text)
        } else {
            clienteLiveQuery.postFilter = nil
        }
        clienteLiveQuery.queryOptionsChanged()
    }
    
    // Datos
    // MARK: - Database
    func iniciaBaseDatos() {
        let app = UIApplication.shared.delegate as! AppDelegate
        clienteLiveQuery = ClienteDatos(_database: app.database).setupViewAndQuery()
        clienteLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        clienteLiveQuery.start()
    }
       
    func recargarClientes() {
        clienteRows = clienteLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        tableView.reloadData()
    }
    
    /*
    func ocultamuestraClientes() {
        let app = UIApplication.shared.delegate as! AppDelegate
        if dbChangeObserver == nil {
            dbChangeObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.cblDatabaseChange, object: app.database, queue: nil) { note in
                // Review: Can optimize this by executing in the background dispatch queue:
                if let changes = note.userInfo!["changes"] as? [CBLDatabaseChange] {
                    for change in changes {
                        if change.source == nil {
                            return
                        }
                        if change.documentID == moderatorDocId {
                            self.ocultamuestraClientes()
                            return
                        }
                    }
                }
            }
        }
    }*/
        
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clienteRows?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientListCell", for: indexPath)
        
        let doc = clienteRows![indexPath.row].document!
        cell.textLabel?.text = "\(doc["id"]!) - \(doc["razonsocial"]!) "
        cell.detailTextLabel?.text = "\(doc["apostal"]!) - \(doc["ciudad"]!) - \(doc["estado"]!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueClienteDetail", sender: nil)
    }
    
}
