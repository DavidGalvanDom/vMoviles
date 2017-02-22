//
//  ClienteDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/18/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ClienteDetalleViewController: UIViewController {

    @IBOutlet weak var lblNombre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creaNavegador()
        self.configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        // Se actualizan los datos de la interfaz
        if let detalle = detalleCliente {
            if let label = self.lblNombre {
                label.text = detalle.razonsocial as String
            }
        }
    }
    
    var detalleCliente: Cliente? {
        didSet {
            // Update the view.
            self.configureView()
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
        
        
        //Toolbar Derecho
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(onShowCompanias))
        
        let barProductos = UIBarButtonItem(image: UIImage(named:"Zapato2"), style: .plain, target: self, action: #selector(onShowProductos))
        
        let barPedidos =  UIBarButtonItem(image: UIImage(named:"Pedido2"), style: .plain, target: self, action: #selector(onShowPedidos))
        
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        barProductos.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barProductos.tintColor = .black
        
        barPedidos.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barPedidos.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barCompania, barProductos,barPedidos]
        
    }

    func onShowCompanias() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.showCompanias()
    }
    
    func onShowPedidos() {
        
    }
    
    func onShowProductos() {
    
    }
    
}
