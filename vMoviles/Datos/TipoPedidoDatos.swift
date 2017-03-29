//
//  TipoPedidoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/16/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


class TipoPedidoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLQuery {
        let view = database.viewNamed("tipopedido")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "tipopedido" {
                    let idTipo = doc["id"] as? String
                    emit(idTipo ?? "0", nil)
                }
            }, version: "1.0")
        }
        
        let tipoPedidoQuery = view.createQuery()
        tipoPedidoQuery.descending = false
        
        return tipoPedidoQuery
    }
}
