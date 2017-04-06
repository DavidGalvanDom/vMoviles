//
//  OpcionEstilo.swift
//  vMoviles
//
//  Created by David Galvan on 4/4/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class OpcionEstilo {
    
    var opcion: String!
    var color: String!
    var precio: Double!
    var clave: String!
    
    init (opcion: String, color: String, precio: Double, clave: String) {
        self.opcion = opcion
        self.color = color
        self.precio = precio
        self.clave = clave
    }
}
