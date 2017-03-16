//
//  Prepack.swift
//  vMoviles
//
//  Created by David Galvan on 3/13/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


@objc(Prepack)
class Prepack: CBLModel {
    @NSManaged var cveart: NSString
    @NSManaged var cvecor: NSString
    @NSManaged var descripcion: NSString
    @NSManaged var tipo: NSString
    @NSManaged var pck: NSString
    @NSManaged var p1: NSString
    @NSManaged var p2: NSString
    @NSManaged var p3: NSString
    @NSManaged var p4: NSString
    @NSManaged var p5: NSString
    @NSManaged var p6: NSString
    @NSManaged var p7: NSString
    @NSManaged var p8: NSString
    @NSManaged var p9: NSString
    @NSManaged var p10: NSString
    @NSManaged var p11: NSString
    @NSManaged var p12: NSString
    @NSManaged var p13: NSString
    @NSManaged var p14: NSString
    @NSManaged var p15: NSString

    weak var inventario: InventarioTipo?
}
