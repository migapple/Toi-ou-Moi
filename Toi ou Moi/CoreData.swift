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
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "quand", ascending: true)]
            do {
                taches = try context.fetch(Tache.fetchRequest())
            } catch let err {
                print(err)
            }
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
