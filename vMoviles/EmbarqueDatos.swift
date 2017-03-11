//
//  EmbarqueDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class EmbarqueDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("embarques")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "embarque" {
                    let idEmbarque = doc["_id"] as? String
                    emit(idEmbarque ?? "", nil)
                }
            }, version: "1.2")
        }
        
        let embarqueLiveQuery = view.createQuery().asLive()
        embarqueLiveQuery.descending = false
        
        return embarqueLiveQuery
        
    }
    
    func setupViewEmbarquesClienteAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("embarquescliente")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "embarque" {
                    let cliente = doc["keycli"] as? String
                    let embarque = doc["embarque"] as? String
                    emit([cliente ?? "",embarque ?? ""], nil)
                }
            }, version: "1.0")
        }
        
        let embarqueclienteLiveQuery = view.createQuery().asLive()
        embarqueclienteLiveQuery.descending = false
        
        return embarqueclienteLiveQuery
    }
}
