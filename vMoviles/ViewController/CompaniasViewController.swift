//
//  CompaniasViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/15/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class CompaniasViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblVendedor: UILabel!
    
    var _companias: [Compania] = []
    var _storyboard: UIStoryboard!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _companias.append( Compania(id: "vmozono-vmimages", descripcion: "Ozono"))
        _companias.append( Compania(id: "vmepi-vmimagepi", descripcion: "Episodio"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get database and username:
        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        _storyboard = storyboard
        self.lblVendedor.text = app.config!.nombreVendedor as String
        
        if(app.config!.agente == "-1") {
            self.configuraApp()
        }
        //Solo en caso de utilizar el splitview controller
        //self.splitViewController?.preferredDisplayMode = .primaryHidden

    }

    //Popup para configurar la informacion del agente
    func configuraApp()
    {
        
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbConfiguracion") as! ConfiguracionViewController
        
        vc.preferredContentSize = CGSize(width: 600, height: 600)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: { _ in })
    }
    
    // MARK: Delegates de la Tabla
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _companias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiaCell", for: indexPath)
        
        let compania = _companias[indexPath.row]
        cell.textLabel?.text = compania._descripcion
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.cveCompania = _companias[indexPath.row]._id
        app.compania = _companias[indexPath.row]._descripcion
    }
    
    //Secaptura la compñia seleccionada para iniciar la sincronizacion
    //se sincroniza informacion he imagenes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueCompania",
            let comIndex = tableView.indexPathForSelectedRow?.row
        {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.stopReplication()
            app.startReplication(compania: _companias[comIndex]._id)
        }

    }
    
    //Despliega la pantalla de configuracion
    @IBAction func onConfiguracion(_ sender: Any) {
        self.configuraApp()
    }
    
}
