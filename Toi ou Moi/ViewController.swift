//
//  ViewController.swift
//  Toi ou Moi
//  Utilisé sur l'iphone
//  Created by Michel Garlandat on 18/05/2019.
//  Copyright © 2017 Michel Garlandat. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var taches : [Tache] = []
    
    @IBOutlet weak var nbToiLabel: UILabel!
    @IBOutlet weak var totToiLabel: UILabel!
    @IBOutlet weak var nbMoiLabel: UILabel!
    @IBOutlet weak var totMoiLabel: UILabel!
    
    @IBOutlet weak var maTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cleanCoreData()
    }
    
    @IBAction func trashButton(_ sender: UIBarButtonItem) {
        cleanCoreData()
        let alertController:UIAlertController = UIAlertController(title: "Supression des données !", message: "Voulez-vous vraiment supprimer toutes les données ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Non, annuler", style: .cancel) { action -> Void in
            // don't do anything
        }
        
        let nextAction = UIAlertAction(title: "Oui", style: .default) { action -> Void in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                self.taches = try context.fetch(Tache.fetchRequest())
            } catch {
                print("Fetching Failed")
            }
            
            self.maTableView.reloadData()
            
            self.miseAjourTotal()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(nextAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Récupération des settings
        
        func registerSettings() {
            let appDefaults = [String:AnyObject]()
            UserDefaults.standard.register(defaults: appDefaults)
        }
        
        registerSettings()
        NotificationCenter.default.addObserver(self, selector: #selector (ViewController.updateDisplayFromDefaults), name: UserDefaults.didChangeNotification, object: nil)
        
        // Core Data Récupération des données
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // On fait la requette
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
        
        // On Calcule le debut du mois
        // on contruit le début du mois
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        let month = components.month
        let year = components.year
        
        let debutDuMois = "01/\(month!)/\(year!) 00:00"
        let laDate: Date
        laDate = dateFormatter.date(from: debutDuMois)!
    
        // Requette depuis le début du mois
        request.predicate = NSPredicate(format: "quand > %@", laDate as NSDate)
        
        // On trie par date
        let sort = NSSortDescriptor(key: "quand", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            taches = try context.fetch(request) as! [Tache]
            if taches.count > 0 {
                for i in 0 ... taches.count-1 {
                    print("Lecture des données: \(taches[i].quand!) \(taches[i].qui!) \(taches[i].quoi!) \(taches[i].prix)")
                }
            }
        } catch {
            print("Fetching Failed")
        }
        
        maTableView.reloadData()
        
        miseAjourTotal()
    }
    
    func miseAjourTotal() {
        var nbToi:Int = 0
        var nbMoi:Int = 0
        var totalToi:Double = 0
        var totalMoi:Double = 0
        //var i:Int = 0
        //var j:Int = 0

        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            taches = try context.fetch(Tache.fetchRequest())
            if taches.count > 0 {
                for i in 0..<taches.count {

                    if taches[i].qui == "Toi" {
                        totalToi += taches[i].prix
                        nbToi += 1
                    }

                    if taches[i].qui == "Moi" {
                        totalMoi += taches[i].prix
                        nbMoi += 1
                    }
                }
            }
        } catch {
            print("Fetching Failed")
        }

        let numberFormatter = NumberFormatter()
        //numberFormatter.numberStyle = .currency

        // numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        numberFormatter.locale = Locale(identifier: "fr_FR")


        nbToiLabel.text = "\(nbToi)"
        let totToi1 = NSString(format:"%.2f€", totalToi) as String
        let totToi2 = totToi1.replacingOccurrences(of: ".", with: ",")
        totToiLabel.text = totToi2
        nbMoiLabel.text = "\(nbMoi)"
        let totMoi1 = NSString(format:"%.2f€", totalMoi) as String
        let totMoi2 = totMoi1.replacingOccurrences(of: ".", with: ",")
        totMoiLabel.text = totMoi2
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - Gestion de la TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Calcule le nombre de lignes à afficher
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taches.count
    }
    
    // affiche la cellule
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell
        let tache = taches[indexPath.row]
        cell.affiche(tache: tache)
        return cell
    }
    
    // Suppression d'une ligne
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let tache = taches[indexPath.row]
            context.delete(tache)


            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            do {
                taches = try context.fetch(Tache.fetchRequest())
            } catch {
                print("Fetching Failed")
            }

            miseAjourTotal()
            maTableView.reloadData()
        }
    }

    // MARK - Gestion Setup
    
    ///delete all the data in core data
    func cleanCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let fetchRequest:NSFetchRequest<Tache> = Tache.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all contents")
            try context.execute(deleteRequest)
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        //NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @objc func updateDisplayFromDefaults(){
        
        
        //Get the defaults
        // let defaults = UserDefaults.standard
        
        //Set the controls to the default values.
        
//        if let activiteSetup = defaults.string(forKey: "activite_0") {
//            activite[0]  = activiteSetup
//        } else {
//            activite[0]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_1") {
//            activite[1]  = activiteSetup
//        } else {
//            activite[1]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_2") {
//            activite[2]  = activiteSetup
//        } else {
//            activite[2]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_3") {
//            activite[3]  = activiteSetup
//        } else {
//            activite[3]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_4") {
//            activite[4]  = activiteSetup
//        } else {
//            activite[4]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_5") {
//            activite[5]  = activiteSetup
//        } else {
//            activite[5]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_6") {
//            activite[6]  = activiteSetup
//        } else {
//            activite[6]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_7") {
//            activite[7]  = activiteSetup
//        } else {
//            activite[7]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_8") {
//            activite[8]  = activiteSetup
//        } else {
//            activite[8]  = ""
//        }
//
//        if let activiteSetup = defaults.string(forKey: "activite_9") {
//            activite[9]  = activiteSetup
//        } else {
//            activite[9]  = ""
//        }
        
    }
    
    func defaultsChanged(){
        updateDisplayFromDefaults()
    }
    
    
}

