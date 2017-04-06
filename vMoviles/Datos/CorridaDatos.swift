//
//  CorridaDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/11/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


class CorridaDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLQuery{
        let view = database.viewNamed("corrida")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "corrida" {
                    //let cvecor = doc["cvecor"] as? String
                    let corrida = doc["corrida"] as? String
                    emit(corrida ?? "0", nil)
                }
            }, version: "1.2")
        }
        
        let corridaQuery = view.createQuery()
        corridaQuery.descending = false
        
        return corridaQuery
    }
    
    //Regresa el documento con los datos de la corrida
    func CargarCorrida (idDocument: String) -> CBLDocument? {
        
        if database.existingDocument(withID: idDocument) != nil {
            let doc = database.document(withID: idDocument)
            return doc
        } else {
            return nil
        }
    }

}
