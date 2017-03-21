//
//  PedidoTableViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 3/18/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PedidoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblClave: UILabel!
    @IBOutlet weak var lblTS: UILabel!
    @IBOutlet weak var lblPielColor: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblPares: UILabel!
    @IBOutlet weak var lblPK: UILabel!
    @IBOutlet weak var lblInter: UILabel!
    @IBOutlet weak var lblSemana: UILabel!
    @IBOutlet weak var lblSemanaCli: UILabel!
    @IBOutlet weak var lblRenglon: UILabel!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var lblc1: UILabel!
    @IBOutlet weak var lblc2: UILabel!
    @IBOutlet weak var lblc3: UILabel!
    @IBOutlet weak var lblc4: UILabel!
    @IBOutlet weak var lblc5: UILabel!
    @IBOutlet weak var lblc6: UILabel!
    @IBOutlet weak var lblc7: UILabel!
    @IBOutlet weak var lblc8: UILabel!
    @IBOutlet weak var lblc9: UILabel!
    @IBOutlet weak var lblc10: UILabel!
    @IBOutlet weak var lblc11: UILabel!
    @IBOutlet weak var lblc12: UILabel!
    @IBOutlet weak var lblc13: UILabel!
    @IBOutlet weak var lblc14: UILabel!
    @IBOutlet weak var lblc15: UILabel!
    @IBOutlet weak var lblp1: UILabel!
    @IBOutlet weak var lblp2: UILabel!
    @IBOutlet weak var lblp3: UILabel!
    @IBOutlet weak var lblp4: UILabel!
    @IBOutlet weak var lblp5: UILabel!
    @IBOutlet weak var lblp6: UILabel!
    @IBOutlet weak var lblp7: UILabel!
    @IBOutlet weak var lblp8: UILabel!
    @IBOutlet weak var lblp9: UILabel!
    @IBOutlet weak var lblp10: UILabel!
    @IBOutlet weak var lblp11: UILabel!
    @IBOutlet weak var lblp12: UILabel!
    @IBOutlet weak var lblp13: UILabel!
    @IBOutlet weak var lblp14: UILabel!
    @IBOutlet weak var lblp15: UILabel!
    
    var productoImageAction: (() -> ())?
    
    var productoImage: UIImage? {
        didSet {
            btnImage.setImage(productoImage, for: .normal)
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
