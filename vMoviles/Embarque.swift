//
//  Embarque.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//


@objc(Embarque)
class Embarque: CBLModel {
    @NSManaged var embarque: NSString
    @NSManaged var keycli: NSString
    @NSManaged var direccion: NSString
    @NSManaged var ciudad: NSString
    @NSManaged var delegacion: NSString
    @NSManaged var codcte: NSString
    @NSManaged var colonia: NSString
    @NSManaged var cp: NSString
    @NSManaged var estado: NSString
}
