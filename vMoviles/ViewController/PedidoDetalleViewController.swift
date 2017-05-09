//
//  PedidoDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoDetalleViewController: UIViewController, SearchClienteDelegate, SearchEmbarqueDelegate, PedidoProductoDelegate{
   
    @IBOutlet weak var viewDetalle: UIScrollView!
    @IBOutlet weak var lblMsgPares: UILabel!
    @IBOutlet weak var lblMsgTotal: UILabel!
    @IBOutlet weak var lblCondicionPago: UILabel!
    @IBOutlet weak var lblTipoPedido: UILabel!
    @IBOutlet weak var txtComentario: UITextView!
    @IBOutlet weak var txtOrdenCompra: UITextField!
    @IBOutlet weak var txtTipoPedido: UITextField!
    @IBOutlet weak var txtCondicionPago: UITextField!
    @IBOutlet weak var viewDos: UIView!
    @IBOutlet weak var viewUno: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblRfc: UILabel!
    @IBOutlet weak var txtCliente: UITextField!
    @IBOutlet weak var lblCuenta: UILabel!
    @IBOutlet weak var lblCalificacion: UILabel!
    @IBOutlet weak var txtEmbarque: UITextField!
    @IBOutlet weak var lblEmbarDireccion: UILabel!
    @IBOutlet weak var txtFechaIni: UITextField!
    @IBOutlet weak var lblFolio: UILabel!
    @IBOutlet weak var txtFechaFin: UITextField!
    @IBOutlet weak var txtFechaCancelada: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPares: UILabel!
    @IBOutlet weak var chkEnviar: UISwitch!
    @IBOutlet weak var lblEstatus: UILabel!
    @IBOutlet weak var btnNuevoProd: UIButton!
    @IBOutlet weak var btnBuscarCliente: UIButton!
    @IBOutlet weak var btnOcultaDetalle: UIButton!
    
    var pickerTipoPedido: UIPickerView!
    var pickerCondicionPago: UIPickerView!
    
    var _storyboard: UIStoryboard!
    var _dateFormatter = DateFormatter()
    var _semanas: Dictionary<String, Any> = [:]
    var _app: AppDelegate!
    var _pedido: Pedido!
    var _lstTipoPedidos: [TipoPedido] = []
    var _lstCondicionPago: [CondicionesPago] = []
    var _tipo: String = "Nuevo" //Si se edita o es nuevo

    override func viewDidLoad() {
        super.viewDidLoad()
        self._dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        guard let root = self._app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        self._storyboard = storyboard
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.scrollView.delegate = self
        
        self.pickerTipoPedido = UIPickerView()
        self.pickerCondicionPago = UIPickerView()

        self.pickerTipoPedido.dataSource = self
        self.pickerTipoPedido.delegate = self
        self.pickerCondicionPago.dataSource = self
        self.pickerCondicionPago.delegate = self
        
        self.txtCondicionPago.inputView = self.pickerCondicionPago
        self.txtTipoPedido.inputView = self.pickerTipoPedido
        
        if(self._pedido == nil) {
            self.IniciaNuevo()
        } else {
            self.IniciaEditar()
        }
        
        self.creaNavegador()
        self.btnBuscarCliente.isEnabled = (self._pedido.detalle.count < 1)
        
        //Se agregaron atributos en runtime en el storyboard para que funcione el scrollview
        //para captura del encavezado del pedido
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        //Se cargan las listas
        self.CargarListaTipoPedido()
        self.CargarListaCondicionesPago()
    }
    
    func IniciaEditar () {
        self._tipo = "Editar"
        self.lblFolio.text = self._pedido.folio
        self.txtFechaIni.text = self._pedido.fechaInicio
        self.txtFechaFin.text = self._pedido.fechaFin
        self.txtFechaCancelada.text = self._pedido.fechaCancelacion
        self.lblPares.text = "\(self._pedido.pares!)"
        self.lblTotal.text = self._app.formatCurrency("\(self._pedido.total)")
        self.txtComentario.text = self._pedido.observacion
        
        self.txtCondicionPago.text  = self._pedido.idcondicionPago
        self.txtTipoPedido.text  = self._pedido.idtipoPedido
        self.lblCondicionPago.text  = self._pedido.condicionPago
        self.lblTipoPedido.text = self._pedido.tipoPedido
        self.txtOrdenCompra.text = self._pedido.ordenCompra
        
        self.lblEstatus.text = self._pedido.estatus
        chkEnviar.isOn = self._pedido.estatus == ESTATUS_PEDIDO_CAPTURADO ? true : false
        
        let doc = ClienteDatos(_database: self._app.database).CargarCliente(cliente: "cliente-\(self._pedido.idcliente!)")
        
        if doc != nil {
            let cliente = Cliente(for: (doc)!)
            self.clienteSeleccionado(sender: cliente!)
        }
        
        let cveEmbarque = "embar\(self._pedido.idcliente!)-\(self._pedido.idembarque!)"
        let docEmbar = EmbarqueDatos(_database: self._app.database).CargarEmbarque(embarque: cveEmbarque)
        
        if docEmbar != nil {
            let embarque = Embarque(for: (docEmbar)!)
            self.embarqueSeleccionado(sender: embarque!)
        }
    }
    
    func IniciaNuevo() {
        self._tipo = "Nuevo"
        self.lblFolio.text = self._app.config.folio as String
        self.AsignarFechas()
        self.CargarSemanas()
        
        self._pedido = Pedido(folio: self.lblFolio.text!)
        self._pedido.estatus = ESTATUS_PEDIDO_CAPTURADO
        self._pedido.fechaCreacion = self._dateFormatter.string(from: Date())
    }
    
    //Se calculan las fechas del nuevo pedido
    func AsignarFechas() {
        let hoy = Date()
        let fhInicio = Calendar.current.date(byAdding: .day, value: 7, to: hoy)
        let fhFin = Calendar.current.date(byAdding: .day, value: 42, to: hoy)
        let fhCancelacion = Calendar.current.date(byAdding: .day, value: 42, to: hoy)
        
        self.txtFechaIni.text = self._dateFormatter.string(from: fhInicio!)
        self.txtFechaFin.text = self._dateFormatter.string(from: fhFin!)
        self.txtFechaCancelada.text = self._dateFormatter.string(from: fhCancelacion!)
    }
    
    //Se cargan las semanas por el tipo de servicio
    func CargarSemanas() {
        let semDatos = SemanasDatos( _database: self._app.database)
        self._semanas = semDatos.CargarSemanas()
    }
    
    func CambiaTamanoVistas(opcion: Int) {
        switch(opcion){
            case 0:
                self.viewUno.frame = CGRect(x: 8, y: 0, width: 985, height: 140)
                self.viewDos.frame = CGRect(x: 1000, y: 0, width: 1045, height: 140)
            case 1:
                self.viewUno.frame = CGRect(x: 8, y: 0, width: 1045, height: 140)
                self.viewDos.frame = CGRect(x: 1060, y: 0, width: 985, height: 140)
            default:
                self.viewUno.frame = CGRect(x: 8, y: 0, width: 985, height: 140)
                self.viewDos.frame = CGRect(x: 1000, y: 0, width: 1045, height: 140)
        }
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
        
        let barListaPedidos = UIBarButtonItem(image: UIImage(named:"Pedido2"), style: .plain, target: self, action: #selector(backController))
        barListaPedidos.imageInsets = UIEdgeInsetsMake(7, 5, 7, 5)
        barListaPedidos.tintColor = .gray
        
        self.navigationItem.leftBarButtonItems = [barListaPedidos, lblbuttonComapania]
        
        //Toolbar Derecho
        let brRptProductos = UIBarButtonItem(image: UIImage(named:"rptProducto"), style: .plain, target: self, action: #selector(onRptProductos))
        
        let brRptPedido = UIBarButtonItem(image: UIImage(named:"PDF"), style: .plain, target: self, action: #selector(onRptPedido))
        
        brRptProductos.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        brRptProductos.tintColor = .gray
        
        brRptPedido.imageInsets = UIEdgeInsetsMake(5, 2, 5, 2)
        brRptPedido.tintColor = .gray
        
        if(self._pedido?.estatus == ESTATUS_PEDIDO_CAPTURADO) {
            let brGuardar = UIBarButtonItem(image: UIImage(named:"Save"), style: .plain, target: self, action: #selector(onGuardar))
            brGuardar.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            brGuardar.tintColor = .gray
            self.navigationItem.rightBarButtonItems = [brRptPedido,brRptProductos,brGuardar]
            self.btnNuevoProd.tintColor = .gray
        } else {
            self.navigationItem.rightBarButtonItems = [brRptPedido,brRptProductos]
            self.btnNuevoProd.isHidden = true
        }
        
        //Formato vistas
        self.viewUno.layer.borderWidth = 1.0
        self.viewUno.layer.cornerRadius = 6
        self.viewUno.layer.borderColor = UIColor.lightGray.cgColor
        
        self.viewDos.layer.borderWidth = 1.0
        self.viewDos.layer.cornerRadius = 6
        self.viewDos.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func DespliegaCorrida (cell: pedidoTableViewCell) {
        
        cell.lblc10.isHidden = !(cell.lblc10.text != "0")
        cell.lblp10.isHidden = !(cell.lblc10.text != "0")
        
        cell.lblc11.isHidden = !(cell.lblc11.text != "0")
        cell.lblp11.isHidden = !(cell.lblc11.text != "0")
        
        cell.lblc12.isHidden = !(cell.lblc12.text != "0")
        cell.lblp12.isHidden = !(cell.lblc12.text != "0")
        
        cell.lblc13.isHidden = !(cell.lblc13.text != "0")
        cell.lblp13.isHidden = !(cell.lblc13.text != "0")
        
        cell.lblc14.isHidden = !(cell.lblc14.text != "0")
        cell.lblp14.isHidden = !(cell.lblc14.text != "0")
        
        cell.lblc15.isHidden = !(cell.lblc15.text != "0")
        cell.lblp15.isHidden = !(cell.lblc15.text != "0")
        
    }
    
    func FormatoLabel (cell: pedidoTableViewCell)
    {
        cell.lblc1.layer.borderWidth = 1.0
        cell.lblc1.layer.cornerRadius = 6
        cell.lblc2.layer.borderWidth = 1.0
        cell.lblc2.layer.cornerRadius = 6
        cell.lblc3.layer.borderWidth = 1.0
        cell.lblc3.layer.cornerRadius = 6
        cell.lblc4.layer.borderWidth = 1.0
        cell.lblc4.layer.cornerRadius = 6
        cell.lblc5.layer.borderWidth = 1.0
        cell.lblc5.layer.cornerRadius = 6
        cell.lblc6.layer.borderWidth = 1.0
        cell.lblc6.layer.cornerRadius = 6
        cell.lblc7.layer.borderWidth = 1.0
        cell.lblc7.layer.cornerRadius = 6
        cell.lblc8.layer.borderWidth = 1.0
        cell.lblc8.layer.cornerRadius = 6
        cell.lblc9.layer.borderWidth = 1.0
        cell.lblc9.layer.cornerRadius = 6
        cell.lblc10.layer.borderWidth = 1.0
        cell.lblc10.layer.cornerRadius = 6
        cell.lblc11.layer.borderWidth = 1.0
        cell.lblc11.layer.cornerRadius = 6
        cell.lblc12.layer.borderWidth = 1.0
        cell.lblc12.layer.cornerRadius = 6
        cell.lblc13.layer.borderWidth = 1.0
        cell.lblc13.layer.cornerRadius = 6
        cell.lblc14.layer.borderWidth = 1.0
        cell.lblc14.layer.cornerRadius = 6
        cell.lblc15.layer.borderWidth = 1.0
        cell.lblc15.layer.cornerRadius = 6
        
        cell.lblp1.layer.borderWidth = 1.0
        cell.lblp1.layer.cornerRadius = 6
        cell.lblp2.layer.borderWidth = 1.0
        cell.lblp2.layer.cornerRadius = 6
        cell.lblp3.layer.borderWidth = 1.0
        cell.lblp3.layer.cornerRadius = 6
        cell.lblp4.layer.borderWidth = 1.0
        cell.lblp4.layer.cornerRadius = 6
        cell.lblp5.layer.borderWidth = 1.0
        cell.lblp5.layer.cornerRadius = 6
        cell.lblp6.layer.borderWidth = 1.0
        cell.lblp6.layer.cornerRadius = 6
        cell.lblp7.layer.borderWidth = 1.0
        cell.lblp7.layer.cornerRadius = 6
        cell.lblp8.layer.borderWidth = 1.0
        cell.lblp8.layer.cornerRadius = 6
        cell.lblp9.layer.borderWidth = 1.0
        cell.lblp9.layer.cornerRadius = 6
        cell.lblp10.layer.borderWidth = 1.0
        cell.lblp10.layer.cornerRadius = 6
        cell.lblp11.layer.borderWidth = 1.0
        cell.lblp11.layer.cornerRadius = 6
        cell.lblp12.layer.borderWidth = 1.0
        cell.lblp12.layer.cornerRadius = 6
        cell.lblp13.layer.borderWidth = 1.0
        cell.lblp13.layer.cornerRadius = 6
        cell.lblp14.layer.borderWidth = 1.0
        cell.lblp14.layer.cornerRadius = 6
        cell.lblp15.layer.borderWidth = 1.0
        cell.lblp15.layer.cornerRadius = 6
    }
    
    func IniciaDatosRenglon(cell: pedidoTableViewCell, renglon: RowPedidoProducto)
    {
        cell.productoImage = renglon.imagen
        cell.lblRenglon.text = String(renglon.renglon)
        cell.lblPielColor.text = renglon.pielcolor
        cell.lblClave.text = renglon.cveart
        cell.lblSemana.text = renglon.semana
        cell.lblSemanaCli.text = renglon.semanaCliente
        cell.lblTS.text = renglon.ts
        cell.lblPrecio.text = " $ \(renglon.precio)"
        cell.lblPares.text = "\(renglon.pares)"
        cell.lblPK.text = renglon.pck
        cell.lblInter.text = "\(renglon.numPck)"
        
        cell.lblp1.text = renglon.p1
        cell.lblp2.text = renglon.p2
        cell.lblp3.text = renglon.p3
        cell.lblp4.text = renglon.p4
        cell.lblp5.text = renglon.p5
        cell.lblp6.text = renglon.p6
        cell.lblp7.text = renglon.p7
        cell.lblp8.text = renglon.p8
        cell.lblp9.text = renglon.p9
        cell.lblp10.text = renglon.p10
        cell.lblp11.text = renglon.p11
        cell.lblp12.text = renglon.p12
        cell.lblp13.text = renglon.p13
        cell.lblp14.text = renglon.p14
        cell.lblp15.text = renglon.p15
        
        cell.lblc1.text = renglon.corrida.c1 as String
        cell.lblc2.text = renglon.corrida.c2 as String
        cell.lblc3.text = renglon.corrida.c3 as String
        cell.lblc4.text = renglon.corrida.c4 as String
        cell.lblc5.text = renglon.corrida.c5 as String
        cell.lblc6.text = renglon.corrida.c6 as String
        cell.lblc7.text = renglon.corrida.c7 as String
        cell.lblc8.text = renglon.corrida.c8 as String
        cell.lblc9.text = renglon.corrida.c9 as String
        cell.lblc10.text = renglon.corrida.c10 as String
        cell.lblc11.text = renglon.corrida.c11 as String
        cell.lblc12.text = renglon.corrida.c12 as String
        cell.lblc13.text = renglon.corrida.c13 as String
        cell.lblc14.text = renglon.corrida.c14 as String
        cell.lblc15.text = renglon.corrida.c15 as String
        
        cell.taskImageAction = {
            
            if(self._pedido.cliente != nil) {
                let vc = self._storyboard.instantiateViewController(withIdentifier: "sbPedidoProducto") as! PedidoProductoViewController
                
                vc.preferredContentSize = CGSize(width: 950, height: 420)
                vc.modalPresentationStyle = .formSheet
                vc.modalTransitionStyle = .crossDissolve
                vc._listaPrecios =  self._pedido.cliente?.listaprec as String!
                vc._estatusProducto = self._pedido?.estatus
                vc._renglon = renglon.renglon
                vc._rowPedidoProducto = renglon
                vc._semanas = self._semanas
                vc.delegate = self
                self.present(vc, animated: true, completion: { _ in })
                
            } else {
                Ui.showMessageDialog(onController: self,
                                     withTitle: "Informacion",
                                     withMessage: "Debe seleccionar un Cliente",
                                     withError: nil)
            }
        }
        
    }

    // MARK: Funciones generales
    func CalculaTotales()
    {
        var total: Double = 0
        var pares: Int = 0
        
        for item in self._pedido.detalle {
            pares = pares + item.pares
            total = total + (Double(item.pares) * item.precio)
        }
        
        self.lblTotal.text = self._app.formatCurrency("\(total)")
        self.lblPares.text = String(pares)
    }
    
    func GuardarNuevoPedido() -> CBLSavedRevision? {
        var properties: Dictionary<String, Any> = [
            "type": "pedido"
        ]

        properties["folio"] = self._app.config.folio
        properties["cliente"] = self._pedido.cliente?.id
        properties["razonsocial"] = self._pedido.cliente?.razonsocial
        properties["embarque"] = self._pedido.embarque?.embarque
        properties["fechainicio"] = self.txtFechaIni.text ?? ""
        properties["fechafin"] = self.txtFechaFin.text ?? ""
        properties["fechacancelacion"] = self.txtFechaCancelada.text ?? ""
        properties["total"] = self.lblTotal.text ?? "0"
        properties["pares"] = self.lblPares.text ?? "0"
        properties["vendedor"] = self._app.config.agente
        properties["estatus"] = self.chkEnviar.isOn ?  ESTATUS_PEDIDO_CAPTURADO : ESTATUS_PEDIDO_ENVIADO
        properties["fechaCreacion"] = CBLJSON.jsonObject(with: Date())
        properties["renglones"] =  self.RenglonesPedidoDB()
        properties["observacion"] =  self.txtComentario.text ?? ""
        
        properties["idcondipago"] = self.txtCondicionPago.text ?? ""
        properties["idtipopedido"] = self.txtTipoPedido.text ?? ""
        properties["condipago"] = self.lblCondicionPago.text ?? ""
        properties["tipopedido"] = self.lblTipoPedido.text ?? ""
        properties["ordencom"] = self.txtOrdenCompra.text ?? ""

        
        let doc = self._app.database.createDocument()
        
        do {
            return try doc.putProperties(properties)
        } catch let error as NSError {
            Ui.showMessageDialog(onController: self, withTitle: "Error",
                                 withMessage: "No se pudo guardar el pedido", withError: error)
            return nil
        }
    }
    
    func ActualizarPedido()  {
        let docPedido = PedidoDatos(_database: self._app.database).CargarPedido(folio: self._pedido._id)
        
         //nr = Nueva Revision
         do {
            try docPedido?.update { nr in
                nr["embarque"] = self._pedido.embarque?.embarque
                nr["fechainicio"] = self.txtFechaIni.text ?? ""
                nr["fechafin"] = self.txtFechaFin.text ?? ""
                nr["fechacancelacion"] = self.txtFechaCancelada.text ?? ""
                nr["total"] = self.lblTotal.text ?? "0"
                nr["pares"] = self.lblPares.text ?? "0"
                nr["vendedor"] = self._app.config.agente
                nr["estatus"] = self.chkEnviar.isOn ?  ESTATUS_PEDIDO_CAPTURADO : ESTATUS_PEDIDO_ENVIADO
                nr["fechaCreacion"] = CBLJSON.jsonObject(with: Date())
                nr["renglones"] =  self.RenglonesPedidoDB()
                nr["observacion"] =  self.txtComentario.text ?? ""
                nr["idcondipago"] = self.txtCondicionPago.text ?? ""
                nr["idtipopedido"] = self.txtTipoPedido.text ?? ""
                nr["condipago"] = self.lblCondicionPago.text ?? ""
                nr["tipopedido"] = self.lblTipoPedido.text ?? ""
                nr["ordencom"] = self.txtOrdenCompra.text ?? ""
                
                return true
            }
         } catch let error as NSError {
                Ui.showMessageDialog(onController: self, withTitle: "Error", withMessage: "No se pudo actualizar el Pedido", withError: error)
         }
    }
    
    ///Se genera la lista de renglones para el formato de base de datos Dictionary
    func RenglonesPedidoDB() -> [Dictionary<String, Any>] {
        var renglones : [Dictionary<String, Any>] = []
        
        //Se generan los renglones
        for item in self._pedido.detalle {
            
            var renglon: Dictionary<String, Any> = [
                "renglon": String(item.renglon)
            ]
            renglon["status"] = "activo"
            renglon["linea"] = item.linea
            renglon["semana"] = item.semana
            renglon["semanaCli"] = item.semanaCliente
            renglon["cveart"] =  item.cveart
            renglon["opcion"] = item.opcion
            renglon["precioCCom"] = item.precioCCom
            renglon["precioCalle"] = item.precioCalle
            renglon["estilo"] =  item.estilo
            renglon["pares"] =  item.pares
            renglon["precio"] = item.precio
            renglon["pielcolor"] =  item.pielcolor
            renglon["ts"] =  item.ts
            renglon["pck"] =  item.pck
            renglon["tpc"] =  item.tpc
            renglon["numPck"] =  item.numPck
            renglon["idCorrida"] = item.corrida.objectId
            renglon["p1"] =  item.p1
            renglon["p2"] =  item.p2
            renglon["p3"] =  item.p3
            renglon["p4"] =  item.p4
            renglon["p5"] =  item.p5
            renglon["p6"] =  item.p6
            renglon["p7"] =  item.p7
            renglon["p8"] =  item.p8
            renglon["p9"] =  item.p9
            renglon["p10"] =  item.p10
            renglon["p11"] =  item.p11
            renglon["p12"] =  item.p12
            renglon["p13"] =  item.p13
            renglon["p14"] =  item.p14
            renglon["p15"] =  item.p15
            
            renglon["c1"] =  item.corrida.c1
            renglon["c2"] =  item.corrida.c2
            renglon["c3"] =  item.corrida.c3
            renglon["c4"] =  item.corrida.c4
            renglon["c5"] =  item.corrida.c5
            renglon["c6"] =  item.corrida.c6
            renglon["c7"] =  item.corrida.c7
            renglon["c8"] =  item.corrida.c8
            renglon["c9"] =  item.corrida.c9
            renglon["c10"] =  item.corrida.c10
            renglon["c11"] =  item.corrida.c11
            renglon["c12"] =  item.corrida.c12
            renglon["c13"] =  item.corrida.c13
            renglon["c14"] =  item.corrida.c14
            renglon["c15"] =  item.corrida.c15
            
            renglones.append(renglon)
        }
        
        return renglones
    }

    
    func ValidarPedido () -> Bool {
        
        if(self.txtFechaIni.text?.isEmpty)!{
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Capture la fecha Inicio.",
                                 withError: nil)
            return false
        }
        
        
        if(self.txtFechaFin.text?.isEmpty)!{
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Capture la fecha Fin.",
                                 withError: nil)
            return false
        }
        
        
        if(self.txtFechaCancelada.text?.isEmpty)!{
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Capture la fecha de cancelación.",
                                 withError: nil)
            return false
        }
        
        if(self._pedido.cliente == nil){
                Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar un cliente.",
                withError: nil)
            return false
        }
        
        if(self._pedido.embarque == nil){
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar un embarque.",
                                 withError: nil)
            return false
        }

        if(self._pedido.detalle.count <= 0){
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar por lo menos un producto.",
                                 withError: nil)
            return false
        }
        
        if(self.txtCondicionPago.text?.isEmpty)!{
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Capture la condicion de pago.",
                                 withError: nil)
            self.txtCondicionPago.becomeFirstResponder()
            return false
        }

        if(self.txtTipoPedido.text?.isEmpty)!{
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Capture el tipo de pedido.",
                                 withError: nil)
            
            self.txtTipoPedido.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    //Se carga el listado de condiciones de pago
    func CargarListaCondicionesPago() {
        let condicionPagoQuery = CondicionesPagoDatos(_database: _app.database).setupViewAndQuery()
        
        do {
            
            let result  = try condicionPagoQuery.run()
            
            while let doc = result.nextRow()?.document {
                let conPago = CondicionesPago(for: doc)
                self._lstCondicionPago.append(conPago!)
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar lista condiciones de pago.",
                                 withError: nil)
        }
    }
    
    //Se carga la descripcion del tipo de pedido
    func CargarListaTipoPedido () {
        let tipoPedidoQuery = TipoPedidoDatos(_database: _app.database).setupViewAndQuery()
        
        do {
            
            let result  = try tipoPedidoQuery.run()
            
            while let doc = result.nextRow()?.document {
                let pedido = TipoPedido(for: doc)
                self._lstTipoPedidos.append(pedido!)
            }
            
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar lista tipo pedido.",
                                 withError: nil)
        }
    }
    
    //Regresar a companias
    func backController() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func buscarCliente() {
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchClientes") as! ClienteSearchViewController
        
        vc.preferredContentSize = CGSize(width: 500, height: 500)
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: { _ in })
    }
    
    func clienteSeleccionado(sender: Cliente)
    {
        self._pedido.cliente = sender
        self._pedido.idcliente = sender.id as String
        txtCliente.text = sender.id as String
        lblRfc.text = sender.razonsocial as String
        lblCuenta.text = sender.cxcobs as String
        lblCalificacion.text = sender.clasif as String
        
        txtEmbarque.text = ""
        lblEmbarDireccion.text = ""
        self._pedido.embarque = nil
    }
    
    func buscarEmbarque()
    {
        if(self._pedido.cliente != nil) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchEmbarques") as! EmbarqueSearchViewController
        
            vc.preferredContentSize = CGSize(width: 500, height: 500)
        
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc.idCliente = self._pedido.cliente!.id as String
            vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar un Cliente",
                                 withError: nil)
        }
    }
    
    func OcultaDetalle() {
        self.viewDetalle.isHidden = true
        self.btnOcultaDetalle.setTitle("Muestra detalle", for: .normal)
        self.tableView.frame = CGRect(x: 0, y: 180, width: 1024, height: 580)
        self.btnNuevoProd.layer.position.y = 150
        self.lblMsgPares.layer.position.y = 150
        self.lblMsgTotal.layer.position.y = 150
        self.lblTotal.layer.position.y = 150
        self.lblPares.layer.position.y = 150
    }
    
    func MuestraDetalle() {
        self.viewDetalle.isHidden = false
        self.btnOcultaDetalle.setTitle( "Oculta detalle", for: .normal)
        self.tableView.frame = CGRect(x: 0, y: 315, width: 1024, height: 455)
        self.btnNuevoProd.layer.position.y = 285
        self.lblMsgPares.layer.position.y = 285
        self.lblMsgTotal.layer.position.y = 285
        self.lblTotal.layer.position.y = 285
        self.lblPares.layer.position.y = 285
    }
    
    func embarqueSeleccionado(sender: Embarque)
    {
        self._pedido.embarque = sender
        self._pedido.idembarque = sender.embarque as String
        txtEmbarque.text = sender.embarque as String
        lblEmbarDireccion.text = sender.direccion as String
    }
    
    func fechaInicioValueChanged(sender:UIDatePicker) {
        txtFechaIni.text = self._dateFormatter.string(from: sender.date)
    }
    
    func fechaFinValueChanged(sender:UIDatePicker) {
        txtFechaFin.text = self._dateFormatter.string(from: sender.date)
    }
   
    func fechaCancelaValueChanged(sender:UIDatePicker) {
        txtFechaCancelada.text = self._dateFormatter.string(from: sender.date)
    }
    
    //Se agrega a la coleccion el producto
    func PedidoProductoSeleccionado (sender: RowPedidoProducto) {
        var encontroRenglon: Bool = false
        var index: Int = 0
        //Se valida si el pedido ya existe
        for item in self._pedido.detalle {
            
            if(item.renglon == sender.renglon) {
                self._pedido.detalle.remove(at: index)
                self._pedido.detalle.insert(sender,at: index)
                encontroRenglon = true
                break
            }
            index = index + 1
        }
        
        if(!encontroRenglon){
            self._pedido.detalle.append(sender)
        }
        
        self.btnBuscarCliente.isEnabled = (self._pedido.detalle.count < 1)
        self.CalculaTotales()
        self.tableView.reloadData()
    }
    
    func onRptPedido() {
        if(self._pedido.detalle.count > 0) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewRptPedido") as! ReportePedidoViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            self._pedido.fechaFin = self.txtFechaFin.text
            self._pedido.fechaInicio = self.txtFechaIni.text
            self._pedido.fechaCancelacion = self.txtFechaCancelada.text
            
            vc._pedido = self._pedido
            
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "El pedido no tiene producto.",
                                 withError: nil)
        }
    }
    
    func onRptProductos() {
        if(self._pedido.detalle.count > 0) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewRptProducto") as! ReporteProdViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._email = self._pedido.cliente?.email as String!
            vc._folio = self.lblFolio.text
            vc._rowPedidoProductos = self._pedido.detalle
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "El pedido no tiene producto.",
                                 withError: nil)
        }
    }
    
    func onGuardar() {
        if(self.ValidarPedido()){
            if(self._tipo == "Nuevo") {
                _ = self.GuardarNuevoPedido()
                let dataConfig = ConfiguracionDatos()
                
                //Se incrementa el folio
                let nuevoFolio = self._app.config.folio.intValue + 1
                self._app.config.folio = "\(nuevoFolio)" as NSString
                dataConfig.updateConfiguracion(withConfiguracion: self._app.config)
            } else {
                self.ActualizarPedido()
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func ObtenerSiguienteRenglon() -> Int{
        var numRenglon : Int = 1
        
        if self._pedido.detalle.count > 0 {
            let count = self._pedido.detalle.count - 1
            numRenglon = self._pedido.detalle[count].renglon + 1
        }
        
        return numRenglon
    }
    
    @IBAction func onBuscarEmbarque(_ sender: Any) {
        self.buscarEmbarque()
    }
    
    //Popup para buscar cliente
    @IBAction func onBuscarCliente(_ sender: Any) {
        self.buscarCliente()
    }
    
    @IBAction func txtFechaIni(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.fechaInicioValueChanged), for: UIControlEvents.valueChanged)
        
        let dateIni = self._dateFormatter.date(from: self.txtFechaIni.text! as String)
        datePickerView.setDate(dateIni!, animated: true)
    }
    
    @IBAction func ontxtFechaFin(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.fechaFinValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFin = self._dateFormatter.date(from: self.txtFechaFin.text! as String)
        datePickerView.setDate(dateFin!, animated: true)
    }
    
    @IBAction func ontxtFechaCancela(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.fechaCancelaValueChanged), for: UIControlEvents.valueChanged)
        
        let dateCan = self._dateFormatter.date(from: self.txtFechaCancelada.text! as String)
        datePickerView.setDate(dateCan!, animated: true)
    }
    
    @IBAction func onAgregarProducto(_ sender: Any) {
        if(self._pedido.cliente != nil) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbPedidoProducto") as! PedidoProductoViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 440)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._listaPrecios =  self._pedido.cliente?.listaprec as String?
            vc._renglon = self.ObtenerSiguienteRenglon()
            vc._semanas = self._semanas
            vc._estatusProducto = self._pedido?.estatus
            vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar un Cliente",
                                 withError: nil)
        }
    }
    
    @IBAction func onEstatusCambia(_ sender: UISwitch) {
        if sender.isOn {
            self.lblEstatus.text = ESTATUS_PEDIDO_CAPTURADO
        } else {
            self.lblEstatus.text = ESTATUS_PEDIDO_ENVIADO
        }
    }
    
    @IBAction func onDetalle(_ sender: Any) {
        if self.viewDetalle.isHidden {
            self.MuestraDetalle()
        } else {
            self.OcultaDetalle()
        }
    }
}

// MARK: - ScrollView
extension PedidoDetalleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let numPagina = self.scrollView.contentOffset.x / 1024
        
        if numPagina == 0 {
            self.CambiaTamanoVistas(opcion: Int(numPagina))
        }
        
        if numPagina == 1 {
            self.CambiaTamanoVistas(opcion: Int(numPagina))
        }
    }
}

// MARK: - UIPickerView
extension PedidoDetalleViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.pickerTipoPedido {
            return self._lstTipoPedidos.count
        }
        
        if pickerView == self.pickerCondicionPago {
            return self._lstCondicionPago.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerTipoPedido  {
             let doc = self._lstTipoPedidos[row].document!
            return doc["descripcion"] as? String
        }
        
        if pickerView == self.pickerCondicionPago {
            let docPago = self._lstCondicionPago[row].document!
            return docPago["descripcion"] as? String
        }
        
        return " no data "
    }
    
    //Item seleccionado
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerTipoPedido  {
            if self._lstTipoPedidos.count > 0 {
                let doc = self._lstTipoPedidos[row].document!
                self.txtTipoPedido.text = doc["id"] as? String
                self.lblTipoPedido.text = doc["descripcion"] as? String
            }
        }
        
        if pickerView == self.pickerCondicionPago  {
            if self._lstCondicionPago.count > 0 {
                let docPago = self._lstCondicionPago[row].document!
                
                self.lblCondicionPago.text =  docPago["descripcion"] as? String
                self.txtCondicionPago.text =  docPago["id"] as? String
            }
        }
    }
}

// MARK: - UITableViewController
extension PedidoDetalleViewController : UITableViewDelegate, UITableViewDataSource {

    // MARK: Delegates de la Tabla
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._pedido.detalle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celPedidoDetalle", for: indexPath) as! pedidoTableViewCell
        
        let renglon = self._pedido.detalle[indexPath.row]
        
        self.IniciaDatosRenglon(cell: cell, renglon: renglon)
        self.DespliegaCorrida(cell: cell)
        self.FormatoLabel(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self._pedido.detalle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.CalculaTotales()
        }
    }

}
