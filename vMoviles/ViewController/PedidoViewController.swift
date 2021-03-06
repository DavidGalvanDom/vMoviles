//
//  PedidoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoViewController: UIViewController {

    @IBOutlet weak var viewPedidoTodos: UIView!
    @IBOutlet weak var viewPedido: UIView!
    @IBOutlet weak var tableViewTodos: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblMensaje: UILabel!
    
    var searchController: UISearchController!
    var searchControllerTodos: UISearchController!
    var _storyboard: UIStoryboard!
    var _app: AppDelegate!
    var _pedidoLiveQuery: CBLLiveQuery!
    var _pedidoLiveQueryTodos: CBLLiveQuery!
    var _dbChangeObserver: AnyObject?
    var _lstPedidos: [CBLQueryRow]?
    var _lstPedidosTodos: [CBLQueryRow]?
    var _flipeTable: Bool = true
    var _observando: String = "rows"

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
        
        searchControllerTodos = UISearchController(searchResultsController: nil)
        searchControllerTodos.searchResultsUpdater = self
        searchControllerTodos.dimsBackgroundDuringPresentation = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchController.searchBar
    
        self.tableViewTodos.delegate = self
        self.tableViewTodos.dataSource = self
        self.tableViewTodos.tableHeaderView = searchControllerTodos.searchBar
        
        self._app = UIApplication.shared.delegate as! AppDelegate

        self.creaNavegador()
        self.IniciaBaseDatos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self._lstPedidos != nil {
           self._lstPedidos = nil
        }
        
        if self._lstPedidosTodos != nil {
            self._lstPedidosTodos = nil
        }
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.TerminaObservable()
    }
    
    func TerminaObservable() {
        if self._pedidoLiveQuery != nil {
            
            if self._pedidoLiveQuery.observationInfo != nil {
                self._pedidoLiveQuery.removeObserver(self, forKeyPath: "rows")
            }
            self._pedidoLiveQuery.stop()
        }
        
        if self._pedidoLiveQueryTodos != nil {
            if self._pedidoLiveQueryTodos.observationInfo != nil {
                self._pedidoLiveQueryTodos.removeObserver(self, forKeyPath: "rows")
            }
            self._pedidoLiveQueryTodos.stop()
        }
        
        if self._dbChangeObserver != nil {
            NotificationCenter.default.removeObserver(self._dbChangeObserver!)
        }
    }

    // MARK: KNO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self._observando == "rows" {
            if object as? NSObject == self._pedidoLiveQuery {
                self.RecargarPedidos()
            }
        }
        
        if self._observando == "todos" {
            self.lblMensaje.text = "Cargando información..."
            if object as? NSObject == self._pedidoLiveQueryTodos {
                self.RecargarPedidosTodos()
                self.lblMensaje.text = ""
            }
        }
    }
    
    // Datos
    // MARK: - Database
    func IniciaBaseDatos() {
        self._pedidoLiveQuery = PedidoDatos(_database: self._app.database).setupViewAndQuery()
       
        if( self._pedidoLiveQuery  != nil ) {
            self._pedidoLiveQuery.startKey = [ESTATUS_PEDIDO_CAPTURADO]
            self._pedidoLiveQuery.endKey = [ESTATUS_PEDIDO_CAPTURADO]
            self._pedidoLiveQuery.prefixMatchLevel = 1
        }
        self._observando = "rows"
        self._pedidoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        self._pedidoLiveQuery.start()
    }
    
    func RecargarPedidos() {
        self._lstPedidos = self._pedidoLiveQuery.rows?.allObjects as? [CBLQueryRow] ?? nil
        self.tableView.reloadData()
    }
    
    func RecargarPedidosTodos() {
        self._lstPedidosTodos = self._pedidoLiveQueryTodos.rows?.allObjects as? [CBLQueryRow] ?? nil
        self.tableViewTodos.reloadData()
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
        
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(backController))
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        self.navigationItem.leftBarButtonItems = [barCompania]
        
        //Toolbar Derecho
        let brNuevo = UIBarButtonItem(title: "Nuevo", style: .plain, target: self, action: #selector(onNuevo))
        
        self.navigationItem.rightBarButtonItems = [brNuevo]
    }

    //Regresar a companias
    func backController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Convierte el objeto al Modelo de pedido
    func EditaPedido(forDoc: CBLDocument) -> Pedido {
        let pedido = Pedido(folio: forDoc["folio"] as! String)

        pedido._id = forDoc["_id"] as! String
        pedido.fechaInicio = forDoc["fechainicio"] as! String
        pedido.fechaFin = forDoc["fechafin"] as! String
        pedido.fechaCancelacion = forDoc["fechacancelacion"] as! String
        pedido.fechaCreacion = forDoc["fechaCreacion"] as! String
        pedido.idcliente = forDoc["cliente"] as! String
        pedido.idembarque = forDoc["embarque"] as! String
        pedido.pares = Int(forDoc["pares"] as! String)
        pedido.estatus = forDoc["estatus"] as! String
        pedido.observacion = forDoc["observacion"] as! String
        pedido.idtipoPedido = forDoc["idtipopedido"] as! String
        pedido.idcondicionPago = forDoc["idcondipago"] as! String
        pedido.condicionPago = forDoc["condipago"] as! String
        pedido.tipoPedido = forDoc["tipopedido"] as! String
        pedido.ordenCompra  = forDoc["ordencom"] as! String

        var total:String = forDoc["total"] as! String
        total = total.replacingOccurrences(of: ",", with: "")
        total = total.replacingOccurrences(of: "$", with: "")
        total = total.replacingOccurrences(of: "PMX", with: "")
        
        pedido.total = Double(total)!
        
        var dePedido :[RowPedidoProducto] = []
        let detalles = forDoc["renglones"] as! [Dictionary<String, Any>]
        
        for detalle in detalles {
            let row = CargaRenglonPedido(item: detalle)
            if(row != nil) {
                dePedido.append(row!)
            }
        }
        
        pedido.detalle = dePedido
        return pedido
    }
    
    func CargaRenglonPedido(item : Dictionary<String, Any>) -> RowPedidoProducto? {
        var imgRow: UIImage?
        let cveCorrida: String = item["idCorrida"] as! String
        
        if let rowCorrida = CorridaDatos(_database: self._app.database).CargarCorrida(idDocument: cveCorrida) {
            
            let corrida = Corrida(for: rowCorrida)
            corrida?.objectId = rowCorrida["_id"] as! String
            
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
            row.precioCCom = item["precioCCom"] as! Double
            row.precioCalle = item["precioCalle"] as! Double
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
        return nil
    }
    
    //Se cargan los status de los pedidos 
    func filtraTodos() {
        
        self.TerminaObservable()
        self._pedidoLiveQueryTodos = PedidoDatos(_database: self._app.database).setupStatusPedidoViewAndQuery()
        
        self._observando = "todos"
        self._pedidoLiveQueryTodos.addObserver(self, forKeyPath: "rows", options: [.new,.old], context: nil)
        
        self._pedidoLiveQueryTodos.start()
    }
    
    func filtrarTableView (index: Int) {
        self.TerminaObservable()
        self._pedidoLiveQuery = PedidoDatos(_database: self._app.database).setupViewAndQuery()
        
        switch(index){
        case 0:
            if( self._pedidoLiveQuery  != nil ) {
                self._pedidoLiveQuery.startKey = [ESTATUS_PEDIDO_CAPTURADO]
                self._pedidoLiveQuery.endKey = [ESTATUS_PEDIDO_CAPTURADO]
                self._pedidoLiveQuery.prefixMatchLevel = 1
            }
        case 1:
            
            if( self._pedidoLiveQuery  != nil ) {
                self._pedidoLiveQuery.startKey = [ESTATUS_PEDIDO_ENVIADO]
                self._pedidoLiveQuery.endKey = [ESTATUS_PEDIDO_ENVIADO]
                self._pedidoLiveQuery.prefixMatchLevel = 1
            }
        default:
            print("default")
        }
        self._observando = "rows"
        self._pedidoLiveQuery.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        self._pedidoLiveQuery.start()
    }
    
    //Crear nuevo pedido
    func onNuevo()
    {
        let controller = _storyboard?.instantiateViewController(withIdentifier: "sbPedidosDetalle") as! PedidoDetalleViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onCambiaSegment(_ sender: UISegmentedControl) {
        var executaTransition :Bool = true
        switch sender.selectedSegmentIndex {
        case 0,1:
            self.filtrarTableView(index: sender.selectedSegmentIndex)
            executaTransition = self._flipeTable ? false : true
        case 2:
            //Status de pedidos tableView todos
            self.filtraTodos()
        default:
            print("default")
        }
        
        if executaTransition {
            self._flipeTable = !self._flipeTable
            let fromView = self._flipeTable ? self.viewPedidoTodos: self.viewPedido
            let toView = self._flipeTable ? self.viewPedido : self.viewPedidoTodos
            UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
}

// MARK: - UITableViewController
extension PedidoViewController : UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {

    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        if self._observando == "rows" {
            let text = self.searchController.searchBar.text ?? ""

            if !text.isEmpty {
                self._pedidoLiveQuery.postFilter = NSPredicate(format: "key1 CONTAINS[cd] %@", text)
            } else {
                self._pedidoLiveQuery.postFilter = nil
            }
            self._pedidoLiveQuery.queryOptionsChanged()
        } else {
            let text = self.searchControllerTodos.searchBar.text ?? ""

            if !text.isEmpty {
                self._pedidoLiveQueryTodos.postFilter = NSPredicate(format: "key1 CONTAINS[cd] %@", text)
            } else {
                self._pedidoLiveQueryTodos.postFilter = nil
            }
            self._pedidoLiveQueryTodos.queryOptionsChanged()
        }
    }
    
    // MARK: - UITableViewController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return   self._lstPedidos?.count ?? 0
        }
        
        if tableView == self.tableViewTodos {
             return  self._lstPedidosTodos?.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
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
        } else {
            let cellTodos = tableView.dequeueReusableCell(withIdentifier: "pedidoListCellTodos", for: indexPath) as! pedidoTodosTableViewCell
            
            let doc = self._lstPedidosTodos![indexPath.row].document!
            let pedido = doc["pedido"] as! NSString

            cellTodos.lblFolio.text = pedido as String
            cellTodos.lblPares.text = doc["pares"] as? String
            cellTodos.lblCte.text = doc["cte"] as? String
            cellTodos.lblStatus.text = doc["status"] as? String
            cellTodos.lblSemana.text = doc["semana"] as? String
            cellTodos.lblFechaCap.text = doc["fhcap"] as? String
            cellTodos.lblEstilo.text = " \(doc["estilo"] ?? "") - \(doc["opcion"] ?? "") "
            cellTodos.lblTipo.text = doc["tipo"] as? String
            cellTodos.lblRenglon.text = doc["renglon"] as? String
            //cellTodos.lblOrdenCte.text = doc["ordencte"] as? String
            cellTodos.lblObse.text = doc["obs"] as? String

            return cellTodos
        }
    }
    
    //Mostrar detalle de un pedido existente
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row >= 0  && tableView == self.tableView {
        
            let doc = (self._lstPedidos?[indexPath.row].document)!
            let pedido = self.EditaPedido(forDoc: doc )
            
            let controller = _storyboard?.instantiateViewController(withIdentifier: "sbPedidosDetalle") as! PedidoDetalleViewController
            
            controller._pedido = pedido
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if indexPath.row >= 0  && tableView == self.tableViewTodos {
            let doc = self._lstPedidosTodos![indexPath.row].document!
            let idpedido = doc["pedido"] as! NSString
            
            //cargar el doc en base al id del documento
            if let doc = PedidoDatos(_database: self._app.database).CargarPedido(folio: String(idpedido)) {
                let pedido = self.EditaPedido(forDoc: doc )
                
                let controller = _storyboard?.instantiateViewController(withIdentifier: "sbPedidosDetalle") as! PedidoDetalleViewController
                
                controller._pedido = pedido
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    //Encabezado de las tablas
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        
        if tableView != self.tableView {
            title = " Folio            Renglón         Estilo          Pares     Estatus      Tipo      Semana          Captura        Cliente                  Observación"
        } else {
           title = "   Folio                                                Cliente                                              Creación          Pares                Total            Estatus           Cliente"
        }
        
        return title
    }

}
