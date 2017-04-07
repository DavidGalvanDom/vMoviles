//
//  PrepackInventario.swift
//  vMoviles
//
//  Created by David Galvan on 3/16/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class PrepackInventario  {
    var cveart: String
    var cvecor: String
    var descripcion: String
    var tipo: String
    var pck: String
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
    var I1: String
    var I2: String
    var I3: String
    var I4: String
    var I5: String
    var I6: String
    var I7: String
    var I8: String
    var I9: String
    var I10: String
    var I11: String
    var I12: String
    var I13: String
    var I14: String
    var I15: String
    
    init(forPrepack: Prepack?) {
        if(forPrepack != nil) {
            self.cveart = String(describing: forPrepack?.cveart)
            self.cvecor = String(describing: forPrepack?.cvecor)
            self.pck = String(describing: forPrepack?.pck)
            self.p1 = String(describing: forPrepack?.p1)
            self.p2 = String(describing: forPrepack?.p2)
            self.p3 = String(describing: forPrepack?.p3)
            self.p4 = String(describing: forPrepack?.p4)
            self.p5 = String(describing: forPrepack?.p5)
            self.p6 = String(describing: forPrepack?.p6)
            self.p7 = String(describing: forPrepack?.p7)
            self.p8 = String(describing: forPrepack?.p8)
            self.p9 = String(describing: forPrepack?.p9)
            self.p10 = String(describing: forPrepack?.p10)
            self.p11 = String(describing: forPrepack?.p11)
            self.p12 = String(describing: forPrepack?.p12)
            self.p13 = String(describing: forPrepack?.p13)
            self.p14 = String(describing: forPrepack?.p14)
            self.p15 = String(describing: forPrepack?.p15)
        } else {
            self.cveart = ""
            self.cvecor = ""
            self.pck = ""
            self.p1 = "0"
            self.p2 = "0"
            self.p3 = "0"
            self.p4 = "0"
            self.p5 = "0"
            self.p6 = "0"
            self.p7 = "0"
            self.p8 = "0"
            self.p9 = "0"
            self.p10 = "0"
            self.p11 = "0"
            self.p12 = "0"
            self.p13 = "0"
            self.p14 = "0"
            self.p15 = "0"
        }
        
        self.descripcion = "OZONO NORMAL"
        self.tipo = "O"
        
        self.I1 = "0"
        self.I2 = "0"
        self.I3 = "0"
        self.I4 = "0"
        self.I5 = "0"
        self.I6 = "0"
        self.I7 = "0"
        self.I8 = "0"
        self.I9 = "0"
        self.I10 = "0"
        self.I11 = "0"
        self.I12 = "0"
        self.I13 = "0"
        self.I14 = "0"
        self.I15 = "0"
    }
}
