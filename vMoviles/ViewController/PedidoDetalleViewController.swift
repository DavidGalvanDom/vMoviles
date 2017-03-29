//
//  PedidoDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoDetalleViewController: UIViewController, SearchClienteDelegate, SearchEmbarqueDelegate, PedidoProductoDelegate, UITableViewDelegate, UITableViewDataSource {
   
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
    
    var _storyboard: UIStoryboard!
    var _dateFormatter = DateFormatter()
    var _semanas: Dictionary<String, Any> = [:]
    var _app: AppDelegate!
    var _pedido: Pedido!

    override func viewDidLoad() {
        super.viewDidLoad()
        self._dateFormatter.dateFormat = "dd/MM/yyyy"
        self.creaNavegador()
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        guard let root = self._app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        self._storyboard = storyboard
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if(self._pedido == nil) {
            self.lblFolio.text = self._app.config.folio as String
            self.AsignarFechas()
            self.CrearLinea()
            self.CargarSemanas()
            
            self._pedido = Pedido(folio: self.lblFolio.text!)
            self._pedido.fechaCreacion = self._dateFormatter.string(from: Date())
        }
    }
    
    func CrearLinea()
    {
        let lineView = UIView(frame: CGRect(x:275,y:170,width:730, height:1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
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
        
        let brGuardar = UIBarButtonItem(image: UIImage(named:"Save"), style: .plain, target: self, action: #selector(onGuardar))
        
        let brRptProductos = UIBarButtonItem(image: UIImage(named:"rptProducto"), style: .plain, target: self, action: #selector(onRptProductos))
        
        let brRptPedido = UIBarButtonItem(image: UIImage(named:"PDF"), style: .plain, target: self, action: #selector(onRptPedido))
        
        brGuardar.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        brGuardar.tintColor = .black
        
        brRptProductos.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        brRptProductos.tintColor = .black
        
        brRptPedido.imageInsets = UIEdgeInsetsMake(5, 2, 5, 2)
        brRptPedido.tintColor = .black
        
         self.navigationItem.rightBarButtonItems = [brRptPedido,brRptProductos,brGuardar]
    }
    
    func DespliegaCorrida (cell: PedidoTableViewCell) {
        
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

    func IniciaDatosRenglon(cell: PedidoTableViewCell, renglon: RowPedidoProducto)
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
                
                vc.preferredContentSize = CGSize(width: 950, height: 550)
                vc.modalPresentationStyle = .formSheet
                vc.modalTransitionStyle = .crossDissolve
                vc._listaPrecios = self._pedido.cliente?.listaprec as! String
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
    
    // MARK: Delegates de la Tabla
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._pedido.detalle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celPedidoDetalle", for: indexPath) as! PedidoTableViewCell
        
        let renglon = self._pedido.detalle[indexPath.row]
        
        self.IniciaDatosRenglon(cell: cell, renglon: renglon)
        self.DespliegaCorrida(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let app = UIApplication.shared.delegate as! AppDelegate
        app.cveCompania = _companias[indexPath.row]._id
        app.compania = _companias[indexPath.row]._descripcion
         */
    }
    
    func CalculaTotales()
    {
        var total: Double = 0
        var pares: Int = 0
        
        for item in self._pedido.detalle {
            pares = pares + item.pares
            total = total + (Double(pares) * item.precio)
        }
        
        self.lblTotal.text = self._app.formatCurrency("\(total)")
        self.lblPares.text = String(pares)
    }
    
    func GuardarPedido() -> CBLSavedRevision?{
        
        var renglones : [Dictionary<String, Any>] = []
        
        for item in self._pedido.detalle {
            
            var renglon: Dictionary<String, Any> = [
                "renglon": String(item.renglon)
            ]
            renglon["status"] = "activo"
            renglon["semana"] = item.semana
            renglon["semanaCli"] = item.semanaCliente
            renglon["cveart"] =  item.cveart
            renglon["opcion"] = item.opcion
            renglon["estilo"] =  item.estilo
            renglon["pares"] =  item.pares
            renglon["precio"] = item.precio
            renglon["pielcolor"] =  item.pielcolor
            renglon["ts"] =  item.ts
            renglon["pck"] =  item.pck
            renglon["tpc"] =  item.tpc
            renglon["numPck"] =  item.numPck
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
            
            renglones.append(renglon)
        }
        
        var properties: Dictionary<String, Any> = [
            "type": "pedido"
        ]
            properties["folio"] = self._app.config.folio
            properties["cliente"] = self._pedido.cliente?.agenteid
            properties["embarque"] = self._pedido.embarque?.embarque
            properties["fechainicio"] = self.txtFechaIni.text ?? ""
            properties["fechafin"] = self.txtFechaFin.text ?? ""
            properties["fechacancelacion"] = self.txtFechaCancelada.text ?? ""
            properties["total"] = self.lblTotal.text ?? "0"
            properties["pares"] = self.lblPares.text ?? "0"
            properties["vendedor"] = self._app.config.agente
            properties["estatus"] = "Capturado"
            properties["fechaCreacion"] = CBLJSON.jsonObject(with: Date())
            properties["renglones"] =  renglones
            properties["observacion"] =  ""
           
        let doc = self._app.database.createDocument()
        
        do {
            return try doc.putProperties(properties)
        } catch let error as NSError {
            Ui.showMessageDialog(onController: self, withTitle: "Error",
                                 withMessage: "No se puede guardar el pedido", withError: error)
            return nil
        }
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
                                 withMessage: "Capture la fecha de cancelacioón.",
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
        
        return true
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
            vc.idCliente = self._pedido.cliente!.agenteid as String
            vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar un Cliente",
                                 withError: nil)
        }
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
            _ = self.GuardarPedido()
            let dataConfig = ConfiguracionDatos()
            let nuevoFolio = self._app.config.folio.intValue + 1
            self._app.config.folio = "\(nuevoFolio)" as NSString
            dataConfig.updateConfiguracion(withConfiguracion: self._app.config)
            
            _ = self.navigationController?.popViewController(animated: true)
        
            /*let inicialViewController = _storyboard?.instantiateViewController(withIdentifier: "sbInicial")
            self.navigationController?.pushViewController(inicialViewController!, animated: true)*/
        }
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
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._listaPrecios = self._pedido.cliente?.listaprec as! String
            vc._renglon = self._pedido.detalle.count + 1
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
