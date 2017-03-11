//
//  Configuracion.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//


@objc(Configuracion)
class Configuracion: CBLModel {
    @NSManaged var folio: NSString
    @NSManaged var agente: NSString
    @NSManaged var lineaVenta: NSString
    @NSManaged var zona: NSString
    @NSManaged var nombreVendedor: NSString
    @NSManaged var urlSync: NSString
}
