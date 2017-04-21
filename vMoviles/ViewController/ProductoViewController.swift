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
    
    let _secciones = [ "Tipo", "Categoria"]
    let _items = [["DAMA", "CABALLERO", "ACCESORIO"],["SANDALIA", "BALERINA", "SANDALIA B", "BOTIN"]]
    var _muestraSeccion = [true, true]
    var _app: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self._secciones[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self._secciones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Se valida que seccion se muestra el detalle o no
        return self._items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoListCell", for: indexPath) as! productoFiltroTableViewCell
        
        cell.lblDetalle.text = self._items[indexPath.section][indexPath.row]
        let status = cell.seleccionado
        cell.accessoryType = status! ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! productoFiltroTableViewCell
        cell.seleccionado = false
        cell.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! productoFiltroTableViewCell
        cell.seleccionado = true
        cell.accessoryType = .checkmark
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalleProd" {
                let controller = (segue.destination as! UINavigationController).topViewController as! ProductoDetalleViewController
                controller._linea = self.txtLinea.text?.uppercased()
               // controller._estilo = self.txtEstilo.text?.uppercased()
        }
    }

    @IBAction func onBuscar(_ sender: Any) {
        
        
    }

}
