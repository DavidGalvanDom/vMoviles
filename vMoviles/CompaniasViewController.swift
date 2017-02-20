//
//  CompaniasViewController.swift
//  vMoviles
//
//  Created by David Galvan on 2/15/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import UIKit

class CompaniasViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblVendedor: UILabel!
    
    var companias: [Compania] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companias.append( Compania(id: "ozono", descripcion: "Ozono"))
        companias.append( Compania(id: "epi", descripcion: "Episodio"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get database and username:
        let app = UIApplication.shared.delegate as! AppDelegate
        
        self.lblVendedor.text = app.vendedor!

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiaCell", for: indexPath)
        
        let compania = companias[indexPath.row]
        cell.textLabel?.text = compania._descripcion
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.cveCompania = companias[indexPath.row]._id
        app.compania = companias[indexPath.row]._descripcion
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 */
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companias.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companiaCell", for: indexPath)
        
        let compania = companias[indexPath.row]
        cell.textLabel?.text = compania._descripcion
        
        return cell
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
