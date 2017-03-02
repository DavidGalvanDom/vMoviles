//
//  ProductoDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoDetalleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creaNavegador()
        // Do any additional setup after loading the view.
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
        
        
        //Toolbar Derecho
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(onShowCompanias))
        
        let barClientes = UIBarButtonItem(image: UIImage(named:"User2"), style: .plain, target: self, action: #selector(onClientes))
        
        let barPedidos =  UIBarButtonItem(image: UIImage(named:"Pedido2"), style: .plain, target: self, action: #selector(onShowPedidos))
        
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        barClientes.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barClientes.tintColor = .black
        
        barPedidos.imageInsets = UIEdgeInsetsMake(9, 2, 9, 2)
        barPedidos.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barCompania, barClientes,barPedidos]
        
    }
    
    func onShowCompanias ()
    {
        
    }

    func onShowPedidos ()
    {
    
    }
    
    func onClientes ()
    {
        
    }
}
