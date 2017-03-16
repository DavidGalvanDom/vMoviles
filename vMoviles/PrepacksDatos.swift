//
//  PrepacksDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/13/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation


class PrepacksDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    func setupViewAndQuery() ->  CBLQuery {
        let view = database.viewNamed("prepack")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "prepack" {
                    //let pck = doc["pck"] as? String
                    let cvecor = doc["cvecor"] as? String
                    let articulo = doc["cveart"] as? String
                    emit([articulo ?? "0",cvecor], nil)
                }
            }, version: "1.0")
        }
        
        let corridaQuery = view.createQuery()
        corridaQuery.descending = false
        
        return corridaQuery
    }
}
