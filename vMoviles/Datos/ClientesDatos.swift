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
                if type == "cliente" {
                    let razonso = doc["razonsocial"] as? String
                    let id = doc["id"] as? String
                    emit("\(String(describing: id)) - \(razonso ?? "")", nil)
                }
            }, version: "1.8")
        }
        
        let clienteLiveQuery = view.createQuery().asLive()
        clienteLiveQuery.descending = false
        
        return clienteLiveQuery
    }
    
    //Regresa el documento con los datos del cliente
    func CargarCliente (cliente: String) -> CBLDocument? {
        
        if database.existingDocument(withID: cliente) != nil {
            let doc = database.document(withID: cliente)
            return doc
        } else {
            return nil
        }
    }
}
