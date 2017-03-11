//
//  ProductoTableViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 3/5/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {

    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var lblDetalle: UILabel!
    
    var productoImage: UIImage? {
        didSet {
            imageButton.setImage(productoImage, for: .normal)
        }
    }
    
    var productoImageAction: (() -> ())?
    
    @IBAction func imageButtonAction(sender: AnyObject) {
        if let action = productoImageAction {
            action()
        }
    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
