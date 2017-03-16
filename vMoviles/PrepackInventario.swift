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
            self.cveart = forPrepack?.cveart as! String
            self.cvecor = forPrepack?.cvecor as! String
            self.pck = forPrepack?.pck as! String
            self.p1 = forPrepack?.p1 as! String
            self.p2 = forPrepack?.p2 as! String
            self.p3 = forPrepack?.p3 as! String
            self.p4 = forPrepack?.p4 as! String
            self.p5 = forPrepack?.p5 as! String
            self.p6 = forPrepack?.p6 as! String
            self.p7 = forPrepack?.p7 as! String
            self.p8 = forPrepack?.p8 as! String
            self.p9 = forPrepack?.p9 as! String
            self.p10 = forPrepack?.p10 as! String
            self.p11 = forPrepack?.p11 as! String
            self.p12 = forPrepack?.p12 as! String
            self.p13 = forPrepack?.p13 as! String
            self.p14 = forPrepack?.p14 as! String
            self.p15 = forPrepack?.p15 as! String
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
