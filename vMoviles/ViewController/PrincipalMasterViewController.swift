//
//  PrincipalMasterViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/27/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PrincipalMasterViewController: UIViewController {

    var detailViewController: PrincipalDetalleViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PrincipalDetalleViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
