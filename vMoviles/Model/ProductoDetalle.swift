//
//  ProductoDetalle.swift
//  vMoviles
//
//  Created by David Galvan on 5/16/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class ProductoDetalle  {

    var cveart: String
    var opcion: String
    var estilo: String
    var pielcolor: String
    var linea: String
    var precio: Double
    var isSelected: Bool
    var imagen: UIImage!
    
    
    init (cveart:String, pielcolor: String,estilo: String, opcion: String,precio: Double, linea: String, img: UIImage, isSelected: Bool = false) {
        self.cveart = cveart
        self.pielcolor = pielcolor
        self.opcion = opcion
        self.estilo = estilo
        self.linea = linea
        self.precio = precio
        self.imagen = img
        self.isSelected = isSelected
    }
    
}
