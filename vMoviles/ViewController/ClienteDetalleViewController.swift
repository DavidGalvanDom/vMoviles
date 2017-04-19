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
    var _app: AppDelegate!
    
    var _lstInformacion: Dictionary<String, Any> = [:]
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRFC: UILabel!
    @IBOutlet weak var lblIdClient: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creaNavegador()
        self.configureView()
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        guard let root = self._app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        self._storyboard = storyboard
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.FormatoIdCliente()
        self.splitViewController?.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FormatoIdCliente() {
        lblIdClient.layer.masksToBounds = true
        lblIdClient.layer.borderWidth = 4.0
        lblIdClient.layer.borderColor = UIColor.white.cgColor
        lblIdClient.backgroundColor = UIColor.lightGray
        lblIdClient.layer.cornerRadius = 10
        lblIdClient.textColor  = UIColor(colorLiteralRed: 249, green: 249, blue: 249, alpha: 1)
    }
    
    
    func configureView() {
        // Se actualizan los datos de la interfaz
        if let detalle = detalleCliente {
            
            if let label = self.lblNombre {
                label.text = detalle.razonsocial as String
            }
            
            if let label = self.lblRFC {
                label.text = detalle.rfc as String
            }
            
            if let label = self.lblIdClient {
                label.text = detalle.id as String
            }
            
            self._lstInformacion = [
                "comprador" : detalle.comprador,
                "pagador" : detalle.pagador,
                "reembolso": detalle.reemb,
                "agenteid": detalle.agenteid,
                "lista de precios": detalle.listaprec,
                "nombre contacto": detalle.nombreco,
                "fecha registro": detalle.fhreg,
                "cadena": detalle.cadena,
                "sucursal": detalle.sucursal,
                "codigo postal": detalle.cpostal,
                "apartado postal": detalle.apostal,
                "tel1": detalle.tel1,
                "fax": detalle.fax,
                "dir": detalle.dir,
                "ciudad": detalle.ciudad,
                "estado": detalle.estado,
                "pais": detalle.pais,
                "email": detalle.email,
                "clasificacion": detalle.clasif,
                "consignacion": detalle.consig,
                "flete": detalle.flete,
                "estatus venta": detalle.statusvta,
                "fecha alta": detalle.fechaalta,
                "fecha baja": detalle.fechabaja,
                "condiciones": detalle.condiciones,
                "contrato": detalle.contrato,
                "aseguradora": detalle.aseguradora,
                "poliza": detalle.poliza,
                "observaciones": detalle.obs,
                "zona": detalle.zona,
                "descuenta": detalle.descto,
                "plazo": detalle.plazo,
                "banco": detalle.banco,
                "fecha pago": detalle.fechapago,
                "referencia bancaria": detalle.refbancaria,
                "caja":  detalle.caja,
                "foliado": detalle.foliado,
                "limite de credito": detalle.limitecredito,
                "zventa": detalle.zventa
            ]
            
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
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [barCompania]
        
    }

    func onShowCompanias() {
        self._app.showInicial()
    }
    
    func onShowInicio() {
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        let pedidoDetalle = _storyboard?.instantiateViewController(withIdentifier: "sbPedidoDetalle")
        
        self.navigationController?.pushViewController(pedidoDetalle!, animated: true)

    }
    
}

//Manejor de eventos de la coleccion de vistas
extension ClienteDetalleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._lstInformacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celClienteDetalle", for: indexPath) as! detalleClienteTableViewCell
        
        let key = Array(_lstInformacion.keys)[indexPath.row]
        
        cell.lblKey.text = key
        cell.lblValue.text = self._lstInformacion[key] as? String
        return cell
    }
}


