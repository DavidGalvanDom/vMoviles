//
//  PedidoDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoDetalleViewController: UIViewController, SearchClienteDelegate, SearchEmbarqueDelegate {
    
    var clienteSeleccionado: Cliente!
    var embarqueSeleccionado: Embarque!
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
    
    var _storyboard: UIStoryboard!
    var _dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._dateFormatter.dateFormat = "dd/MM/yyyy"
        self.creaNavegador()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        _storyboard = storyboard
        
        lblFolio.text = app.config.folio as String
        self.AsignarFechas()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let barClientes = UIBarButtonItem(image: UIImage(named:"User2"), style: .plain, target: self, action: #selector(onClientes))
        
        let barProducto =  UIBarButtonItem(image: UIImage(named:"Zapato2"), style: .plain, target: self, action: #selector(onShowProductos))
        
        barClientes.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barClientes.tintColor = .black
        
        barProducto.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barProducto.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barClientes,barProducto]
        
    }
    
    //Regresar a companias
    func backController() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    func onShowProductos ()
    {
        
    }
    
    func onClientes ()
    {
        
    }
    
    @IBAction func onTabChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Ui.showTextInputDialog(
                onController: self,
                withTitle: "Cliente",
                withMessage:  nil,
                withTextFieldConfig: { textField in
                    textField.placeholder = "List name"
                    textField.text = "name"
                    textField.autocapitalizationType = .words
            },
                onOk: { (name) -> Void in
                    NSLog("Ok button")
                    //self.updateTaskList(list: doc, withName: name)
            }
            )
        case 1:
            buscarCliente()
        case 2:
            NSLog("Opcion 2")
        default:
            break
        }
    
    }
    
    func buscarCliente() {
        
        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchClientes") as! ClienteSearchViewController
        
        vc.preferredContentSize = CGSize(width: 500, height: 500)
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: { _ in })
    }
    
    func clienteSeleccionado(sender: Cliente)
    {
        self.clienteSeleccionado = sender
        txtCliente.text = sender.id as String
        lblRfc.text = sender.razonsocial as String
        lblCuenta.text = sender.cxcobs as String
        lblCalificacion.text = sender.clasif as String
        
        txtEmbarque.text = ""
        lblEmbarDireccion.text = ""
        self.embarqueSeleccionado = nil
    }
    
    func buscarEmbarque()
    {
        if(clienteSeleccionado != nil) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchEmbarques") as! EmbarqueSearchViewController
        
            vc.preferredContentSize = CGSize(width: 500, height: 500)
        
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc.idCliente = clienteSeleccionado!.agenteid as String
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
        embarqueSeleccionado = sender
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
        if(clienteSeleccionado != nil) {
            let vc = _storyboard.instantiateViewController(withIdentifier: "sbPedidoProducto") as! PedidoProductoViewController
            
            vc.preferredContentSize = CGSize(width: 950, height: 550)
            
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc._listaPrecios = clienteSeleccionado.listaprec as String
            //vc.delegate = self
            self.present(vc, animated: true, completion: { _ in })
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: "Debe seleccionar un Cliente",
                                 withError: nil)
        }

    }
    

}
