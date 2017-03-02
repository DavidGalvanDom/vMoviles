//
//  ClienteDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/18/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ClienteDetalleViewController: UIViewController {

    var pedidoDetalle: PedidoDetalleViewController? = nil
    var _storyboard: UIStoryboard!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCiudad: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var lblPais: UILabel!
    @IBOutlet weak var lblRFC: UILabel!
    @IBOutlet weak var lblApostal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creaNavegador()
        self.configureView()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        _storyboard = storyboard
        
      //  let navVC: UINavigationController = self.splitViewController?.viewControllers[0] as! UINavigationController
        
       // let clienteView = self._storyboard?.instantiateViewController(withIdentifier: "sbClientes") as! ClienteViewController
       
      //  navVC.pushViewController(clienteView, animated: true)

        self.splitViewController?.preferredDisplayMode = .allVisible
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
            
            if let label = self.lblCiudad {
                label.text = detalle.ciudad as String
            }
            
            if let label = self.lblEstado {
                label.text = detalle.estado as String
            }
            
            if let label = self.lblPais {
                label.text = detalle.pais as String
            }
            
            if let label = self.lblRFC {
                label.text = detalle.rfc as String
            }
            
            if let label = self.lblApostal {
                label.text = detalle.apostal as String
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
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        let pedidoDetalle = _storyboard?.instantiateViewController(withIdentifier: "sbPedidoDetalle")
        
        self.navigationController?.pushViewController(pedidoDetalle!, animated: true)

    }
    
    func onShowProductos() {
    
    }
    
}
