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
    
    
    var PrixText : String {
        get {
             return String(format: "%2.f", self)
        }
        set {
           
        }
    }
    
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
  
    func litDonnées() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
        do {
            taches = try context.fetch(request) as! [Tache]
        } catch {
            print("ERREUR DE CHARGEMENT !!")
        }
        
        print("-- lecture des données --")
        print(taches.count)
        
        // Si la base n'est pas vide
        if taches.count > 0 {
            for index in 0...taches.count - 1 {
                let tache = taches[index]
                print("\(tache.quand!)")
            }
        }
    }
    
    func effaceDonnées() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest )
        do {
            print("-- Effacement de toutes les données --")
            try context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func creeDonnées() {
        // Donne l'accès à AppDelegate
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let tache = Tache(context: context)
        print("-- Création des données --")
        tache.quand = Date()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}


