//
//  lstPedidosTableViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 4/3/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class lstPedidosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFolio: UILabel!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblFechaCreacion: UILabel!
    @IBOutlet weak var lblPares: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblEstatus: UILabel!
    @IBOutlet weak var lblFechaCliente: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
