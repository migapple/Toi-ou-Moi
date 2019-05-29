//
//  AjoutViewController.swift
//  Toi ou Moi
//
//  Created by Michel Garlandat on 18/01/2017.
//  Copyright © 2017 Michel Garlandat. All rights reserved.
//

import UIKit
import CoreData
var activite = ["Restau", "Ciné","Courses","","","","","","",""]

class AjoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dateLabelField: UILabel!
    @IBOutlet weak var prixTextField: UITextField!
    @IBOutlet weak var quoiLabelField: UILabel!
    @IBOutlet weak var monDatePicker: UIDatePicker!
    @IBOutlet weak var activitePicker: UIPickerView!
    @IBOutlet weak var quiSegmentedControl: UISegmentedControl!
    
    var choix = "Restau"
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var qui = "Toi"
    let numberFormatter = NumberFormatter()
    
    
    @IBAction func modiferDatePicker(_ sender: Any) {
        dateLabelField.text = dateFormatter.string(for: monDatePicker.date)
    }
    
    @IBAction func quiSegmentedControlAction(_ sender: Any) {
        switch quiSegmentedControl.selectedSegmentIndex
        {
        case 0:
            qui = "Toi";
        case 1:
            qui = "Moi";
        default:
            break;
        }
    }
    
    @IBAction func cacheClavier(_ sender: Any) {
        prixTextField.resignFirstResponder()
    }
    
    
    @IBAction func ajouterAction(_ sender: Any) {
        // Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // ListePersonnes.append(Personne.init(nom: qui, date: dateTextField.text!, quoi: quoiTextField.text!, prix: (prix as NSString).doubleValue))
        let nouvelleActivite = NSEntityDescription.insertNewObject(forEntityName: "Tache", into: context)
        if prixTextField.text == "" {
            prixTextField.text = "0"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let maDate:Date = dateFormatter.date(from: dateLabelField.text!)!
        numberFormatter.locale = Locale(identifier: "fr_FR")
        let prixDouble = numberFormatter.number(from: prixTextField.text!) as! Double
        sauvegarde(objet: nouvelleActivite, nom: qui, date: maDate, quoi: quoiLabelField.text!, prix: prixDouble)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func annulerAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monDatePicker.locale = Locale(identifier: "fr_FR")
        prixTextField.becomeFirstResponder()
        
        afficheDate()
        quoiLabelField.text = choix
        // on donne la main à la vue sur activitePicker
        //activitePicker.delegate = self
        
    }
    
    // MARK - Gestion Activites Picker View
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activite[row]
        
    }
    
    // returns the number of 'columns' to display.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activite.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choix = activite[row]
        quoiLabelField.text = choix
    }
    
    
    func afficheDate() {
        // affiche la date du jour et le met dans le champ dateTextField
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        // dateFormatter.dateFormat = "EEE dd/MM/yy HH:mm"
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        dateLabelField.text = dateFormatter.string(from: monDatePicker.date)
        
    }
    
    func sauvegarde(objet:NSManagedObject, nom: String, date: Date, quoi: String, prix: Double) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    
        // definir la valeur de chaque attribut
        objet.setValue(nom, forKey: "qui")
        objet.setValue(date, forKey: "quand")
        objet.setValue(quoi, forKey: "quoi")
        objet.setValue(prix, forKey: "prix")
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
