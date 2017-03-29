//
//  SemanasDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/22/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class SemanasDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    //Es solo un documento con los datos de la semana
    func CargarSemanas() ->  Dictionary<String, Any>  {
        var semanas: Dictionary<String, Any>  = [:]
        let doc = database.document(withID: "semana")
        var prop = doc?.properties
        
        semanas["semanae"] = (prop?["semanae"] as! String)
        semanas["semanas"] = (prop?["semanas"] as! String)
        semanas["semanar"] = (prop?["semanar"] as! String)
        
        return semanas

    }
}
