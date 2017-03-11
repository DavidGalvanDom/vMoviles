//
//  Producto.swift
//  vMoviles
//
//  Created by David Galvan on 3/6/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


@objc(Producto)
class Producto: CBLModel {
    @NSManaged var idlinea: NSString
    @NSManaged var lista: NSString
    @NSManaged var costo: NSString
    @NSManaged var tpc: NSString
    @NSManaged var clave: NSString
    @NSManaged var semanaprod: NSString
    @NSManaged var descripcion: NSString
    @NSManaged var precioca: NSString
    @NSManaged var preciocc: NSString
    @NSManaged var estilo: NSString
    @NSManaged var ofecta: NSString
    @NSManaged var importacion: NSString
    @NSManaged var opcion: NSString
    @NSManaged var linea: NSString
    @NSManaged var cat: NSString
    @NSManaged var proveedor: NSString
    @NSManaged var suelac: NSString
    @NSManaged var suela: NSString
    @NSManaged var prepack: NSString
    @NSManaged var tiposervicio: NSString
    @NSManaged var categoria: NSString
    @NSManaged var corrida: NSString
    @NSManaged var catego: NSString
    @NSManaged var activo: NSString
}
