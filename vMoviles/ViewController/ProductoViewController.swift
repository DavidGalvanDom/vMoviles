//
//  ProductoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoViewController:  UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtLinea: UITextField!
    
    let _secciones = [ "TIPO", "CATEGORIA"]
    var _items = [["DAMA", "CABALLERO", "ACCESORIO"],[]]
    var _itemsSelected = [[false,false,false],[]]
    var _tipoSelected: [String] = []
    var _categoriaSelected: [String] = []
    var _app: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        
        self._app = UIApplication.shared.delegate as! AppDelegate
        self.splitViewController?.maximumPrimaryColumnWidth = 320
        self.CargarCategorias()
        self.creaNavegador()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Se crean los opciones de navegacion
    func creaNavegador() {
        
        //Toolbar Derecho
        let barCompania = UIBarButtonItem(image: UIImage(named:"icoCompania"), style: .plain, target: self, action: #selector(onShowInicial))
        
        barCompania.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        barCompania.tintColor = .gray
        
        self.navigationItem.rightBarButtonItems = [barCompania]
        
    }
    
    func CargarCategorias () {
        let categoriasQuery = ProductoDatos(_database: self._app.database).CargarCategorias()
        //se aplica el group by usando el reduce en la vista y el key  utilizando el grouplevel
        categoriasQuery.mapOnly = false
        categoriasQuery.groupLevel = 1
        
        do {
            let result  = try categoriasQuery.run()
            while let row = result.nextRow() {
                self._items[1].append("\(row.key)")
                self._itemsSelected[1].append(false)
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar las Categorias",
                                 withError: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalleProd" {
            let controller = (segue.destination as! UINavigationController).topViewController as! ProductoDetalleViewController
            controller._linea = self.txtLinea.text?.uppercased()
            controller._categoria = self._categoriaSelected
            controller._tipo = self._tipoSelected
        }
    }
    
    func onShowInicial() {
        self._app.showInicial()
    }
    
    @IBAction func onBuscar(_ sender: Any) {
    }
    
}

// MARK: - UITableViewController
extension ProductoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self._secciones[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self._secciones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoListCell", for: indexPath) as! productoFiltroTableViewCell
        
        cell.lblDetalle.text = self._items[indexPath.section][indexPath.row]
        
        cell.accessoryType = self._itemsSelected[indexPath.section][indexPath.row] ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! productoFiltroTableViewCell
        cell.seleccionado = false
        cell.accessoryType = .none
        self._itemsSelected[indexPath.section][indexPath.row] = false

        
        if indexPath.section == 0 {
            if let index = self._tipoSelected.index(where: {$0 == cell.lblDetalle.text!}){
                self._tipoSelected.remove(at: index)
            }
            
        } else {
            if let index = self._categoriaSelected.index(where: {$0 == cell.lblDetalle.text!}){
                self._categoriaSelected.remove(at: index)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! productoFiltroTableViewCell
    
        self._itemsSelected[indexPath.section][indexPath.row] = true
        cell.accessoryType = .checkmark
        
        if indexPath.section == 0 {
            self._tipoSelected.append(cell.lblDetalle.text!)
        } else {
            self._categoriaSelected.append(cell.lblDetalle.text!)
        }
        
    }
}
