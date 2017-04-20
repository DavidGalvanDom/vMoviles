//
//  ProductoInfoViewController.swift
//  vMoviles
//
//  Created by David Galvan on 4/20/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class ProductoInfoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageMin: UIImageView!
    @IBOutlet weak var imageBig: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageInfo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageMin.image = self.imageInfo
        self.imageBig.image = self.imageInfo
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageBig
    }
    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
}
