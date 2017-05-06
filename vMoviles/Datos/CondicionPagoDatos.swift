//
//  CondicionPagoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 5/5/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


class CondicionesPagoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLQuery {
        let view = database.viewNamed("condicionp")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "condicionp" {
                    let idCon = doc["pk"] as? String
                    emit(idCon ?? "0", nil)
                }
            }, version: "1.0")
        }
        
        let condicionPagoQuery = view.createQuery()
        condicionPagoQuery.descending = true
        
        return condicionPagoQuery
    }
}
