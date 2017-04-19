//
//  ProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoViewController:  UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtLinea: UITextField!
    @IBOutlet weak var txtEstilo: UITextField!
    
    var _app: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        self.splitViewController?.maximumPrimaryColumnWidth = 320
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        NSLog(text)
    }


    // MARK: - UITableViewController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoListCell", for: indexPath)
        
        cell.textLabel?.text = "Filtros.."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "muestraDetalle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalleProd" {
                let controller = (segue.destination as! UINavigationController).topViewController as! ProductoDetalleViewController
                controller._linea = self.txtLinea.text?.uppercased()
                controller._estilo = self.txtEstilo.text?.uppercased()
        }
    }

    
    @IBAction func onBuscar(_ sender: Any) {
        
        
    }
    

}
