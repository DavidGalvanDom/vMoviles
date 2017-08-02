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
    var _app: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup SearchController:
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar

        self._app = UIApplication.shared.delegate as! AppDelegate
        self.creaNavegador()
        // Inicializa las vistas y querys couchbase lite:
        self.iniciaBaseDatos()

        self.splitViewController?.maximumPrimaryColumnWidth = 320
        
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
    
    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        //Toolbar Derecho
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(onShowCompanias))
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barCompania]
        
    }
    
    func onShowCompanias() {
        self._app.showInicial()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueClienteDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow
            if indexPath!.row >= 0 {
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
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clienteRows?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientListCell", for: indexPath)
        
        let doc = clienteRows![indexPath.row].document!
        cell.textLabel?.text = "\(doc["id"]!) - \(doc["razonsocial"]!) "
        cell.detailTextLabel?.text = "\(doc["cpostal"]!) - \(doc["ciudad"]!) - \(doc["estado"]!) - \(doc["listaprec"]!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueClienteDetail", sender: nil)
    }
    
}
