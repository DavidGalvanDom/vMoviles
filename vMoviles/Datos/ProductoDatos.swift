//
//  ProductoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/5/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class ProductoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("productos")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "producto" {
                    let clave = doc["clave"] as? String
                    let descripcion = doc["descripcion"] as? String
                    emit("\(clave) - \(descripcion ?? "")", nil)
                }
            }, version: "1.0")
        }
        
        let productoLiveQuery = view.createQuery().asLive()
        productoLiveQuery.descending = false
        
        return productoLiveQuery
        
    }
    
    //Productos que pertenecen a una lista de precios
    func setupLstPrecioViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("productoslstPrecio")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if (type == "producto"){
                    let clave = doc["clave"] as? String
                    let descripcion = doc["descripcion"] as? String
                    let tpc = doc["tpc"] as? String
                    emit([tpc,clave,"\(clave) - \(descripcion ?? "")"], nil)
                }
            }, version: "1.5")
        }
        
        let productoLiveQuery = view.createQuery().asLive()
        productoLiveQuery.descending = false
        
        return productoLiveQuery
        
    }
    
    //Se carga el producto con la clave seleccionada
    func CargarProducto (clave: String)-> CBLDocument {
        let doc = database.document(withID: clave)
        return doc!
    }

    
}
