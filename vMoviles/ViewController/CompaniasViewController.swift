//
//  CompaniasViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/15/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class CompaniasViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblVendedor: UILabel!
    
    var _companias: [Compania] = []
    var _storyboard: UIStoryboard!
    var _app: AppDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _companias.append( Compania(id: "vmozono-vmimages", descripcion: "Ozono"))
        _companias.append( Compania(id: "vmepi-vmimagepi", descripcion: "Episodio"))
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ozono-temporada")!)

        tableView.delegate = self
        tableView.dataSource = self
        
        // Get database and username:
        self._app = UIApplication.shared.delegate as! AppDelegate
        guard let root = self._app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        _storyboard = storyboard
        self.lblVendedor.text = self._app.config!.nombreVendedor as String
        
        if(self._app.config!.agente == "-1") {
            self.configuraApp()
        }
    }

    //Popup para configurar la informacion del agente
    func configuraApp()
    {
        
        let vc = _storyboard.instantiateViewController(withIdentifier: "sbConfiguracion") as! ConfiguracionViewController
        
        vc.preferredContentSize = CGSize(width: 600, height: 600)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: { _ in })
        
         self.lblVendedor.text = self._app.config!.nombreVendedor as String
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

// MARK: - UITableViewController
extension CompaniasViewController : UITableViewDelegate, UITableViewDataSource {

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }


}
