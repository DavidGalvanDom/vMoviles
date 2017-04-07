//
//  PrepacksViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/13/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PrepacksViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
  
    weak var delegate:PrepackDelegate?
    var _app: AppDelegate!
    var _corrida: Corrida!
    var _producto : Producto!
    var _prepacksInv: [PrepackInventario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self._app = UIApplication.shared.delegate as! AppDelegate
        tableView.delegate = self
        tableView.dataSource = self
        
        CargarPrepackDatos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Se carga la descripcion del tipo de pedido
    func DescripcionTipo (idTipo: String) -> String {
        let tipoPedidoQuery = TipoPedidoDatos(_database: _app.database).setupViewAndQuery()
        
        if( self._producto != nil ) {
            tipoPedidoQuery.startKey = idTipo
            tipoPedidoQuery.endKey = idTipo
        }
        
        do {
            
            let result  = try tipoPedidoQuery.run()
            let doc = result.nextRow()?.document
            
            if(doc != nil) {
                let tipoPedido = TipoPedido(for: (doc)!)
                return tipoPedido!.descripcion as String
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar descripcion tipo Pedido",
                withError: nil)
        }
        
        return "OZONO NORMAL \(idTipo)"
    }
    
    //Se cargan los inventarios de los prepack y se genera el 99
    func CargarInventarioTipoDatos()
    {
        let inventariosQuery = InventarioTipoDatos(_database: _app.database).setupViewAndQuery()
        
        if( self._producto != nil ) {
            inventariosQuery.startKey = self._producto.clave
            inventariosQuery.endKey = self._producto.clave
        }
        
        do {
            var encontroPrepcak = false
            let result  = try inventariosQuery.run()
            while let doc = result.nextRow()?.document {
                let inventario = InventarioTipo(for: (doc))
                encontroPrepcak = false
                self._prepacksInv.forEach { pck in
                    if(pck.cveart == String(describing: inventario?.keyArticulo) &&
                        pck.pck == String(describing: inventario?.pck)) {
                        pck.tipo = String(describing: inventario?.Tipo)
                        pck.I1 = String(describing: inventario?.I1)
                        pck.I2 = String(describing: inventario?.I2)
                        pck.I3 = String(describing: inventario?.I3)
                        pck.I4 = String(describing: inventario?.I4)
                        pck.I5 = String(describing: inventario?.I5)
                        pck.I6 = String(describing: inventario?.I6)
                        pck.I7 = String(describing: inventario?.I7)
                        pck.I8 = String(describing: inventario?.I8)
                        pck.I9 = String(describing: inventario?.I9)
                        pck.I10 = String(describing: inventario?.I10)
                        pck.I11 = String(describing: inventario?.I11)
                        pck.I12 = String(describing: inventario?.I12)
                        pck.I13 = String(describing: inventario?.I13)
                        pck.I14 = String(describing: inventario?.I14)
                        pck.I15 = String(describing: inventario?.I15)
                        
                        pck.descripcion = DescripcionTipo(idTipo: String(describing: inventario?.Tipo))
                        
                        encontroPrepcak = true
                    }
                }
                
                if(!encontroPrepcak){
                    let nuevo = PrepackInventario(forPrepack: nil)
                    nuevo.cveart = String(describing: inventario?.keyArticulo)
                    nuevo.pck = "99"
                    nuevo.tipo = String(describing: inventario?.Tipo)
                    nuevo.descripcion = DescripcionTipo(idTipo: String(describing: inventario?.Tipo))
                    nuevo.I1 = String(describing: inventario?.I1)
                    nuevo.I2 = String(describing: inventario?.I2)
                    nuevo.I3 = String(describing: inventario?.I3)
                    nuevo.I4 = String(describing: inventario?.I4)
                    nuevo.I5 = String(describing: inventario?.I5)
                    nuevo.I6 = String(describing: inventario?.I6)
                    nuevo.I7 = String(describing: inventario?.I7)
                    nuevo.I8 = String(describing: inventario?.I8)
                    nuevo.I9 = String(describing: inventario?.I9)
                    nuevo.I10 = String(describing: inventario?.I10)
                    nuevo.I11 = String(describing: inventario?.I11)
                    nuevo.I12 = String(describing: inventario?.I12)
                    nuevo.I13 = String(describing: inventario?.I13)
                    nuevo.I14 = String(describing: inventario?.I14)
                    nuevo.I15 = String(describing: inventario?.I15)
                    
                    self._prepacksInv.append(nuevo)
                }
            }
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar los inventarios tipo  clave: \(self._producto.clave)",
                withError: nil)
        }
    }
    
    func CargarPrepackDatos()
    {
        let prepackQuery = PrepacksDatos(_database: _app.database).setupViewAndQuery()
        
        if( self._producto != nil ) {
            prepackQuery.startKey = [self._producto.clave,self._producto.corrida]
            prepackQuery.endKey = [self._producto.clave, self._producto.corrida]
        }
        
        do {
            // var erro: NSError?
            let result  = try prepackQuery.run()
            while let doc = result.nextRow()?.document {
                let prepack = Prepack(for: (doc))
                let prepackInv = PrepackInventario(forPrepack: prepack!)
                self._prepacksInv.append(prepackInv)
            }
            
            self.CargarInventarioTipoDatos()
            tableView.reloadData()
        }
        catch {
            Ui.showMessageDialog(onController: self,
                                 withTitle: "Error",
                                 withMessage: "Error al cargar los prepacks del producto: \(self._producto.description)",
                withError: nil)
        }
    }

    //Oculta o muestra las columnas del renglon
    func OcultaColumnas(cell: prepackTableViewCell)
    {
        cell.lblC7.isHidden = self._corrida.c7 == "0"
        cell.lblC8.isHidden = self._corrida.c8 == "0"
        cell.lblC9.isHidden = self._corrida.c9 == "0"
        cell.lblC10.isHidden = self._corrida.c10 == "0"
        cell.lblC11.isHidden = self._corrida.c11 == "0"
        cell.lblC12.isHidden = self._corrida.c12 == "0"
        cell.lblC13.isHidden = self._corrida.c13 == "0"
        cell.lblC14.isHidden = self._corrida.c14 == "0"
        cell.lblC15.isHidden = self._corrida.c15 == "0"
        
        cell.txtP7.isHidden = self._corrida.c7 == "0"
        cell.txtP8.isHidden = self._corrida.c8 == "0"
        cell.txtP9.isHidden = self._corrida.c9 == "0"
        cell.txtP10.isHidden = self._corrida.c10 == "0"
        cell.txtP11.isHidden = self._corrida.c11 == "0"
        cell.txtP12.isHidden = self._corrida.c12 == "0"
        cell.txtP13.isHidden = self._corrida.c13 == "0"
        cell.txtP14.isHidden = self._corrida.c14 == "0"
        cell.txtP15.isHidden = self._corrida.c15 == "0"
        
        cell.txtI7.isHidden = self._corrida.c7 == "0"
        cell.txtI8.isHidden = self._corrida.c8 == "0"
        cell.txtI9.isHidden = self._corrida.c9 == "0"
        cell.txtI10.isHidden = self._corrida.c10 == "0"
        cell.txtI11.isHidden = self._corrida.c11 == "0"
        cell.txtI12.isHidden = self._corrida.c12 == "0"
        cell.txtI13.isHidden = self._corrida.c13 == "0"
        cell.txtI14.isHidden = self._corrida.c14 == "0"
        cell.txtI15.isHidden = self._corrida.c15 == "0"
    }
    
    //Se ponen editables las cajas de texto del tipo 99
    func EditaPrepack(cell: prepackTableViewCell)
    {
        cell.txtP1.isEnabled = true
        cell.txtP2.isEnabled = true
        cell.txtP3.isEnabled = true
        cell.txtP4.isEnabled = true
        cell.txtP5.isEnabled = true
        cell.txtP6.isEnabled = true
        cell.txtP7.isEnabled = true
        cell.txtP8.isEnabled = true
        cell.txtP9.isEnabled = true
        cell.txtP10.isEnabled = true
        cell.txtP11.isEnabled = true
        cell.txtP12.isEnabled = true
        cell.txtP13.isEnabled = true
        cell.txtP14.isEnabled = true
        cell.txtP15.isEnabled = true
    }
    
    //Se genera el encabezado de la corrida
    func AsignaCorrida(cell: prepackTableViewCell)
    {
        cell.lblC1.text = self._corrida.c1 as String == "0" ? "" : self._corrida.c1 as String
        cell.lblC2.text = self._corrida.c2 as String == "0" ? "" : self._corrida.c2 as String
        cell.lblC3.text = self._corrida.c3 as String == "0" ? "" : self._corrida.c3 as String
        cell.lblC4.text = self._corrida.c4 as String == "0" ? "" : self._corrida.c4 as String
        cell.lblC5.text = self._corrida.c5 as String == "0" ? "" : self._corrida.c5 as String
        cell.lblC6.text = self._corrida.c6 as String == "0" ? "" : self._corrida.c6 as String
        cell.lblC7.text = self._corrida.c7 as String == "0" ? "" : self._corrida.c7 as String
        cell.lblC8.text = self._corrida.c8 as String == "0" ? "" : self._corrida.c8 as String
        cell.lblC9.text = self._corrida.c9 as String  == "0" ? "" : self._corrida.c9 as String
        cell.lblC10.text = self._corrida.c10 as String == "0" ? "" : self._corrida.c10 as String
        cell.lblC11.text = self._corrida.c11 as String == "0" ? "" : self._corrida.c11 as String
        cell.lblC12.text = self._corrida.c12 as String == "0" ? "" : self._corrida.c12 as String
        cell.lblC13.text = self._corrida.c13 as String == "0" ? "" : self._corrida.c13 as String
        cell.lblC14.text = self._corrida.c14 as String == "0" ? "" : self._corrida.c14 as String
        cell.lblC15.text = self._corrida.c15 as String == "0" ? "" : self._corrida.c15 as String
    }
    
    //Se asgina los prepack y los inventarios por renglon
    func AsignaValores(cell: prepackTableViewCell, prepackInv: PrepackInventario)
    {
        cell.txtP1.text = prepackInv.p1 as String
        cell.txtP2.text = prepackInv.p2 as String
        cell.txtP3.text = prepackInv.p3 as String
        cell.txtP4.text = prepackInv.p4 as String
        cell.txtP5.text = prepackInv.p5 as String
        cell.txtP6.text = prepackInv.p6 as String
        cell.txtP7.text = prepackInv.p7 as String
        cell.txtP8.text = prepackInv.p8 as String
        cell.txtP9.text = prepackInv.p9 as String
        cell.txtP10.text = prepackInv.p10 as String
        cell.txtP11.text = prepackInv.p11 as String
        cell.txtP12.text = prepackInv.p12 as String
        cell.txtP13.text = prepackInv.p13 as String
        cell.txtP14.text = prepackInv.p14 as String
        cell.txtP15.text = prepackInv.p15 as String
        
        cell.txtI1.text = prepackInv.I1 as String
        cell.txtI2.text = prepackInv.I2 as String
        cell.txtI3.text = prepackInv.I3 as String
        cell.txtI4.text = prepackInv.I4 as String
        cell.txtI5.text = prepackInv.I5 as String
        cell.txtI6.text = prepackInv.I6 as String
        cell.txtI7.text = prepackInv.I7 as String
        cell.txtI8.text = prepackInv.I8 as String
        cell.txtI9.text = prepackInv.I9 as String
        cell.txtI10.text = prepackInv.I10 as String
        cell.txtI11.text = prepackInv.I11 as String
        cell.txtI12.text = prepackInv.I12 as String
        cell.txtI13.text = prepackInv.I13 as String
        cell.txtI14.text = prepackInv.I14 as String
        cell.txtI15.text = prepackInv.I15 as String
        
        cell.lblCorPK.text = prepackInv.pck as String
        cell.lblDescripcion.text = prepackInv.descripcion as String
        cell.lblTipo.text =  prepackInv.tipo as String
        
        var total = Int(prepackInv.p1)! + Int(prepackInv.p2)! + Int(prepackInv.p3)!
        total = total + Int(prepackInv.p4)! + Int(prepackInv.p5)! + Int(prepackInv.p6)!
        total = total + Int(prepackInv.p7)! + Int(prepackInv.p8)! + Int(prepackInv.p9)!
        total = total + Int(prepackInv.p10)! + Int(prepackInv.p11)! + Int(prepackInv.p12)!
        total = total + Int(prepackInv.p13)! + Int(prepackInv.p14)! + Int(prepackInv.p15)!
        
        var totalInv = Int(prepackInv.I1)! + Int(prepackInv.I2)! + Int(prepackInv.I3)!
        totalInv = totalInv + Int(prepackInv.I4)! + Int(prepackInv.I5)! + Int(prepackInv.I6)!
        totalInv = totalInv + Int(prepackInv.I7)! + Int(prepackInv.I8)! + Int(prepackInv.I9)!
        totalInv = totalInv + Int(prepackInv.I10)! + Int(prepackInv.I11)! + Int(prepackInv.I12)!
        totalInv = totalInv + Int(prepackInv.I13)! + Int(prepackInv.I14)! + Int(prepackInv.I15)!
        
        cell.lblPares.text = String(total)
        cell.lblInventario.text = String(totalInv)

    }
    
    // MARK: Delegates de la Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._prepacksInv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prepackCell", for: indexPath) as! prepackTableViewCell
        let prepackInv = self._prepacksInv[indexPath.row]
        
        AsignaCorrida(cell: cell)
        OcultaColumnas(cell: cell)
        AsignaValores(cell: cell, prepackInv: prepackInv)
        
        if(prepackInv.pck == "99") {
            self.EditaPrepack(cell: cell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            let prepackInv = self._prepacksInv[indexPath.row]
            
            let cell:prepackTableViewCell = tableView.cellForRow(at: indexPath) as! prepackTableViewCell
            
            if(cell.lblCorPK.text == "99"){
                //Se actualiza el bojeto con los valores de las cajas de texto
                prepackInv.p1 = cell.txtP1.text!
                prepackInv.p2 = cell.txtP2.text!
                prepackInv.p3 = cell.txtP3.text!
                prepackInv.p4 = cell.txtP4.text!
                prepackInv.p5 = cell.txtP5.text!
                prepackInv.p6 = cell.txtP6.text!
                prepackInv.p7 = cell.txtP7.text!
                prepackInv.p8 = cell.txtP8.text!
                prepackInv.p9 = cell.txtP9.text!
                prepackInv.p10 = cell.txtP10.text!
                prepackInv.p11 = cell.txtP11.text!
                prepackInv.p12 = cell.txtP12.text!
                prepackInv.p13 = cell.txtP13.text!
                prepackInv.p14 = cell.txtP14.text!
                prepackInv.p15 = cell.txtP15.text!
            }
            
            delegate?.prepackSeleccionado(sender: prepackInv)
            
            dismiss(animated: true, completion: nil)
            popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
}
