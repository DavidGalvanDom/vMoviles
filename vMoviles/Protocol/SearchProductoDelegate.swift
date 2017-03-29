//
//  SearchProductoDelegate.swift
//  vMoviles
//
//  Created by David Galvan on 3/6/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation

protocol SearchProductoDelegate: class  {
    func productoSeleccionado (sender: Producto, image: UIImage?)
}
