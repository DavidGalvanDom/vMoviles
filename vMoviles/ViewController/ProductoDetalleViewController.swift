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
    var _articulosPorSelec: [String] = []
    var _editar: Bool! = false
    var _linea: String!
    var _tipo: [String] = []
    var _categoria: [String] = []
    var _app: AppDelegate!
        
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var lblNumProdSele: UILabel!
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTotal: UILabel!
    
    let _selectColor = UIColor  (red:255.0,green:255.0,blue:255.0,alpha:128.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMensaje.text = "Cargando información..."
        self._articulosPorSelec.removeAll()
        self._app = UIApplication.shared.delegate as! AppDelegate
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Se comparta igual que el tableview y no mande error cellForItemAtIndexPath
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
        self.collectionView.allowsMultipleSelection = false
        self.creaNavegador()
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        lblNumProdSele.text = "\(self._app.listaProdSelected.count)"
        
        // Inicializa las vistas y querys couchbase lite:
        self.iniciaBaseDatos()
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
         var inicioLetra : String = ""
         var finLetra : String = ""
        if self._linea != "" {
            productoLiveQuery = ProductoDatos(_database: _app.database).setupProdCeroViewAndQuery()
            productoLiveQuery.startKey = [self._linea]
            productoLiveQuery.endKey = [self._linea]
            productoLiveQuery.prefixMatchLevel = 1
        } else {
            productoLiveQuery = ProductoDatos(_database: _app.database).setupProdCeroCategoViewAndQuery()
            
            if self._tipo.count > 0 {
                
                for tipo in self._tipo {
                    let startIndex = tipo.index(tipo.startIndex, offsetBy: 0)
                    let endIndex = tipo.index(tipo.startIndex, offsetBy: 0)
                    let letra = tipo[startIndex...endIndex]
                    
                    switch (letra) {
                    case "A":
                        inicioLetra = "A"
                        finLetra = finLetra == "D" || finLetra == "C" ? finLetra : "A"
                    case "C":
                        inicioLetra = inicioLetra == "A" ? inicioLetra : "C"
                        finLetra = finLetra == "D" ? finLetra : "C"
                    case "D":
                        inicioLetra = inicioLetra == "A" || inicioLetra == "C" ? inicioLetra : "D"
                        finLetra = "D"
                    default:
                        inicioLetra = "A"
                        finLetra = "A"
                    }
                }
                
                productoLiveQuery.startKey = [inicioLetra]
                productoLiveQuery.endKey = [finLetra]
            }
            productoLiveQuery.prefixMatchLevel = 1
        }
        
        productoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        productoLiveQuery.start()
        
    }
    
    func recargarProductos() {
        self.productoRows = productoLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        
        if self._categoria.count > 0 {
            self.productoRows = self.productoRows?.filter { self.filtraCategorias(rowQuery: $0) }
        }
        
        let total = productoRows?.count ?? 0
        self.lblTotal.text = " \(total)"
        collectionView.reloadData()
            
        lblMensaje.text = total < 1 ? "No se encontro información.":""
            
    }

    func filtraCategorias (rowQuery: CBLQueryRow) -> Bool {
        for categoria in self._categoria {
            if(categoria == rowQuery.document?["categoria"] as! String){
                return true
            }
        }
        return false
    }
    
    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        //Logo capa de ozono al centro
        let imageName = String(self._app.database.name) == "vmepi" ? "LogoEpisodio180x180.png" : "logo180x180.png"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: imageName)
        imageView.image = image
        navigationItem.titleView = imageView
        
        //Toolbar Derecho
        let brRptProductos = UIBarButtonItem(image: UIImage(named:"rptProducto"), style: .plain, target: self, action: #selector(onRptProductos))
        
        let barEditar = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(onEditar))
        
        brRptProductos.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        brRptProductos.tintColor = .gray
        
        self.navigationItem.rightBarButtonItems = [brRptProductos, barEditar]
        
        if self._app.listaProdSelected.count > 0 {
            barEditar.title = "Cancelar"
            self._editar = true
            self.collectionView.allowsMultipleSelection = true
            //Este arreglo solo indica que productos deben aparecer como seleccionados
            //en caso de que aparescan en el filtro activo
            for prod in self._app.listaProdSelected {
                self._articulosPorSelec.append(prod.cveart)
            }
        }
    }
    
    func onEditar(sender: UIBarButtonItem) {
        if sender.title == "Cancelar" {
            self._editar = false
            self.collectionView.allowsMultipleSelection = false
            sender.title = "Editar"
            self._app.listaProdSelected.removeAll()
            self.lblNumProdSele.text = "0"
            //las celdas que estan visibles se quita la imagen
            for cell in self.collectionView.visibleCells {
                let cellView = cell as! productoCollectionViewCell
                self.DesSeleccionaProducto(cell: cellView)
            }
            self._articulosPorSelec.removeAll()
        } else {
            self._editar = true
            self.collectionView.allowsMultipleSelection = true
            sender.title = "Cancelar"
        }
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
                        
            if let cell = self.collectionView.cellForItem(at: indexPath) as? productoCollectionViewCell {
                cell.productoImage = image
            }
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
   
    //Solo se envian los productos seleccionados
    func onRptProductos() {
        if(self._app.listaProdSelected.count > 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "sbViewRptProducto") as! ReporteProdViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._email = ""
            vc._folio = "000"
            vc._productosDetalle = self._app.listaProdSelected
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar por lo menos un producto.",
                                 withError: nil)
        }
    }
    
    func detalleImagen(cell : productoCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "sbOpcionProducto") as! OpcionProductoViewController
        
        vc._claveProd = cell.clave
        vc._estilo = cell.estilo
        vc._listaPrecios  = "0"
        vc._app = self._app
        vc.preferredContentSize = CGSize(width: 990, height: 690)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: { _ in })
        
    }
    
    @IBAction func onBuscar(_ sender: Any) {
        let text = self.txtBuscar.text ?? ""
        
        if !text.isEmpty {
            productoLiveQuery.postFilter = NSPredicate(format: "key2 CONTAINS[cd] %@", text)
        } else {
            productoLiveQuery.postFilter = nil
        }
        productoLiveQuery.queryOptionsChanged()
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
        let costo = (doc["lista"] as! NSString).doubleValue
        let clave = doc["clave"] as! String
        cell.lblClave.text = "\(doc["estilo"]!) - \(doc["opcion"]!)"
        cell.lblEstilo.text = "\(doc["linea"]!)"
        cell.lblCosto.text = " $ \(costo)"
        cell.clave = clave
        cell.estilo = doc["estilo"] as! String
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        //Se carga la imagen
        if( _app.databaseImg != nil) {
            let docImg = _app.databaseImg.document(withID: clave)
            if(docImg != nil) {
                let rev = docImg?.currentRevision
                if let attachment = rev?.attachmentNamed("\(clave).jpg"), let data = attachment.content {
                    let digest = attachment.metadata["digest"] as! String
                    let scale = UIScreen.main.scale
                    let thumbnail = Image.square(image: UIImage(data: data, scale: scale), withSize: 176,
                                                 withCacheName: digest, onComplete: { (thumbnail) -> Void in
                                                    self.updateImage(image: thumbnail, withDigest: digest, atIndexPath: indexPath)
                    })
                    
                    cell.productoImage = thumbnail
                } else {
                    cell.productoImage = UIImage(named: "noImage")
                }
            }
        }
        
        if self._editar {
            if cell.isSelected == true {
                self.SeleccionaProducto(cell: cell)
            } else {
                //Validar si existe en la coleccion para seleccionarlo de alguna otra busqueda
                if let index = self._articulosPorSelec.index(where: { $0 == clave}) {
                    self.SeleccionaProducto(cell: cell)
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    self._articulosPorSelec.remove(at: index)
                } else {
                    self.DesSeleccionaProducto(cell: cell)
                }
            }
        }
        
        return cell
    }
    
    //Seleccionar un item de la colección
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath) as! productoCollectionViewCell
        
        if self._editar {
            if cell.isSelected == true {
                self.SeleccionaProducto(cell: cell)
                let doc = productoRows![indexPath.row].document!
                let row = ProductoDetalle(cveart: doc["clave"] as! String, pielcolor: doc["descripcion"] as! String, estilo: doc["estilo"] as! String, opcion: doc["opcion"] as! String, precio: (doc["lista"] as! NSString).doubleValue ,linea: doc["linea"] as! String, img: (cell.image.image)!,isSelected: true)
                
                self._app.listaProdSelected.append(row)
                
                lblNumProdSele.text = "\(self._app.listaProdSelected.count)"
            }
        } else {
            detalleImagen(cell: cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if self._editar {
            let cell = collectionView.cellForItem(at: indexPath) as! productoCollectionViewCell
            self.DesSeleccionaProducto(cell: cell)
        
            if let index = self._app.listaProdSelected.index(where: {$0.cveart == cell.clave}){
                self._app.listaProdSelected.remove(at: index)
            }
        
            lblNumProdSele.text = "\(self._app.listaProdSelected.count)"
        }
    }
    
}
