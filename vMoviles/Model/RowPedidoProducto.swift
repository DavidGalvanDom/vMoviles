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
    var precioCalle: Double
    var precioCCom: Double
    var pielcolor: String
    var linea: String
    var ts : String
    var pck: String
    var numPck: Int
    var tpc: String
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
    var corrida : Corrida
    
    init(renglon: Int, cveart:String, img: UIImage, pielcolor: String, tpc:String,corrida: Corrida) {
        
        self.renglon = renglon
        self.imagen = img
        self.cveart = cveart
        self.pielcolor = pielcolor
        self.corrida = corrida
        self.tpc = tpc
        self.semana = ""
        self.semanaCliente = ""
        self.opcion = ""
        self.estilo = ""
        self.pares = 0
        self.precio = 0
        self.precioCalle = 0
        self.precioCCom = 0
        self.linea = ""
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
