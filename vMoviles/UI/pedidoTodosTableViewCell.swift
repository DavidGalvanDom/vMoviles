//
//  pedidoTodosTableViewCell.swift
//  vMoviles
//
//  Created by David Galvan on 4/24/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class pedidoTodosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFolio: UILabel!
    @IBOutlet weak var lblRenglon: UILabel!
    @IBOutlet weak var lblEstilo: UILabel!
    @IBOutlet weak var lblPares: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblSemana: UILabel!
    @IBOutlet weak var lblFechaCap: UILabel!
    @IBOutlet weak var lblCte: UILabel!
    @IBOutlet weak var lblOrdenCte: UILabel!
    @IBOutlet weak var lblObse: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
