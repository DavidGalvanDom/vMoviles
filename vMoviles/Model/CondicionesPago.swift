//
//  CondicionesPago.swift
//  vMoviles
//
//  Created by David Galvan on 5/5/17.
//  Copyright © 2017 sysba. All rights reserved.
//

@objc(CondicioensPago)
class CondicionesPago: CBLModel {
    @NSManaged var pk: NSString
    @NSManaged var descripcion: NSString
    @NSManaged var diasAd: NSString
    @NSManaged var pdesc: NSString
}
