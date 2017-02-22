//
//  File.swift
//  vMoviles
//
//  Created by David Galvan on 2/20/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


class ClienteDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("clientes")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                let razonso = doc["razonsocial"] as? String
                if type == "cliente" {
                    emit(razonso ?? "", nil)
                }
            }, version: "1.6")
        }
        
        let clienteLiveQuery = view.createQuery().asLive()
        clienteLiveQuery.descending = false
        
        return clienteLiveQuery
        
    }

}
