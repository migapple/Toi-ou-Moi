//
//  CoreData.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 28/05/2019.
//  Copyright © 2019 Michel Garlandat. All rights reserved.
//

import Foundation
import CoreData

var context: NSManagedObjectContext?

var taches : [Tache] = []

func litDonnées() {
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
    do {
        taches = try context?.fetch(request) as! [Tache]
    } catch {
        print("ERREUR DE CHARGEMENT !!")
    }
    
    print("-- lecture des données --")
    print(taches.count)
    
    // Si la base n'est pas vide
    if taches.count > 0 {
        for index in 0..<taches.count {
            let tache = taches[index]
            print("\(tache.quand!)")
        }
    }
}

func effaceDonnées() {
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tache")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest )
    do {
        print("-- Effacement de toutes les données --")
        try context?.execute(deleteRequest)
    } catch {
        print(error.localizedDescription)
    }
}

func creeDonnées() {
    // Donne l'accès à AppDelegate
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tache = Tache(context: context!)
    print("-- Création des données --")
    tache.quand = Date()
    do {
        try context?.save()
    } catch {
        print("erreur sauvegarde CoreData")
    }
}
