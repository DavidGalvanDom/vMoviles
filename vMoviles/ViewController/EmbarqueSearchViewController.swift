//
//  EmbarqueSearchViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class EmbarqueSearchViewController : UIViewController,  UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating  {

    weak var delegate:SearchEmbarqueDelegate?
    
    var idCliente : String = ""
    var embarquesRows : [CBLQueryRow]?
    var embarqueLiveQuery: CBLLiveQuery!
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
        if embarqueLiveQuery != nil {
            embarqueLiveQuery.removeObserver(self, forKeyPath: "rows")
            embarqueLiveQuery.stop()
        }
        
        if dbChangeObserver != nil {
            NotificationCenter.default.removeObserver(dbChangeObserver!)
        }
    }

    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == embarqueLiveQuery {
            recargarEmbarques()
        }
    }
    
    // Datos
    // MARK: - Database
    func iniciaBaseDatos() {
        let app = UIApplication.shared.delegate as! AppDelegate
        embarqueLiveQuery = EmbarqueDatos(_database: app.database).setupViewEmbarquesClienteAndQuery()
        
        if( self.idCliente != "" ){
            embarqueLiveQuery.startKey = [idCliente]
            embarqueLiveQuery.endKey = [idCliente]
            embarqueLiveQuery.prefixMatchLevel = 1
        }
        
        embarqueLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        embarqueLiveQuery.start()
    }
    
    func recargarEmbarques() {
        embarquesRows = embarqueLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        tableView.reloadData()
    }


    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        
        if !text.isEmpty {
            embarqueLiveQuery.postFilter = NSPredicate(format: "key2 CONTAINS[cd] %@", text)
        } else {
            embarqueLiveQuery.postFilter = nil
        }
        embarqueLiveQuery.queryOptionsChanged()
    }
    
    // MARK: - UITableViewController
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return embarquesRows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "embarqueListCellSearch", for: indexPath)
        
        let doc = embarquesRows![indexPath.row].document!
        cell.textLabel?.text =  " \(doc["embarque"]!) - \(doc["direccion"]!)"
        cell.detailTextLabel?.text = "\(doc["keycli"]!) - \(doc["ciudad"]!) - \(doc["estado"]!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            let embarque = Embarque(for: (embarquesRows?[indexPath.row].document)!)
            delegate?.embarqueSeleccionado(sender: embarque!)
            dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        }
    }

    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }

    
}
