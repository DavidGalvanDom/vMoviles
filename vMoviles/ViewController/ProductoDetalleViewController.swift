//
//  ProductoDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoDetalleViewController: UIViewController {

    var productoRows : [CBLQueryRow]?
    var productoLiveQuery: CBLLiveQuery!
    var dbChangeObserver: AnyObject?
    var _linea: String!
    var _estilo: String!
    var _app: AppDelegate!
    var _listaProdSelected: [RowPedidoProducto] = []
    
    @IBOutlet weak var lblNumProdSele: UILabel!
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let _selectColor = UIColor  (red:255.0,green:255.0,blue:255.0,alpha:128.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Se comparta igual que el tableview y no mande error cellForItemAtIndexPath
        self.collectionView.isPrefetchingEnabled = false
        self.collectionView.allowsMultipleSelection = true
        
        self.creaNavegador()
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        // Inicializa las vistas y querys couchbase lite:
        iniciaBaseDatos()
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
        
        
        if self._estilo != "" {
            productoLiveQuery = ProductoDatos(_database: _app.database).setupProdCeroViewAndQuery()
            productoLiveQuery.startKey = [self._estilo]
            productoLiveQuery.endKey = [self._estilo]
            productoLiveQuery.prefixMatchLevel = 1
        } else {
        
            if self._linea != "" {
                productoLiveQuery = ProductoDatos(_database: _app.database).setupProdCeroLineaViewAndQuery()
                productoLiveQuery.startKey = [self._linea]
                productoLiveQuery.endKey = [self._linea]
                productoLiveQuery.prefixMatchLevel = 1
            } else {
                productoLiveQuery = ProductoDatos(_database: _app.database).setupProdCeroViewAndQuery()
            }
        }

        productoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        productoLiveQuery.start()
    }
    
    func recargarProductos() {
        productoRows = productoLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        collectionView.reloadData()
    }

    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        //Logo capa de ozono al centro
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo180x180.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        //Toolbar Derecho
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(onShowInicial))
        
        let brRptProductos = UIBarButtonItem(image: UIImage(named:"rptProducto"), style: .plain, target: self, action: #selector(onRptProductos))
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .gray
        
        brRptProductos.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        brRptProductos.tintColor = .gray
        
        self.navigationItem.rightBarButtonItems = [barCompania, brRptProductos]
        
    }
    
    func onShowInicial() {
        self._app.showInicial()
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
                        
            let cell = self.collectionView.cellForItem(at: indexPath) as! productoCollectionViewCell
            cell.productoImage = image
            
        }
    }
    
    func SeleccionaProducto(cell: productoCollectionViewCell) {
        cell.layer.backgroundColor = self._selectColor.cgColor
        cell.seleccionaImagen = UIImage(named:"Ok")
    }
    
    func DesSeleccionaProducto(cell: productoCollectionViewCell) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.seleccionaImagen = nil
    }
    
    func onShowPedidos () {
    
    }
    
    func onClientes () {
        
    }
    
    //Solo se envian los productos seleccionados
    func onRptProductos() {
        if(self._listaProdSelected.count > 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "sbViewRptProducto") as! ReporteProdViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._email = ""
            vc._folio = "000"
            vc._rowPedidoProductos = self._listaProdSelected
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar por lo menos un producto.",
                                 withError: nil)
        }
    }
    
    @IBAction func onBuscar(_ sender: Any) {
        
    }
    
}


//Manejor de eventos de la coleccion de vistas
extension ProductoDetalleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productoRows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "viewCellProducto", for: indexPath) as! productoCollectionViewCell
        
        let doc = productoRows![indexPath.row].document!
        let costo = (doc["costo"] as! NSString).doubleValue
        let clave = doc["clave"] as! String
        cell.lblClave.text = "\(doc["estilo"]!) - \(doc["opcion"]!)"
        cell.lblEstilo.text = "\(doc["linea"]!)"
        cell.lblCosto.text = " $ \(costo)"
        cell.clave = clave
        
        //Se carga la imagen
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
                } else {
                    cell.productoImage = UIImage(named: "noImage")
                }
            }
        }
        
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        if cell.isSelected == true {
            self.SeleccionaProducto(cell: cell)
        } else {
            self.DesSeleccionaProducto(cell: cell)
        }
        
        return cell
    }
    
    //Seleccionar un item de la colección
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! productoCollectionViewCell
        
        if cell.isSelected == true {
            self.SeleccionaProducto(cell: cell)
        }
        
        let doc = productoRows![indexPath.row].document!
        let row = RowPedidoProducto(cveart: doc["clave"] as! String, pielcolor: doc["descripcion"] as! String, estilo: doc["estilo"] as! String, opcion: doc["opcion"] as! String, precio: (doc["costo"] as! NSString).doubleValue ,linea: doc["linea"] as! String, img: cell.image.image!)
        
        self._listaProdSelected.append(row)
        
        lblNumProdSele.text = "\(self._listaProdSelected.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! productoCollectionViewCell
        self.DesSeleccionaProducto(cell: cell)
        
        if let index = self._listaProdSelected.index(where: {$0.cveart == cell.clave}){
            self._listaProdSelected.remove(at: index)
        }
        
        lblNumProdSele.text = "\(self._listaProdSelected.count)"
    }
}
