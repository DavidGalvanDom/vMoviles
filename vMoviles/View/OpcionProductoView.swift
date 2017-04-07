//
//  OpcionProductoView.swift
//  vMoviles
//
//  Created by David Galvan on 4/3/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class OpcionProductoView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblOpcion: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.scrollView.delegate = self
        FormatoLabel()
    }
    
    func FormatoLabel ()
    {
        lblPrecio.layer.borderWidth = 0.1
        lblPrecio.layer.cornerRadius = 6
        lblColor.layer.borderWidth = 0.1
        lblColor.layer.cornerRadius = 6
        lblOpcion.layer.borderWidth = 0.1
        lblOpcion.layer.cornerRadius = 6
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
