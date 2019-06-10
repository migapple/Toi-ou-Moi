//
//  CoreData.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 07/06/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension ViewController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                print("deleting all contents")
                try context.execute(deleteRequest)
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupData() {
        
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let tache1 = NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context) as! Tache
            tache1.qui = "Ahmed"
            tache1.quand = Date()
            tache1.quoi = "Restaurant"
            tache1.prix = 10
            
            let tache2 = NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context) as! Tache
            tache2.qui = "Michel"
            tache2.quand = Date()
            tache2.quoi = "Courses"
            tache2.prix = 10
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
            
            // taches = [tache1, tache2]
        }
        
    }
    
    func loadData(moisEncours: Int, choix: String) {
        
        let calendar = Calendar.current
        
        let dateDebutDeMois = startOfMonth()
        let dateFinDeMois = endOfMonth()
        
        let dateDebutMoisPrécédent = calendar.date(byAdding: .month, value: moisEncours, to: dateDebutDeMois)!
        let dateDefinMoisPrécédent = calendar.date(byAdding: .month, value: moisEncours, to: dateFinDeMois)!
//        print("\(dateDebutMoisPrécédent)")
//        print("\(dateDefinMoisPrécédent)")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
        
        // On veut tout afficher
        if moisEncours != 99 {
            request.predicate = NSPredicate(format: "quand >= %@ && quand <= %@ && quoi == %@", dateDebutMoisPrécédent as NSDate, dateDefinMoisPrécédent as NSDate, choix)
        } else {
            request.predicate = NSPredicate(format: "quoi == %@", choix)
        }
        
        // On trie par date
        let sort = NSSortDescriptor(key: "quand", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            taches = try context.fetch(request) as! [Tache]
//            if taches.count > 0 {
//                for index in 0 ... taches.count-1 {
//                    print("Lecture des données: \(taches[index].quand!) \(taches[index].qui!) \(taches[index].quoi!) \(taches[index].prix)")
//                }
//            }
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    
    func addData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context)
                
            } catch let err {
                print(err)
            }
        }
    }
    
    //func saveData(objet: NSManagedObject) {
    func saveData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let tache = NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context) as! Tache
                tache.qui = "qui"
                tache.quand = Date()
                tache.quoi = "quoi"
                tache.prix = 123
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            } catch let err {
                print(err)
            }
        }
        
    }
    
}
