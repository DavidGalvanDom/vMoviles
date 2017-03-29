//
//  ClienteSearchViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/27/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ClienteSearchViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {

    weak var delegate:SearchClienteDelegate?
    var clienteRows : [CBLQueryRow]?
    var clienteLiveQuery: CBLLiveQuery!
    var dbChangeObserver: AnyObject?
    var searchController: UISearchController!
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup SearchController:
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Inicializa las vistas y querys couchbase lite:
        iniciaBaseDatos()
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
    
    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == clienteLiveQuery {
            recargarClientes()
        }
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

    // MARK: - UITableViewController
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clienteRows?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientListCellSearch", for: indexPath)
       
        let doc = clienteRows![indexPath.row].document!
        cell.textLabel?.text = "\(doc["id"]!) - \(doc["razonsocial"]!) "
        cell.detailTextLabel?.text = "\(doc["apostal"]!) - \(doc["ciudad"]!) - \(doc["estado"]!)"
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            let cliente = Cliente(for: (clienteRows?[indexPath.row].document)!)
            delegate?.clienteSeleccionado(sender: cliente!)
            dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        }
    }

    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }

}
