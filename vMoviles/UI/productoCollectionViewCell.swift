//
//  productoCollectionViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 4/13/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class productoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblClave: UILabel!
    @IBOutlet weak var lblCosto: UILabel!
    @IBOutlet weak var lblEstilo: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageSelected: UIImageView!
    
    var clave: String!
    
    var productoImage: UIImage? {
        didSet {
            image.image = productoImage
            image.layer.cornerRadius = 16
            image.layer.masksToBounds = true
        }
    }
    
    var seleccionaImagen: UIImage? {
        didSet {
            imageSelected.image = seleccionaImagen
        }
    }
    
}
