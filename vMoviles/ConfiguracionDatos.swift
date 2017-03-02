//
//  ConfiguracionDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/1/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation
import UIKit

class ConfiguracionDatos {
    var database: CBLDatabase!
    
    init() {
        var databaseConfig: CBLDatabase!
        let options = CBLDatabaseOptions()
        options.create = true
        do {
            try databaseConfig = CBLManager.sharedInstance().openDatabaseNamed("config", with: options)
        }
        catch {
            
        }
        database = databaseConfig
    }
    
    func createConfiguracion() -> CBLSavedRevision? {

        let properties: Dictionary<String, Any> = [
            "type": "configuracion",
            "folio": "-1",
            "agente": "-1",
            "lineaVenta": "-1", //"cat-1,cat-2",
            "zona": " -1 ",
            "nombreVendedor": " Configurar Usuario "
        ]
        
        let doc = database.createDocument()
        do {
            return try doc.putProperties(properties)
        } catch { /*let error as NSError {
            
            
            Ui.showMessageDialog(onController: self, withTitle: "Error",
                                 withMessage: "Couldn't save task", withError: error)
             */
            return nil
        }
    }
    
    ///Se actulizan los datos del documento
    func updateConfiguracion(config: CBLDocument, withConfiguracion newConfig: Configuracion) {
        do {
            var prop = config.properties
            //var error: NSError?
            
            prop?["folio"] = newConfig.folio
            prop?["agente"] = newConfig.agente
            prop?["lineaVenta"] = newConfig.lineaVenta
            prop?["zona"] = newConfig.zona
            prop?["nombreVendedor"] = newConfig.nombreVendedor
        
            try config.putProperties(prop!)
            
        } catch {
            
        }
    }

    
    //Se define la vista y se crea la consulta de documento
    func setupViewAndQuery() -> CBLQuery{
        let view = database.viewNamed("configuracion")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                let agente = doc["agente"] as? String
                if type == "configuracion" {
                    emit(agente ?? "", nil)
                }
            }, version: "1.0")
        }
        
        let configuraQuery = view.createQuery()
        configuraQuery.descending = false
        
        return configuraQuery
        
    }


}
