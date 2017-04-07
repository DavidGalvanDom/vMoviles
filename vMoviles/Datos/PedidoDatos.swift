//
//  PedidoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class PedidoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("pedidos")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "pedido" {
                    let key = "\(doc["folio"])\(doc["estatus"])\(doc["razonsocial"])"
                    emit(key, nil)
                }
            }, version: "1.1")
        }
        
        let productoLiveQuery = view.createQuery().asLive()
        productoLiveQuery.descending = true
        
        return productoLiveQuery
    }
    
    //Regresa el documento con los datos del pedido
    func CargarPedido (folio: String) -> CBLDocument? {
        
        if database.existingDocument(withID: folio) != nil {
            let doc = database.document(withID: folio)
            return doc
        } else {
            return nil
        }
    }

       
}
