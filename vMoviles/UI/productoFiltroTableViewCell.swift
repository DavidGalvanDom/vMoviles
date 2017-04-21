//
//  productoFiltroTableViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 4/20/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class productoFiltroTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDetalle: UILabel!
    var seleccionado : Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
