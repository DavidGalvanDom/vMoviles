//
//  PedidoProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/2/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoProductoViewController: UIViewController, SearchProductoDelegate, PrepackDelegate,UITextFieldDelegate {

    @IBOutlet weak var txtC1: UITextField!
    @IBOutlet weak var txtC2: UITextField!
    @IBOutlet weak var txtC3: UITextField!
    @IBOutlet weak var txtC4: UITextField!
    @IBOutlet weak var txtC5: UITextField!
    @IBOutlet weak var txtC6: UITextField!
    @IBOutlet weak var txtC7: UITextField!
    @IBOutlet weak var txtC8: UITextField!
    @IBOutlet weak var txtC9: UITextField!
    @IBOutlet weak var txtC10: UITextField!
    @IBOutlet weak var txtC11: UITextField!
    @IBOutlet weak var txtC12: UITextField!
    @IBOutlet weak var txtC13: UITextField!
    @IBOutlet weak var txtC14: UITextField!
    @IBOutlet weak var txtC15: UITextField!
    
    @IBOutlet weak var lblC1: UILabel!
    @IBOutlet weak var lblC2: UILabel!
    @IBOutlet weak var lblC3: UILabel!
    @IBOutlet weak var lblC4: UILabel!
    @IBOutlet weak var lblC5: UILabel!
    @IBOutlet weak var lblC6: UILabel!
    @IBOutlet weak var lblC7: UILabel!
    @IBOutlet weak var lblC8: UILabel!
    @IBOutlet weak var lblC9: UILabel!
    @IBOutlet weak var lblC10: UILabel!
    @IBOutlet weak var lblC11: UILabel!
    @IBOutlet weak var lblC12: UILabel!
    @IBOutlet weak var lblC13: UILabel!
    @IBOutlet weak var lblC14: UILabel!
    @IBOutlet weak var lblC15: UILabel!
    
    @IBOutlet weak var lblRenglon: UILabel!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtInterroga: UITextField!
    @IBOutlet weak var txtPK: UITextField!
    @IBOutlet weak var txtPares: UITextField!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtSemana: UITextField!
    @IBOutlet weak var txtSemanaCli: UITextField!
    @IBOutlet weak var txtPielColor: UITextField!
    @IBOutlet weak var txtTs: UITextField!
    @IBOutlet weak var txtOpcion: UITextField!
    @IBOutlet weak var txtEstilo: UITextField!
    @IBOutlet weak var imagenProd: UIButton!
    @IBOutlet weak var btnGuardar: UIBarButtonItem!
    
    weak var delegate:PedidoProductoDelegate?
    
    var _storyboard: UIStoryboard!
    var _productoSelected: Producto!
    var _app: AppDelegate!
    var _corridaSelected: Corrida!
    var _listaPrecios: String!
    var _estatusProducto: String!
    var _renglon: Int!
    var _rowPedidoProducto: RowPedidoProducto!
    var _semanas: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self._semanas = [:]
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        self.EventosText()
        self.DespliegaCorrida()
        self.FormatoLabel()
        
        lblRenglon.text = String(_renglon)
        _storyboard = storyboard
        self._app = UIApplication.shared.delegate as! AppDelegate
        
        //Definir el Key ENTER
        self.txtClave.delegate = self
        self.txtOpcion.delegate = self
        self.txtEstilo.delegate = self
        
        self.txtClave.becomeFirstResponder()
        
        //Se valida el estatus del pedido
        if(self._estatusProducto != ESTATUS_PEDIDO_CAPTURADO) {
            self.btnGuardar.isEnabled = false
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self._rowPedidoProducto != nil) {
            self.EditaDatos()
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        if self._productoSelected != nil {
            self._productoSelected = nil
        }
        
        if self._rowPedidoProducto != nil {
            self._rowPedidoProducto = nil
        }
        
        if self._semanas != nil {
            self._semanas = nil
        }
        
        if self._corridaSelected != nil {
            self._corridaSelected = nil
        }
        // Dispose of any resources that can be recreated.
    }
    
    func FormatoLabel() {
        
        self.lblC1.layer.borderWidth = 1
        self.lblC1.layer.cornerRadius = 6
        self.lblC2.layer.borderWidth = 1
        self.lblC2.layer.cornerRadius = 6
        self.lblC3.layer.borderWidth = 1
        self.lblC3.layer.cornerRadius = 6
        self.lblC4.layer.borderWidth = 1
        self.lblC4.layer.cornerRadius = 6
        self.lblC5.layer.borderWidth = 1
        self.lblC5.layer.cornerRadius = 6
        self.lblC6.layer.borderWidth = 1
        self.lblC6.layer.cornerRadius = 6
        self.lblC7.layer.borderWidth = 1
        self.lblC7.layer.cornerRadius = 6
        self.lblC8.layer.cornerRadius = 6
        self.lblC8.layer.borderWidth = 1
        self.lblC9.layer.cornerRadius = 6
        self.lblC9.layer.borderWidth = 1
        self.lblC10.layer.cornerRadius = 6
        self.lblC10.layer.borderWidth = 1
        self.lblC11.layer.cornerRadius = 6
        self.lblC11.layer.borderWidth = 1
        self.lblC12.layer.cornerRadius = 6
        self.lblC12.layer.borderWidth = 1
        self.lblC13.layer.cornerRadius = 6
        self.lblC13.layer.borderWidth = 1
        self.lblC14.layer.cornerRadius = 6
        self.lblC14.layer.borderWidth = 1
        self.lblC15.layer.cornerRadius = 6
        self.lblC15.layer.borderWidth = 1
    }
    
    //Eventos para hacer el sumarizado de total de pares
    func EventosText()
    {
        txtC1.addTarget(self, action: #selector(CalculaTotalPares),
                            for: UIControlEvents.editingChanged)
        
        txtC2.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC3.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC4.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC5.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC6.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC7.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC8.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC9.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC10.addTarget(self, action: #selector(CalculaTotalPares),
                        for: UIControlEvents.editingChanged)
        
        txtC11.addTarget(self, action: #selector(CalculaTotalPares),
                         for: UIControlEvents.editingChanged)
        
        txtC12.addTarget(self, action: #selector(CalculaTotalPares),
                         for: UIControlEvents.editingChanged)
        
        txtC13.addTarget(self, action: #selector(CalculaTotalPares),
                         for: UIControlEvents.editingChanged)
        
        txtC14.addTarget(self, action: #selector(CalculaTotalPares),
                         for: UIControlEvents.editingChanged)
        
        txtC15.addTarget(self, action: #selector(CalculaTotalPares),
                         for: UIControlEvents.editingChanged)
    }
    
    ///En base al producto se carga la estructura de la corrida
    func CargaCorrida() {
        let corridaQuery = CorridaDatos(_database: _app.database).setupViewAndQuery()
        
        if( self._productoSelected != nil ) {
            corridaQuery.startKey = self._productoSelected.corrida
            corridaQuery.endKey = self._productoSelected.corrida
        }
        
        do {
            let result  = try corridaQuery.run()
            
            let doc = result.nextRow()?.document
            if( doc != nil) {
                self._corridaSelected = Corrida(for: (doc)!)
                self._corridaSelected.objectId = doc?["_id"] as! String
                
                lblC1.text = doc?["c1"] as? String
                lblC2.text = doc?["c2"] as? String
                lblC3.text = doc?["c3"] as? String
                lblC4.text = doc?["c4"] as? String
                lblC5.text = doc?["c5"] as? String
                lblC6.text = doc?["c6"] as? String
                lblC7.text = doc?["c7"] as? String
                lblC8.text = doc?["c8"] as? String
                lblC9.text = doc?["c9"] as? String
                lblC10.text = doc?["c10"] as? String
                lblC11.text = doc?["c11"] as? String
                lblC12.text = doc?["c12"] as? String
                lblC13.text = doc?["c13"] as? String
                lblC14.text = doc?["c14"] as? String
                lblC15.text = doc?["c15"] as? String
                
                DespliegaCorrida()
                
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al tratar de cargar las corridas\(self._productoSelected.corrida) del producto",
                                 withError: nil)
        }
    }
    
    func DespliegaCorrida () {
       
        lblC1.isHidden = !(lblC1.text != "0")
        txtC1.isHidden = !(lblC1.text != "0")
        
        lblC2.isHidden = !(lblC2.text != "0")
        txtC2.isHidden = !(lblC2.text != "0")
        
        lblC3.isHidden = !(lblC3.text != "0")
        txtC3.isHidden = !(lblC3.text != "0")

        lblC4.isHidden = !(lblC4.text != "0")
        txtC4.isHidden = !(lblC4.text != "0")

        lblC5.isHidden = !(lblC5.text != "0")
        txtC5.isHidden = !(lblC5.text != "0")

        lblC6.isHidden = !(lblC6.text != "0")
        txtC6.isHidden = !(lblC6.text != "0")

        lblC7.isHidden = !(lblC7.text != "0")
        txtC7.isHidden = !(lblC7.text != "0")

        lblC8.isHidden = !(lblC8.text != "0")
        txtC8.isHidden = !(lblC8.text != "0")
        
        lblC9.isHidden = !(lblC9.text != "0")
        txtC9.isHidden = !(lblC9.text != "0")
        
        lblC10.isHidden = !(lblC10.text != "0")
        txtC10.isHidden = !(lblC10.text != "0")
        
        lblC11.isHidden = !(lblC11.text != "0")
        txtC11.isHidden = !(lblC11.text != "0")
        
        lblC12.isHidden = !(lblC12.text != "0")
        txtC12.isHidden = !(lblC12.text != "0")
       
        lblC13.isHidden = !(lblC13.text != "0")
        txtC13.isHidden = !(lblC13.text != "0")
       
        lblC14.isHidden = !(lblC14.text != "0")
        txtC14.isHidden = !(lblC14.text != "0")
       
        lblC15.isHidden = !(lblC15.text != "0")
        txtC15.isHidden = !(lblC15.text != "0")
       
    }
    
    func CalculaTotalPares()
    {
        var total : Int = 0
        var numPck : Int = 0
        
        total =  total + (txtC1.text! as NSString).integerValue
        total =  total + (txtC2.text! as NSString).integerValue
        total =  total + (txtC3.text! as NSString).integerValue
        total =  total + (txtC4.text! as NSString).integerValue
        total =  total + (txtC5.text! as NSString).integerValue
        total =  total + (txtC6.text! as NSString).integerValue
        total =  total + (txtC7.text! as NSString).integerValue
        total =  total + (txtC8.text! as NSString).integerValue
        total =  total + (txtC9.text! as NSString).integerValue
        total =  total + (txtC10.text! as NSString).integerValue
        total =  total + (txtC11.text! as NSString).integerValue
        total =  total + (txtC12.text! as NSString).integerValue
        total =  total + (txtC13.text! as NSString).integerValue
        total =  total + (txtC14.text! as NSString).integerValue
        total =  total + (txtC15.text! as NSString).integerValue
       
        if(self.txtPK.text != "99" && !((self.txtPK.text?.isEmpty)!)) {
            numPck = (txtInterroga.text! as NSString).integerValue
            total = total * numPck
        }
        
        txtPares.text = "\(total)"
    }
    
    //Se recibe el prepack seleccionado de la lista de prepacks
    func prepackSeleccionado(sender: PrepackInventario) {
        self.txtC1.text = sender.p1 as String
        self.txtC2.text = sender.p2 as String
        self.txtC3.text = sender.p3 as String
        self.txtC4.text = sender.p4 as String
        self.txtC5.text = sender.p5 as String
        self.txtC6.text = sender.p6 as String
        self.txtC7.text = sender.p7 as String
        self.txtC8.text = sender.p8 as String
        self.txtC9.text = sender.p9 as String
        self.txtC10.text = sender.p10 as String
        self.txtC11.text = sender.p11 as String
        self.txtC12.text = sender.p12 as String
        self.txtC13.text = sender.p13 as String
        self.txtC14.text = sender.p14 as String
        self.txtC15.text = sender.p15 as String
        
        self.txtPK.text = sender.pck as String
        if(self.txtPK.text == "99"){
            self.txtInterroga.text = "1"
            self.txtInterroga.isEnabled = false
        } else {
            self.txtInterroga.text = "1"
            self.txtInterroga.isEnabled = true
        }
        
        CalculaTotalPares()
        
    }
    
    //Producto seleccionado de la lista de productos deletegate
    func productoSeleccionado(sender: Producto, image: UIImage?)
    {
        self._productoSelected = sender
        self.txtClave.text = _productoSelected.clave as String
        self.txtOpcion.text = _productoSelected.opcion as String
        self.txtEstilo.text = _productoSelected.estilo as String
        self.txtPrecio.text = "$ \((_productoSelected.lista).doubleValue)"
        self.txtTs.text = _productoSelected.tiposervicio as String
        self.txtPielColor.text = _productoSelected.descripcion as String
        
        self.txtPrecio.isEnabled = false
        self.txtTs.isEnabled = false
        self.txtPielColor.isEnabled = false
        self.txtPares.isEnabled = false
        
        let imgProd = ProductoDatos(_database: self._app.databaseImg).CargarImagen(clave: sender.clave as String)
        self.imagenProd.setImage(imgProd, for: .normal)
        
        self.imagenProd.imageView?.contentMode = .scaleAspectFit
        self.imagenProd.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.imagenProd.layer.cornerRadius = 16
        self.imagenProd.layer.masksToBounds = true
        self.imagenProd.isUserInteractionEnabled = true
        self.imagenProd.layer.backgroundColor = UIColor.white.cgColor
        
        self.SeleccionaSemana()
        self.IniciaPrepack()
        self.CargaCorrida()
    }
    
    func IniciaPrepack () {
        self.txtPK.text = "99"
        self.txtPares.text = "0"
        self.txtInterroga.text = "1"
        self.txtC1.text = "0"
        self.txtC2.text = "0"
        self.txtC3.text = "0"
        self.txtC4.text = "0"
        self.txtC5.text = "0"
        self.txtC6.text = "0"
        self.txtC7.text = "0"
        self.txtC8.text = "0"
        self.txtC9.text = "0"
        self.txtC10.text = "0"
        self.txtC11.text = "0"
        self.txtC12.text = "0"
        self.txtC13.text = "0"
        self.txtC14.text = "0"
        self.txtC15.text = "0"
    }
    
    func SeleccionaSemana() {
        switch(self.txtTs.text!) {
        case "E":
            self.txtSemana.text = self._semanas["semanae"]  as? String
        case "S":
            self.txtSemana.text = self._semanas["semanas"]  as? String
        case "R":
            self.txtSemana.text = self._semanas["semanar"]  as? String
        default:
            self.txtSemana.text = _productoSelected.semanaprod as String
        }
    }
    
    //Se valida que la informacion del producto este completa
    func ValidaInformacion () -> Bool {
        
        if(self._productoSelected == nil)
        {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar un producto",
                withError: nil)
            return false
        }
        
        if(  self.txtPK.text == "") {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar un Prepack PK",
                                 withError: nil)
            return false
        }
        
        if( self.txtPares.text?.isEmpty == true) {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "El numero de pares debe ser mayor a cero.",
                                 withError: nil)
            return false
        }
        
        if( Int(self.txtPares.text ?? "0")! <= 0) {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "El número de pares debe ser mayor a cero.",
                                 withError: nil)
            return false
        }
        
        if( self.txtSemana.text?.isEmpty == true) {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "La semana no puede ir vacia.",
                                 withError: nil)
            self.txtSemana.becomeFirstResponder()
            return false
        } else {
            if self.txtSemana.text?.characters.count != 6 {
                Ui.showMessageDialog(onController: self,
                                     withTitle: "Información",
                                     withMessage: "El dato de la semana es erroneo, deben ser 6 números.",
                                     withError: nil)
                
                self.txtSemana.becomeFirstResponder()
                return false
            }
            
            if Int( self.txtSemana.text ?? " ") == nil {
                Ui.showMessageDialog(onController: self,
                                     withTitle: "Información",
                                     withMessage: "El dato de la semana es erroneo, deben ser númerico.",
                                     withError: nil)
                self.txtSemana.becomeFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    //Carga el renglon seleccionado del pedido
    func EditaDatos() {
        
        self.txtPrecio.isEnabled = false
        self.txtTs.isEnabled = false
        self.txtPielColor.isEnabled = false
        self.txtPares.isEnabled = false
        
        if  BuscarProducto(claveProd: self._rowPedidoProducto.cveart, tpc: self._listaPrecios!) {
            CargaCorrida()
            
            self.txtSemana.text = self._rowPedidoProducto.semana
            self.txtSemanaCli.text = self._rowPedidoProducto.semanaCliente
            self.txtPares.text = String(self._rowPedidoProducto.pares)
            self.txtPK.text = self._rowPedidoProducto.pck
            self.txtInterroga.text = String(self._rowPedidoProducto.numPck)
            
            self.txtC1.text = self._rowPedidoProducto.p1
            self.txtC2.text = self._rowPedidoProducto.p2
            self.txtC3.text = self._rowPedidoProducto.p3
            self.txtC4.text = self._rowPedidoProducto.p4
            self.txtC5.text = self._rowPedidoProducto.p5
            self.txtC6.text = self._rowPedidoProducto.p6
            self.txtC7.text = self._rowPedidoProducto.p7
            self.txtC8.text = self._rowPedidoProducto.p8
            self.txtC9.text = self._rowPedidoProducto.p9
            self.txtC10.text = self._rowPedidoProducto.p10
            self.txtC11.text = self._rowPedidoProducto.p11
            self.txtC12.text = self._rowPedidoProducto.p12
            self.txtC13.text = self._rowPedidoProducto.p13
            self.txtC14.text = self._rowPedidoProducto.p14
            self.txtC15.text = self._rowPedidoProducto.p15
        }
        
    }
    
    func BuscarPorEstilo(estilo: String) {
        var claveProd: String = ""
        
        claveProd = estilo
        claveProd = claveProd.leftPadding(toLength: 10, withPad: "0")
        claveProd = claveProd + self.txtOpcion.text!.leftPadding(toLength: 2, withPad: "0")
        
        if self.BuscarProducto(claveProd: claveProd, tpc: self._listaPrecios) {
            self.SeleccionaSemana()
            self.IniciaPrepack()
            self.CargaCorrida()
        }
    }
    
    func BuscarPorOpcion(opcion:String) {
        var claveProd: String = ""
        
        claveProd = self.txtEstilo.text!
        claveProd = claveProd.leftPadding(toLength: 10, withPad: "0")
        claveProd = claveProd + opcion.leftPadding(toLength: 2, withPad: "0")
        
        if self.BuscarProducto(claveProd: claveProd, tpc: self._listaPrecios) {
            self.SeleccionaSemana()
            self.IniciaPrepack()
            self.CargaCorrida()
        }
    }
    
    //Se carga toda la informacion del producto y se despliega la imagen
    // tpc = Lista de precios del cliente 
    func BuscarProducto(claveProd: String, tpc: String) -> Bool{
        let idProd = "prod-\(claveProd)-\(tpc)"
        if let doc = ProductoDatos(_database: self._app.database).CargarProducto(clave: idProd) {
        
            let producto = Producto(for: (doc))
            self._productoSelected = producto
            self.txtClave.text = self._productoSelected.clave as String
            self.txtPielColor.text = self._productoSelected.descripcion as String
            self.txtOpcion.text = self._productoSelected.opcion as String
            self.txtEstilo.text = self._productoSelected.estilo as String
            self.txtPrecio.text = "$ \((_productoSelected.lista).doubleValue)"
            self.txtTs.text = _productoSelected.tiposervicio as String
            
            //Se carga la imagen el producto y se despliega en la interfaz
            
            let imgProd = ProductoDatos(_database: self._app.databaseImg).CargarImagen(clave: claveProd)
            self.imagenProd.setImage(imgProd, for: .normal)
            
            
            //Expande la imagen al tamaño del boton
            self.imagenProd.imageView?.contentMode = .scaleAspectFit
            self.imagenProd.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            self.imagenProd.layer.cornerRadius = 16
            self.imagenProd.layer.masksToBounds = true
            self.imagenProd.isUserInteractionEnabled = true
            
            self.imagenProd.layer.backgroundColor = UIColor.white.cgColor
            
            self.txtClave.selectedTextRange = self.txtClave.textRange(from: self.txtClave.beginningOfDocument, to: self.txtClave.endOfDocument)
            
            return true
            
        } else {
            
            self._productoSelected = nil
            self.imagenProd.setImage(UIImage(named: "noImage"), for: .normal)
            self.txtPielColor.text = ""
            self.txtPrecio.text = "0"
            self.txtTs.text = ""
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "No se encontro el producto Calve:\(claveProd)",
                                 withError: nil)
            return false
        }
    }
    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func onProducto(_ sender: Any) {
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchProductos") as! ProductoSearchViewController
        
        vc.preferredContentSize = CGSize(width: 550, height: 600)
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc._listaPrecios = self._listaPrecios
        vc.delegate = self
        vc.initSearch = self.txtClave.text
        self.present(vc, animated: true, completion: { _ in })
    }
    
    @IBAction func onPrepacks(_ sender: Any) {
        
        if( self._productoSelected != nil) {
        
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchPrepacks") as! PrepacksViewController
        
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._producto = self._productoSelected
            vc._corrida = self._corridaSelected
            vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Información",
                                 withMessage: "Debe seleccionar un producto.",
                withError: nil)

        }
    }
    
    @IBAction func txtInterroga(_ sender: Any) {
        if(self.txtInterroga.text?.isEmpty != true &&
           self.txtPK.text?.isEmpty != true){
            CalculaTotalPares()
        }
    }
    
    //Click imagen producto para desplegar las diferentes opciones
    @IBAction func onClickImgProd(_ sender: Any) {
        
        if self._productoSelected != nil {
            
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbOpcionProducto") as! OpcionProductoViewController
            
            vc._claveProd = self._productoSelected.clave as String
            vc._estilo = self._productoSelected.estilo as String
            vc._listaPrecios  = self._listaPrecios
            vc._app = self._app
            vc.preferredContentSize = CGSize(width: 990, height: 690)
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            //vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
        }
    }
    
    //Evento para guardar el nuvo producto
    @IBAction func onGuardar(_ sender: Any) {
        if(ValidaInformacion()){
            
            self.CalculaTotalPares()
            
            let pedidoProducto = RowPedidoProducto(renglon: self._renglon, cveart:self.txtClave.text!, img: self.imagenProd.currentImage!, pielcolor: self.txtPielColor.text!, tpc: String(self._productoSelected.tpc), corrida: self._corridaSelected)
            
            pedidoProducto.semana = self.txtSemana.text!
            pedidoProducto.semanaCliente = self.txtSemanaCli.text!
            pedidoProducto.precio = (_productoSelected.costo).doubleValue
            pedidoProducto.precioCalle = (_productoSelected.precioca).doubleValue
            pedidoProducto.precioCCom = (_productoSelected.preciocc).doubleValue
            pedidoProducto.pares = Int(self.txtPares.text!)!
            pedidoProducto.pck = self.txtPK.text!
            pedidoProducto.numPck = Int(self.txtInterroga.text!)!
            pedidoProducto.ts = self._productoSelected.tiposervicio as String
            pedidoProducto.opcion = self._productoSelected.opcion as String
            pedidoProducto.estilo = self._productoSelected.estilo as String
            pedidoProducto.linea = self._productoSelected.linea as String
            
            pedidoProducto.p1 = self.txtC1.text!
            pedidoProducto.p2 = self.txtC2.text!
            pedidoProducto.p3 = self.txtC3.text!
            pedidoProducto.p4 = self.txtC4.text!
            pedidoProducto.p5 = self.txtC5.text!
            pedidoProducto.p6 = self.txtC6.text!
            pedidoProducto.p7 = self.txtC7.text!
            pedidoProducto.p8 = self.txtC8.text!
            pedidoProducto.p9 = self.txtC9.text!
            pedidoProducto.p10 = self.txtC10.text!
            pedidoProducto.p11 = self.txtC11.text!
            pedidoProducto.p12 = self.txtC12.text!
            pedidoProducto.p13 = self.txtC13.text!
            pedidoProducto.p14 = self.txtC14.text!
            pedidoProducto.p15 = self.txtC15.text!
            
            delegate?.PedidoProductoSeleccionado(sender: pedidoProducto)
            
            dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)

        }
    }
    
    //Delegate del input clave, opcion
    //Se captura el ENTER
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == self.txtClave) {
            if (self.txtClave.text?.characters.count)! > 7 {
                if self.BuscarProducto(claveProd: self.txtClave.text! as String,tpc: self._listaPrecios) {
                    self.SeleccionaSemana()
                    self.IniciaPrepack()
                    self.CargaCorrida()
                }
            }
            textField.resignFirstResponder()
        } else {
            if(textField == self.txtEstilo) {
                self.BuscarPorEstilo(estilo: self.txtEstilo.text ?? "0")
            } else {
                self.BuscarPorOpcion(opcion: self.txtOpcion.text ?? "0")
            }
        }
        
        return true
    }


}
