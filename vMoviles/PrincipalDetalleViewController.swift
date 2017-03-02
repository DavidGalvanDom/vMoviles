//
//  PrincipalDetalleViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/27/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class PrincipalDetalleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let app = UIApplication.shared.delegate as! AppDelegate
        guard let root = app.window?.rootViewController, let storyboard = root.storyboard else {
            return
        }
        
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        
        let companiasVieModel = storyboard.instantiateViewController(withIdentifier: "sbCompanias")
        
        self.navigationController?.pushViewController(companiasVieModel, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
