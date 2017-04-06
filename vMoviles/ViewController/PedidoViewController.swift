//
//  PedidoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoViewController:  UITableViewController,UISearchResultsUpdating {

    var searchController: UISearchController!
    var _storyboard: UIStoryboard!
    var _app: AppDelegate!
    var _pedidoLiveQuery: CBLLiveQuery!
    var _dbChangeObserver: AnyObject?
    var _lstPedidos: [CBLQueryRow]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        self._storyboard = storyboard
        // Setup SearchController:
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        self._app = UIApplication.shared.delegate as! AppDelegate

        self.creaNavegador()
        self.IniciaBaseDatos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if self._pedidoLiveQuery != nil {
            self._pedidoLiveQuery.removeObserver(self, forKeyPath: "rows")
            self._pedidoLiveQuery.stop()
        }
        
        if self._dbChangeObserver != nil {
            NotificationCenter.default.removeObserver(self._dbChangeObserver!)
        }
    }

    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == self._pedidoLiveQuery {
            self.RecargarPedidos()
        }
    }
    
    // Datos
    // MARK: - Database
    func IniciaBaseDatos() {
        self._pedidoLiveQuery = PedidoDatos(_database: self._app.database).setupViewAndQuery()
        self._pedidoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        self._pedidoLiveQuery.start()
    }
    
    func RecargarPedidos() {
        self._lstPedidos = self._pedidoLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        tableView.reloadData()
    }
    
    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        //Logo capa de ozono al centro
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo180x180.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Toolbar Izquierdo
        // badge label
        let label = UILabel(frame: CGRect(x: -20, y: -11, width: 140, height: 40))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "SanFranciscoText-Light", size: 13)
        label.textColor = .black
        let app = UIApplication.shared.delegate as! AppDelegate
        label.text = app.compania
        
        // boton que tiene el label
        let btnCompania = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        btnCompania.addTarget(self, action: #selector(backController), for: .touchUpInside)
        btnCompania.addSubview(label)
        
        let lblbuttonComapania = UIBarButtonItem(customView: btnCompania)
        
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(backController))
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        self.navigationItem.leftBarButtonItems = [barCompania, lblbuttonComapania]
        
        //Toolbar Derecho
        let brNuevo = UIBarButtonItem(title: "Nuevo", style: .plain, target: self, action: #selector(onNuevo))
        
        self.navigationItem.rightBarButtonItems = [brNuevo]
    }

    //Regresar a companias
    func backController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        let text = self.searchController.searchBar.text ?? ""
        
        if !text.isEmpty {
            self._pedidoLiveQuery.postFilter = NSPredicate(format: "key CONTAINS[cd] %@", text)
        } else {
            self._pedidoLiveQuery.postFilter = nil
        }
        self._pedidoLiveQuery.queryOptionsChanged()
    }

    // MARK: - UITableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._lstPedidos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoListCell", for: indexPath) as! lstPedidosTableViewCell
        
        let doc = self._lstPedidos![indexPath.row].document!
        let folio = doc["folio"] as! NSString
        
        cell.lblFolio?.text = folio as String
        cell.lblFechaCliente.text = doc["fechainicio"] as? String
        cell.lblFechaCreacion.text = doc["fechaCreacion"] as? String
        cell.lblPares.text = doc["pares"] as? String
        cell.lblTotal.text = doc["total"] as? String
        cell.lblEstatus.text = doc["estatus"] as? String
        if (doc["razonsocial"] as? String) != nil {
            cell.lblNomCliente.text = doc["razonsocial"] as? String
        }
        return cell
    }
    
    //Convierte el objeto al Modelo de pedido
    func EditaPedido(forDoc: CBLDocument) -> Pedido {
        let pedido = Pedido(folio: forDoc["folio"] as! String)

        pedido.fechaInicio = forDoc["fechainicio"] as! String
        pedido.fechaFin = forDoc["fechafin"] as! String
        pedido.fechaCancelacion = forDoc["fechacancelacion"] as! String
        pedido.fechaCreacion = forDoc["fechaCreacion"] as! String
        pedido.idcliente = forDoc["cliente"] as! String
        pedido.idembarque = forDoc["embarque"] as! String
        pedido.pares = Int(forDoc["pares"] as! String)
        pedido.estatus = forDoc["estatus"] as! String
        
        var total:String = forDoc["total"] as! String
        total = total.replacingOccurrences(of: "$", with: "")
        total = total.replacingOccurrences(of: ",", with: "")
        
        pedido.total = Double(total)!
        
        var dePedido :[RowPedidoProducto] = []
        let detalles = forDoc["renglones"] as! [Dictionary<String, Any>]
        
        for detalle in detalles {
            let row = CargaRenglonPedido(item: detalle)
            dePedido.append(row)
        }
        
        pedido.detalle = dePedido
        return pedido
    }
    
    func CargaRenglonPedido(item : Dictionary<String, Any>) -> RowPedidoProducto {
        var imgRow: UIImage?
        let cveCorrida: String = item["idCorrida"] as! String
        
        let rowCorrida = CorridaDatos(_database: self._app.database).CargarCorrida(idDocument: cveCorrida)
        
        let corrida = Corrida(for: rowCorrida!)
        let claveProd = item["cveart"] as! String
        imgRow = UIImage(named: "noImage")
        
        
        //Se carga la imagen el producto y se despliega en la interfaz
        let docImg = self._app.databaseImg.document(withID: claveProd)
        let rev = docImg?.currentRevision
        
        if let attachment = rev?.attachmentNamed("\(claveProd).jpg"), let data = attachment.content {
            let scale = UIScreen.main.scale
            imgRow = UIImage(data: data, scale: scale)!
        } else {
            imgRow = UIImage(named: "noImage")
        }
        
        let row = RowPedidoProducto(renglon: Int(item["renglon"] as? String ?? "0")!,cveart:item["cveart"] as! String,img: imgRow!,pielcolor:item["pielcolor"] as! String,tpc: item["tpc"] as! String, corrida: corrida!)
        
        row.estatus = item["status"] as! String
        row.estilo = item["estilo"] as! String
        row.linea = item["linea"] as! String
        row.numPck = item["numPck"] as! Int
        row.opcion = item["opcion"] as! String
        row.pares = item["pares"] as! Int
        row.pck = item["pck"] as! String
        row.precio = item["precio"] as! Double
        row.ts = item["ts"] as! String
        row.opcion = item["opcion"] as! String
        row.semana = item["semana"] as! String
        row.semanaCliente = item["semanaCli"] as! String
        
        row.p1 = item["p1"] as! String
        row.p2 = item["p2"] as! String
        row.p3 = item["p3"] as! String
        row.p4 = item["p4"] as! String
        row.p5 = item["p5"] as! String
        row.p6 = item["p6"] as! String
        row.p7 = item["p7"] as! String
        row.p8 = item["p8"] as! String
        row.p9 = item["p9"] as! String
        row.p10 = item["p10"] as! String
        row.p11 = item["p11"] as! String
        row.p12 = item["p12"] as! String
        row.p13 = item["p13"] as! String
        row.p14 = item["p14"] as! String
        row.p15 = item["p15"] as! String
        
        return row
    }
    
    func updateImage(image: UIImage?, withDigest digest: String, clave: String) {
        /*
        let docImg = _app.databaseImg.document(withID: clave)
        let rev = docImg?.currentRevision
        let revDigest = rev?.attachmentNamed("\(clave).jpg")?.metadata["digest"] as? String
        */
        print(clave)
    }
    
    //Mostrar detalle de un pedido existente
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            
            let pedido = self.EditaPedido(forDoc: (self._lstPedidos?[indexPath.row].document)!)
            
            let controller = _storyboard?.instantiateViewController(withIdentifier: "sbPedidosDetalle") as! PedidoDetalleViewController
            
            controller._pedido = pedido
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //Crear nuevo pedido
    func onNuevo()
    {
        let controller = _storyboard?.instantiateViewController(withIdentifier: "sbPedidosDetalle") as! PedidoDetalleViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
