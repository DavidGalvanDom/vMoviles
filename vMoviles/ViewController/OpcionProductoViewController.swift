//
//  OpcionProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 4/3/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class OpcionProductoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblLinea: UILabel!
    @IBOutlet weak var lblEstilo: UILabel!
    @IBOutlet weak var lblCorrida: UILabel!
    
    @IBOutlet weak var img0: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    let VIEW_SIZE: CGFloat = 990
    
    var _claveProd: String!
    var _listaPrecios: String!
    var _estilo: String!
    var _app: AppDelegate!
    var _lstOpciones: [OpcionEstilo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.FormatoLabel()
        self.CargarOpcionesEstilo()
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: VIEW_SIZE * CGFloat(self._lstOpciones.count), height: 500)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.pageControl.numberOfPages = Int(self._lstOpciones.count)
        
        self.AgregaOpcion()
    }
    
    func AgregaOpcion() {
        for (index,item) in self._lstOpciones.enumerated() {
            CrearVistaOpcion(item: item, index: index)
        }
    }
    
    func CrearVistaOpcion(item: OpcionEstilo, index: Int) {
        if let opcionView = Bundle.main.loadNibNamed("OpcionProductoView", owner: self, options: nil)?.first as? OpcionProductoView {
           
            opcionView.scrollView.minimumZoomScale = 1.0
            opcionView.scrollView.maximumZoomScale = 6.0
            opcionView.lblColor.text = item.color
            opcionView.lblOpcion.text = item.opcion
            opcionView.lblPrecio.text = "$ \(item.precio!)"
            
            opcionView.imageView.image = ProductoDatos(_database: self._app.databaseImg).CargarImagen(clave: item.clave)
            
            self.AsignaImagen(image: opcionView.imageView.image, index:index)
            
            self.scrollView.addSubview(opcionView)
            
            opcionView.frame.size.width = VIEW_SIZE
            opcionView.frame.size.height = 500
            opcionView.frame.origin.x = CGFloat(index) * VIEW_SIZE
        }

    }
    
    func AsignaImagen(image: UIImage?, index:Int) {
        
        switch(index) {
            case 0:
                self.img0.image = image
                self.img0.layer.position.x = 495
            case 1:
                self.img1.image = image
                self.img1.layer.position.x = 495
                self.img0.layer.position.x = 405
            case 2:
                self.img2.image = image
                self.img1.layer.position.x = 405
                self.img0.layer.position.x = 305
            case 3:
                self.img3.image = image
            case 4:
                self.img4.image = image
            default:
                print("No imagen")
        }
    }
    
    //Se carga la descripcion del tipo de pedido
    func CargarOpcionesEstilo () {
        let opcionesQuery = ProductoDatos(_database: _app.database).CargaOpciones()
        opcionesQuery.startKey = [self._listaPrecios, self._estilo]
        opcionesQuery.endKey = [self._listaPrecios, self._estilo]
        
        do {
            
            let result  = try opcionesQuery.run()
            let count = Int(result.count)
            for index in 1...count {
                
                let doc = (result.row(at: UInt(index-1)).document)
                let opcion = OpcionEstilo(opcion: doc?["opcion"] as! String, color: doc?["descripcion"] as! String, precio: Double(doc?["lista"] as! String)!, clave: doc?["clave"] as! String)
                
                self._lstOpciones.append(opcion)
                
                if (self.lblCategoria.text == "--") {
                    self.lblCategoria.text = doc?["categoria"] as? String
                    self.lblLinea.text = doc?["linea"] as? String
                    self.lblEstilo.text = doc?["estilo"] as? String
                    self.CargarDescripcionCorrida(idCorrida: (doc?["corrida"] as? String)!)
                }
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar las opciones",
                                 withError: nil)
        }
    }
    
    func CargarDescripcionCorrida(idCorrida: String ) {
        let corridaQuery = CorridaDatos(_database: _app.database).setupViewAndQuery()
        
        corridaQuery.startKey = idCorrida
        corridaQuery.endKey = idCorrida
        
        do {
            let result  = try corridaQuery.run()
            let doc = result.nextRow()?.document
            if( doc != nil) {
                self.lblCorrida.text = doc?["cvecor"] as? String
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al tratar de cargar la descripcion de la corrida",
                withError: nil)
        }

    }

    func FormatoLabel ()
    {
        lblCategoria.layer.borderWidth = 0.2
        lblCategoria.layer.cornerRadius = 6
        lblLinea.layer.borderWidth = 0.2
        lblLinea.layer.cornerRadius = 6
        lblEstilo.layer.borderWidth = 0.2
        lblEstilo.layer.cornerRadius = 6
        lblCorrida.layer.borderWidth = 0.2
        lblCorrida.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("OpcionProductoViewController -- didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let numPagina = self.scrollView.contentOffset.x / VIEW_SIZE
        self.pageControl.currentPage = Int(numPagina)
        
    }
    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }

}
