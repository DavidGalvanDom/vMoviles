//
//  InventarioTipoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/15/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class InventarioTipoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLQuery {
        let view = database.viewNamed("inventariotipo")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "inventariotipo" {
                    let articulo = doc["keyArticulo"] as? String
                    emit(articulo ?? "0", nil)
                }
            }, version: "1.0")
        }
        
        let inventarioQuery = view.createQuery()
        inventarioQuery.descending = false
        
        return inventarioQuery
    }
}
