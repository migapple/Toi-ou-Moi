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
            
            self.miseAjourTotal(taches: self.taches)
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
        
        
        let calendar = Calendar.current
   
        
        
        let dateDebutDeMois = startOfMonth()
        let dateFinDeMois = endOfMonth()
        
        let dateDebutMoisPrécédent = calendar.date(byAdding: .month, value: -1, to: dateDebutDeMois)!
        let dateDefinMoisPrécédent = calendar.date(byAdding: .month, value: -1, to: dateFinDeMois)!
        
        // Requette depuis le début du mois
        // request.predicate = NSPredicate(format: "quand > %@ && quand <= %@", dateDebutDeMois as NSDate, dateFinDeMois as NSDate)
        request.predicate = NSPredicate(format: "quand > %@ && quand <= %@", dateDebutMoisPrécédent as NSDate, dateDefinMoisPrécédent as NSDate)

        // On trie par date
        let sort = NSSortDescriptor(key: "quand", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            taches = try context.fetch(request) as! [Tache]
            if taches.count > 0 {
                for index in 0 ... taches.count-1 {
                    print("Lecture des données: \(taches[index].quand!) \(taches[index].qui!) \(taches[index].quoi!) \(taches[index].prix)")
                }
            }
        } catch {
            print("Fetching Failed")
        }
        
        maTableView.reloadData()
        
        miseAjourTotal(taches: taches)
    }
    
    func miseAjourTotal(taches: [Tache]) {
        
        var nbToi:Int = 0
        var nbMoi:Int = 0
        var totalToi:Double = 0
        var totalMoi:Double = 0
        
        if taches.count > 0 {
            for index in 0 ... taches.count-1 {
                let tache = taches[index]
                if tache.qui == "Toi" {
                    nbToi += 1
                    totalToi += tache.prix
                }
                
                if tache.qui == "Moi" {
                    nbMoi += 1
                    totalMoi += tache.prix
                }
            }
        }
        
        let numberFormatter = NumberFormatter()
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

            miseAjourTotal(taches: taches)
            
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
        
        // Get the defaults
        let defaults = UserDefaults.standard
        
        // Set the controls to the default values.
        
        for index in 0...9 {
            let lactivite = "activite\(index)"
            if let activiteSetup = defaults.string(forKey: lactivite) {
                activite[index]  = activiteSetup
            } else {
                activite[index]  = ""
            }
        }
    }
    
    func defaultsChanged(){
        updateDisplayFromDefaults()
    }
    
    func startOfMonth() -> Date {
        let date = Date()
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: currentDateComponents)!.addingTimeInterval(1)
        return startOfMonth
    }
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date {
        let date = Date()
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        return calendar.date(byAdding: months, to: date)!
    }
    
    func dateBySubtractMonths(_ monthsToAdd: Int) -> Date {
        let date = Date()
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func endOfMonth() -> Date {
        // guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
        let plusOneMonthDate = dateByAddingMonths(1)
        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        return endOfMonth!
    }
}




