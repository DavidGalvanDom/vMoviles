//
//  TipoPedido.swift
//  vMoviles
//
//  Created by David Galvan on 3/16/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

@objc(TipoPedido)
class TipoPedido : CBLModel {
    @NSManaged var id: NSString
    @NSManaged var descripcion: NSString
}
