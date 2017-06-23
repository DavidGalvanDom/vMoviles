//
//  ProductoSearchViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/2/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoSearchViewController : UIViewController,  UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {

    weak var delegate:SearchProductoDelegate?
    var productoRows : [CBLQueryRow]?
    var productoLiveQuery: CBLLiveQuery!
    var dbChangeObserver: AnyObject?
    var searchController: UISearchController!
    var _listaPrecios: String!
    var _app: AppDelegate!
    var initSearch: String!
    
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
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        
        // Inicializa las vistas y querys couchbase lite:
        iniciaBaseDatos()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.initSearch.isEmpty != true) {
            searchController.searchBar.text = self.initSearch
            
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if productoLiveQuery != nil {
            productoLiveQuery.removeObserver(self, forKeyPath: "rows")
            productoLiveQuery.stop()
        }
        
        if dbChangeObserver != nil {
            NotificationCenter.default.removeObserver(dbChangeObserver!)
        }
    }
    
    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == productoLiveQuery {
            recargarProductos()
        }
    }
    
    // Datos
    // MARK: - Database
    func iniciaBaseDatos() {
        
        productoLiveQuery = ProductoDatos(_database: _app.database).setupLstPrecioViewAndQuery()
        
        if( self._listaPrecios != nil ) {
            productoLiveQuery.startKey = [self._listaPrecios]
            productoLiveQuery.endKey = [self._listaPrecios]
            productoLiveQuery.prefixMatchLevel = 1
        }
    
        productoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        productoLiveQuery.start()
    }

    
    func recargarProductos() {
        productoRows = productoLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        tableView.reloadData()
    }
    
    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        
        if !text.isEmpty {
            productoLiveQuery.postFilter = NSPredicate(format: "key2 CONTAINS[cd] %@", text)
        } else {
            productoLiveQuery.postFilter = nil
        }
        productoLiveQuery.queryOptionsChanged()
    }
    
    // MARK: - UITableViewController
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productoRows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoListCellSearch", for: indexPath) as! productoTableViewCell
        
        let doc = productoRows![indexPath.row].document!
        let costo = (doc["lista"] as! NSString).doubleValue
        cell.productoLabel.text = "\(doc["estilo"]!)  \(doc["opcion"]!) - \(doc["descripcion"]!) "
        cell.lblDetalle.text = "\(doc["linea"]!) - $ \(costo) "
        let clave = doc["clave"] as! String
        
        if( _app.databaseImg != nil) {
            let docImg = _app.databaseImg.document(withID: clave)
        
        
        if(docImg != nil) {
            let rev = docImg?.currentRevision
            if let attachment = rev?.attachmentNamed("\(clave).jpg"), let data = attachment.content {
                let digest = attachment.metadata["digest"] as! String
                let scale = UIScreen.main.scale
                let thumbnail = Image.square(image: UIImage(data: data, scale: scale), withSize: 85.0,
                                         withCacheName: digest, onComplete: { (thumbnail) -> Void in
                                            self.updateImage(image: thumbnail, withDigest: digest, atIndexPath: indexPath)
                })
                
                cell.productoImage = thumbnail
                cell.productoImageAction = {
                    //self.taskForImage = doc
                    //self.performSegue(withIdentifier: "showTaskImage", sender: self)
                }
            } else {
                
                cell.productoImage = UIImage(named: "noImage")
                cell.productoImageAction = {
               // self.taskForImage = doc
                Ui.showImageActionSheet(onController: self, withImagePickerDelegate: self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                }
            }
        }
        }
        return cell
    }
    
    func updateImage(image: UIImage?, withDigest digest: String, atIndexPath indexPath: IndexPath) {
        guard let rows = self.productoRows, rows.count > indexPath.row else {
            return
        }
        
        let doc = rows[indexPath.row].document!
        let clave = doc["clave"] as! String
        let docImg = _app.databaseImg.document(withID: clave)
        let rev = docImg?.currentRevision
        
        if let revDigest = rev?.attachmentNamed("\(clave).jpg")?.metadata["digest"] as? String, digest == revDigest {
            
            if  let cell = tableView.cellForRow(at: indexPath) as? productoTableViewCell {
                cell.productoImage = image
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            let producto = Producto(for: (productoRows?[indexPath.row].document)!)
            let cell:productoTableViewCell = tableView.cellForRow(at: indexPath) as! productoTableViewCell
            
            var imageProd: UIImage?
            if( cell.productoImage != nil) {
                 imageProd = cell.imageButton.image(for: .normal)! as UIImage
            } else {
                imageProd = UIImage(named: "noImage")
            }
            
            delegate?.productoSeleccionado(sender: producto!, image: imageProd)
            dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        }
    }
    
    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
    }

}
