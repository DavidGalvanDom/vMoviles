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
   // var overlay : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ozono-temporada")!)
        
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
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
       /* let detailViewController = _storyboard?.instantiateViewController(withIdentifier: "sbProductoDetalle")
        
        self.navigationController?.pushViewController(detailViewController!, animated: true)
         */
        
        let app = UIApplication.shared.delegate as! AppDelegate
        app.showProductos()

        
    }
    
    // Pedidos
    func onShowPedidos () {
        let pedidoViewController = _storyboard?.instantiateViewController(withIdentifier: "sbPedidos")
        self.navigationController?.pushViewController(pedidoViewController!, animated: true)
    }
    
    //Splitview de clietnes
    func onShowClientes() {
        
       let app = UIApplication.shared.delegate as! AppDelegate
        app.showClientes()
        
      /*  let detailViewController = _storyboard?.instantiateViewController(withIdentifier: "sbClientesDetalle")
        
        self.navigationController?.pushViewController(detailViewController!, animated: true)
    */
    }
    
    //Regresar a companias
    func backController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
