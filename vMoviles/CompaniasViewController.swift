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
    
    var companias: [Compania] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companias.append( Compania(id: "vmozono", descripcion: "Ozono"))
        companias.append( Compania(id: "vmepi", descripcion: "Episodio"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get database and username:
        let app = UIApplication.shared.delegate as! AppDelegate
        
        self.lblVendedor.text = app.config!.nombreVendedor as String
        
        self.splitViewController?.preferredDisplayMode = .primaryHidden

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiaCell", for: indexPath)
        
        let compania = companias[indexPath.row]
        cell.textLabel?.text = compania._descripcion
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.cveCompania = companias[indexPath.row]._id
        app.compania = companias[indexPath.row]._descripcion
    }
    
    // MARK: - Navigation

    //Secaptura la compñia seleccionada para iniciar la sincronizacion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueCompania",
            let comIndex = tableView.indexPathForSelectedRow?.row
        {
            let app = UIApplication.shared.delegate as! AppDelegate
            app.stopReplication()
            app.startReplication(compania: companias[comIndex]._id)
        }

    }

}
