//
//  PedidoProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/2/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoProductoViewController: UIViewController, SearchProductoDelegate {

    
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
    var _listaPrecios: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        lblRenglon.text = "1"
        _storyboard = storyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func productoSeleccionado(sender: Producto, image: UIImage?)
    {
        self._productoSelected = sender
        self.txtClave.text = _productoSelected.clave as String
        self.txtOpcion.text = _productoSelected.opcion as String
        self.txtEstilo.text = _productoSelected.estilo as String
        self.txtPrecio.text = _productoSelected.costo as String
        self.txtSemana.text = _productoSelected.semanaprod  as String
        self.txtTs.text = _productoSelected.tiposervicio as String
        self.txtPielColor.text = _productoSelected.descripcion as String
        
        if(image != nil){
            self.productoImage.image = image
        } else {
            self.productoImage.image = UIImage(named: "noImage")
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
        self.present(vc, animated: true, completion: { _ in })
    }
    
    
}
