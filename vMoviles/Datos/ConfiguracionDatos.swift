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
            NSLog("Erro al momento de abrir la base de datos de Config")
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
            "nombreVendedor": " Configurar Usuario ",
            "urlSync": "http://192.168.0.8:4984"
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
    func updateConfiguracion(withConfiguracion newConfig: Configuracion) {
        do {
            if(database != nil) {
                let docId : String = newConfig.getValueOfProperty("_id") as! String
                let config = database.document(withID: docId)
                var prop = config?.properties
                //var error: NSError?
            
                prop?["folio"] = newConfig.folio
                prop?["agente"] = newConfig.agente
                prop?["lineaVenta"] = newConfig.lineaVenta
                prop?["zona"] = newConfig.zona
                prop?["nombreVendedor"] = newConfig.nombreVendedor
                prop?["urlSync"] = newConfig.urlSync
        
                try config?.putProperties(prop!)
            }
        } catch {
            
        }
    }

    
    //Se define la vista y se crea la consulta de documento
    func setupViewAndQuery() -> CBLQuery{
        let view = database.viewNamed("configuracion")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "configuracion" {
                    let agente = doc["agente"] as? String
                    emit(agente ?? "", nil)
                }
            }, version: "1.0")
        }
        
        let configuraQuery = view.createQuery()
        configuraQuery.descending = false
        
        return configuraQuery
        
    }


}
