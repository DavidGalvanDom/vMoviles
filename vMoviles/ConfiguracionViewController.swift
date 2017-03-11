//
//  ConfiguracionViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/3/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ConfiguracionViewController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtIdAgente: UITextField!
    @IBOutlet weak var txtFolio: UITextField!
    @IBOutlet weak var txtZona: UITextField!
    @IBOutlet weak var txtLineaVenta: UITextField!
    @IBOutlet weak var txtUrlSync: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        self.txtNombre.text = app.config!.nombreVendedor as String
        self.txtIdAgente.text = app.config!.agente as String
        self.txtFolio.text = app.config!.folio as String
        self.txtZona.text = app.config!.zona as String
        self.txtLineaVenta.text = app.config!.lineaVenta as String
        self.txtUrlSync.text = app.config!.urlSync as String
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validaInformacion () -> String {
        var mensaje: String = ""
        if(self.txtNombre.text == "") {
            mensaje = "El nombre no puede ir vacio"
        }
        
        if(self.txtIdAgente.text == "") {
            mensaje = "El idAgente no puede ir vacio"
        }
        
        if(self.txtFolio.text == "") {
            mensaje = "El Folio no puede ir vacio"
        }
        
        if(self.txtZona.text == "") {
            mensaje = "La Zona no puede ir vacia"
        }
        
        if(self.txtLineaVenta.text == "") {
            mensaje = "La Linea de venta no puede ir vacia"
        }
        
        if(self.txtUrlSync.text == "") {
            mensaje = "La url de sincronizacion no puede ir vacia"
        }
        
        return mensaje
        
    }
    
    func cerrarVentana ()
    {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    //Se valida y guarda la informacion
    @IBAction func onGuardar(_ sender: Any) {
        let mensaje  =  validaInformacion ()
        
        if(mensaje == "") {
            //Test for update information
            let dataConfig = ConfiguracionDatos()
            let app = UIApplication.shared.delegate as! AppDelegate
        
            app.config!.nombreVendedor = self.txtNombre.text! as NSString
            app.config!.agente = self.txtIdAgente.text! as NSString
            app.config!.folio = self.txtFolio.text! as NSString
            app.config!.zona = self.txtZona.text! as NSString
            app.config!.lineaVenta = self.txtLineaVenta.text! as NSString
            app.config!.urlSync = self.txtUrlSync.text! as NSString
            
            dataConfig.updateConfiguracion(withConfiguracion: app.config)
            
            cerrarVentana()
            
        } else {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Informacion",
                                 withMessage: mensaje,
                                 withError: nil)
        }
        
    }
    
    
    @IBAction func onCancelar(_ sender: Any) {
        cerrarVentana()
    }
    
}
