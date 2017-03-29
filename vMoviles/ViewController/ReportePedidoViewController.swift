//
//  ReportePedidoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/28/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ReportePedidoViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var _pedido: Pedido!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.generarHTML()
    }

    func generarHTML () {
       var htmlNew : String = ""
       var index :Int = 0
        
        do{
            guard let filePath = Bundle.main.path(forResource: "rptPedido", ofType: "html")
                else {
                    // File Error
                    print ("Error al cargar la plantilla del Reporte Pedidos")
                    return
            }
            
            var htmlCont =  try String(contentsOfFile: filePath, encoding: .utf8)
            
            htmlCont = self.encabezadoPedido(html: htmlCont)
            
            for item in self._pedido.detalle {
                index = index + 1
                htmlNew = htmlNew + self.crearRenglon(item: item, index: index)
            }
            
            htmlCont =  htmlCont.replacingOccurrences(of: "$DETALLE_PEDIDO$", with: htmlNew)
            let baseUrl = URL.init(fileURLWithPath: filePath)
            self.webView.loadHTMLString(htmlCont as String, baseURL: baseUrl)
        }
        catch
        {
            print ("Error en el archivo HTML rptPedido.html")
        }
    }
    
    func encabezadoPedido(html: String) -> String {
        var inf : String = html
        
        inf = inf.replacingOccurrences(of: "$FOLIO$", with: self._pedido.folio)
        inf = inf.replacingOccurrences(of: "$NUM_CLIENTE$", with: String(self._pedido.idcliente))
        inf = inf.replacingOccurrences(of: "$NOM_CLI$", with: self._pedido.cliente?.razonsocial as! String)
        inf = inf.replacingOccurrences(of: "$DIR_CLI$", with: self._pedido.cliente?.dir as! String)
        inf = inf.replacingOccurrences(of: "$COLCID_CLI$", with: " \(self._pedido.cliente?.colonia)   \(self._pedido.cliente?.ciudad)")
        inf = inf.replacingOccurrences(of: "$ESTADO_CLI$", with: self._pedido.cliente?.estado as! String)
        inf = inf.replacingOccurrences(of: "$SUCUR_CLI$", with: self._pedido.cliente?.sucursal as! String)
        inf = inf.replacingOccurrences(of: "$OBSER_CLI$", with: self._pedido.observacion as String)
        
        inf = inf.replacingOccurrences(of: "$DIR_ENTREGA$", with:  self._pedido.embarque?.direccion as! String)
        inf = inf.replacingOccurrences(of: "$COLCIU_ENTREGA$", with: " \(self._pedido.embarque?.colonia)   \(self._pedido.embarque?.ciudad)")
        inf = inf.replacingOccurrences(of: "$ESTADO_ENTREGA$", with:  self._pedido.embarque?.estado as! String)
        inf = inf.replacingOccurrences(of: "$FENTREGA_ENTREGA$", with: "\(self._pedido.fechaInicio!) - \(self._pedido.fechaFin!)")
        inf = inf.replacingOccurrences(of: "$FPEDIDO_ENTREGA$", with:  self._pedido.fechaCreacion as String)
        inf = inf.replacingOccurrences(of: "$CONDICIONES_ENTREGA$", with: " ")
        
        return inf
    }
    
    func crearRenglon(item: RowPedidoProducto, index: Int) -> String {
        var row: String = ""
        var numeracion: String = ""
        
        numeracion = "<table border='0' style='width:100%'><tr>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c1) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c2) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c3) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c4) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c5) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c6) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c7) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c8) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c9) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c10) </td>"
        
        if(item.corrida.c11 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c11) </td>"
        }
        if(item.corrida.c12 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c12) </td>"
        }
        if(item.corrida.c13 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c13) </td>"
        }
        if(item.corrida.c14 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c14) </td>"
        }
        if(item.corrida.c15 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.corrida.c15) </td>"
        }
        
        numeracion = numeracion + " </tr>"
        
        numeracion = numeracion + "<tr> <td class='rangoCol'>\(item.p1) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p2) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p3) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p4) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p5) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p6) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p7) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p8) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p9) </td>"
        numeracion = numeracion + "<td class='rangoCol'>\(item.p10) </td>"
        
        if(item.corrida.c11 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.p11) </td>"
        }
        if(item.corrida.c12 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.p12) </td>"
        }
        if(item.corrida.c13 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.p13) </td>"
        }
        if(item.corrida.c14 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.p14) </td>"
        }
        if(item.corrida.c15 != "0") {
            numeracion = numeracion + "<td class='rangoCol'>\(item.p15) </td>"
        }

        numeracion = numeracion + " </tr> </table>"
        
        row = row + " <tr> "
        row = row + "  <td>\(item.renglon)</td>"
        row = row + "  <td>\(item.estilo) - \(item.opcion)</td>"
        row = row + "  <td>\(item.pielcolor)</td>"
        row = row + "  <td>\(item.linea)</td>"
        row = row + "  <td>\(item.pares)</td>"
        row = row + "  <td>\(numeracion)</td>"
        row = row + "  <td class='rangoCol'>\(item.precio)</td>"
        row = row + "  <td>\(item.precioCalle)</td>"
        row = row + "  <td>\(item.precioCCom)</td>"
        row = row + "  <td>\(item.semana)</td>"
        row = row + "  <td>\(item.ts)</td>"
        row = row + " </tr>"
        
        
        return row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPDF(_ sender: Any) {
        
    }
    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
    }

}