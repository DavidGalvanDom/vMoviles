//
//  PedidoProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/2/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoProductoViewController: UIViewController, SearchProductoDelegate, PrepackDelegate {

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
    @IBOutlet weak var productoImage: UIImageView!
    
    var _storyboard: UIStoryboard!
    var _productoSelected: Producto!
    var _app: AppDelegate!
    var _corridaSelected: Corrida!
    var _listaPrecios: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        EventosText()
        DespliegaCorrida()
        
        lblRenglon.text = "1"
        _storyboard = storyboard
        self._app = UIApplication.shared.delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            // var erro: NSError?
            let result  = try corridaQuery.run()
            
            let doc = result.nextRow()?.document
            if( doc != nil) {
                self._corridaSelected = Corrida(for: (doc)!)
                
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
        var total : Double = 0
        total =  total + (txtC1.text! as NSString).doubleValue
        total =  total + (txtC2.text! as NSString).doubleValue
        total =  total + (txtC3.text! as NSString).doubleValue
        total =  total + (txtC4.text! as NSString).doubleValue
        total =  total + (txtC5.text! as NSString).doubleValue
        total =  total + (txtC6.text! as NSString).doubleValue
        total =  total + (txtC7.text! as NSString).doubleValue
        total =  total + (txtC8.text! as NSString).doubleValue
        total =  total + (txtC9.text! as NSString).doubleValue
        total =  total + (txtC10.text! as NSString).doubleValue
        total =  total + (txtC11.text! as NSString).doubleValue
        total =  total + (txtC12.text! as NSString).doubleValue
        total =  total + (txtC13.text! as NSString).doubleValue
        total =  total + (txtC14.text! as NSString).doubleValue
        total =  total + (txtC15.text! as NSString).doubleValue
        
        txtPares.text = "\(total)"
    }
    
    //Se recibe el prepack seleccionado de la lista de prepacks
    func prepackSeleccionado(sender: Prepack) {
            NSLog("Prepack")
    }
    
    //Prosucto seleccionado de la lista de productos deletegate
    func productoSeleccionado(sender: Producto, image: UIImage?)
    {
        self._productoSelected = sender
        self.txtClave.text = _productoSelected.clave as String
        self.txtOpcion.text = _productoSelected.opcion as String
        self.txtEstilo.text = _productoSelected.estilo as String
        self.txtPrecio.text = "$ \((_productoSelected.costo).doubleValue)"
        self.txtSemana.text = _productoSelected.semanaprod  as String
        self.txtTs.text = _productoSelected.tiposervicio as String
        self.txtPielColor.text = _productoSelected.descripcion as String
        
        self.txtPrecio.isEnabled = false
        self.txtTs.isEnabled = false
        self.txtPielColor.isEnabled = false
        self.txtPares.isEnabled = false
        
        if(image != nil){
            self.productoImage.image = image
        } else {
            self.productoImage.image = UIImage(named: "noImage")
        }
        
        CargaCorrida()
        
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
        self.present(vc, animated: true, completion: { _ in })
    }
    
    @IBAction func onPrepacks(_ sender: Any) {
        
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbViewSearchPrepacks") as! PrepacksViewController
        
        vc.preferredContentSize = CGSize(width: 950, height: 550)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc._producto = self._productoSelected
        vc._corrida = self._corridaSelected 
        vc.delegate = self
        self.present(vc, animated: true, completion: { _ in })
    }

}
