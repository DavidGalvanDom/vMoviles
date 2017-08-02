//
//  InicialViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/15/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class InicialViewController: UIViewController {
    var _storyboard: UIStoryboard!
    var _app: AppDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self._app = UIApplication.shared.delegate as! AppDelegate
        guard let root = self._app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        self.view.backgroundColor = UIColor(patternImage: self._app.imgTemporada )

        _storyboard = storyboard

        self.splitViewController?.preferredDisplayMode = .primaryHidden
        
        creaNavegador()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        let imageName = String(self._app.database.name) == "vmepi" ? "LogoEpisodio180x180.png" : "logo180x180.png"
        //Logo capa de ozono al centro
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
        let barClientes = UIBarButtonItem(image: UIImage(named:"User2"), style: .done, target: self, action: #selector(onShowClientes))

        let barProductos = UIBarButtonItem(image: UIImage(named:"Zapato2"), style: .plain, target: self, action: #selector(onShowProductos))
        
        let barPedidos =  UIBarButtonItem(image: UIImage(named:"Pedido2"), style: .plain, target: self, action: #selector(onShowPedidos))
        
        
        barClientes.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barClientes.tintColor = .black
        
        barProductos.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barProductos.tintColor = .black
        
        barPedidos.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barPedidos.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barClientes, barProductos,barPedidos]
        
    }
    
       
    //Split view de productos
    func onShowProductos () {
        self._app.showProductos()
    }
    
    // Pedidos
    func onShowPedidos () {
        let pedidoViewController = _storyboard?.instantiateViewController(withIdentifier: "sbPedidos")
        self.navigationController?.pushViewController(pedidoViewController!, animated: true)
    }
    
    //Splitview de clietnes
    func onShowClientes() {
        
       self._app.showClientes()
        
      /* let detailViewController = _storyboard?.instantiateViewController(withIdentifier: "sbClientesDetalle")
         self.navigationController?.pushViewController(detailViewController!, animated: true) */
    }
    
    //Regresar a companias
    func backController() {
        self._app.setInicial = false
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
