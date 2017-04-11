//
//  Pedido.swift
//  vMoviles
//
//  Created by David Galvan on 3/28/17.
//  Copyright © 2017 sysba. All rights reserved.
//

class Pedido {
    var _id:String!
    var folio:String!
    var observacion:String!
    var fechaInicio:String!
    var fechaFin:String!
    var fechaCancelacion:String!
    var idcliente:String!
    var idembarque: String!
    var total: Double
    var pares: Int!
    var vendedor:String!
    var estatus:String!
    var fechaCreacion:String!
    var detalle:[RowPedidoProducto] = []
    var cliente: Cliente?
    var embarque: Embarque?
    
    
    init(folio: String) {
        self.folio = folio
        self._id = ""
        self.idcliente = "0"
        self.idembarque = "0"
        self.fechaFin = ""
        self.fechaInicio = ""
        self.fechaCreacion = ""
        self.fechaCancelacion = ""
        self.vendedor = ""
        self.pares = 0
        self.total = 0
        self.observacion = ""
        self.estatus = "N"
    }
    
}
