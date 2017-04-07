//
//  ProductoDatos.swift
//  vMoviles
//
//  Created by David Galvan on 3/5/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

class ProductoDatos
{
    var database: CBLDatabase!
    
    init(_database: CBLDatabase!) {
        database = _database
    }
    
    //Todos los productos
    func setupViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("productos")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "producto" {
                    let clave = doc["clave"] as? String
                    let descripcion = doc["descripcion"] as? String
                    emit("\(String(describing: clave)) - \(descripcion ?? "")", nil)
                }
            }, version: "1.0")
        }
        
        let productoLiveQuery = view.createQuery().asLive()
        productoLiveQuery.descending = false
        
        return productoLiveQuery
    }
    
    //Productos que pertenecen a una lista de precios
    func setupLstPrecioViewAndQuery() ->  CBLLiveQuery{
        let view = database.viewNamed("productoslstPrecio")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if (type == "producto"){
                    let clave = doc["clave"] as? String
                    let descripcion = doc["descripcion"] as? String
                    let tpc = doc["tpc"] as? String
                    emit([tpc,clave,"\(String(describing: clave)) - \(descripcion ?? "")"], nil)
                }
            }, version: "1.5")
        }
        
        let productoLiveQuery = view.createQuery().asLive()
        productoLiveQuery.descending = false
        
        return productoLiveQuery
    }
    
    //Se carga el producto con la clave seleccionada
    func CargarProducto (clave: String)-> CBLDocument? {
        if database.existingDocument(withID: clave) != nil {
            let doc = database.document(withID: clave)
            return doc
        } else {
            return nil
        }
    }

    //Regresa la imagen sin ninguna modificacion
    func CargarImagen ( clave: String) -> UIImage {
        //Se carga la imagen el producto y se despliega en la interfaz
        let docImg = self.database.document(withID: clave as String)
        let rev = docImg?.currentRevision
        
        if let attachment = rev?.attachmentNamed("\(clave).jpg"), let data = attachment.content {
            return UIImage(data: data)!
        } else {
            return UIImage(named: "noImage")!
        }
    }
    
    //Se cargan las opciones de un estilo
    func CargaOpciones() ->  CBLQuery {
        let view = database.viewNamed("productoOpciones")
        if view.mapBlock == nil {
            view.setMapBlock({ (doc, emit) in
                let type = doc["type"] as? String
                if type == "producto" {
                    let estilo = doc["estilo"] as? String
                    let tpc = doc["tpc"] as? String
                    emit([tpc,estilo ?? "0"], nil)
                }
            }, version: "1.1")
        }
        
        let opcionesEstiloQuery = view.createQuery()
        opcionesEstiloQuery.descending = false
        
        return opcionesEstiloQuery
    }

    
}
