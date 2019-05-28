//
//  ViewController.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 28/05/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var maTableView: UITableView!
    
    var taches : [Tache] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // effaceDonnées()
        creeDonnées()
        litDonnées()
        
        maTableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let tache = taches[indexPath.row]
        cell.textLabel?.text = ("\(tache.quand!)")
        return cell
    }
    
}


