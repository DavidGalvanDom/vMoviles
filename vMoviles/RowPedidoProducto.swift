//
//  RenglonPedidoProducto.swift
//  vMoviles
//
//  Created by David Galvan on 3/17/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class RowPedidoProducto  {
    var renglon: Int
    var semana: String
    var semanaCliente: String
    var cveart: String
    var opcion: String
    var estilo: String
    var pares: Int
    var precio: Double
    var pielcolor: String
    var ts : String
    var pck: String
    var numPck: Int
    var p1: String
    var p2: String
    var p3: String
    var p4: String
    var p5: String
    var p6: String
    var p7: String
    var p8: String
    var p9: String
    var p10: String
    var p11: String
    var p12: String
    var p13: String
    var p14: String
    var p15: String
    var imagen: UIImage
    
    
    /*    init(renglon: Int, semana: String, semanaClie: String, cveart: String, opcion: String,estilo: String, pares: Int,precio:Double, pielcolor: String, ts: String, pck: String, numpck: Int, img: UIImage,p1: String, p2: String, p3:String, p4: String, p5:String,p6:String,p7:String, p8:String, p9:String, p10:String, p11:String, p12:String, p13:String, p14:String, p15:String) {*/
    
    init(renglon: Int, cveart:String, img: UIImage, pielcolor: String) {
        
        self.renglon = renglon
        self.imagen = img
        self.cveart = cveart
        self.pielcolor = pielcolor
        
        /*
        self.semana = semana
        self.semanaCliente = semanaClie
        self.opcion = opcion
        self.estilo = estilo
        self.pares = pares
        self.precio = precio
        self.ts = ts
        self.pck = pck
        self.numPck = numpck
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        self.p4 = p4
        self.p5 = p5
        self.p6 = p6
        self.p7 = p7
        self.p8 = p8
        self.p9 = p9
        self.p10 = p10
        self.p11 = p11
        self.p12 = p12
        self.p13 = p13
        self.p14 = p14
        self.p15 = p15*/
    
        self.semana = ""
        self.semanaCliente = ""
        self.opcion = ""
        self.estilo = ""
        self.pares = 0
        self.precio = 0
        self.ts = ""
        self.pck = ""
        self.numPck = 0
        self.p1 = ""
        self.p2 = ""
        self.p3 = ""
        self.p4 = ""
        self.p5 = ""
        self.p6 = ""
        self.p7 = ""
        self.p8 = ""
        self.p9 = ""
        self.p10 = ""
        self.p11 = ""
        self.p12 = ""
        self.p13 = ""
        self.p14 = ""
        self.p15 = ""
        
    }
}
