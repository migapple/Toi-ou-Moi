//
//  TableViewCell.swift
//  test
//
//  Created by Michel Garlandat on 18/01/2017.
//  Copyright © 2017 Michel Garlandat. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var quiLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quoiLabel: UILabel!
    @IBOutlet weak var prixLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func affiche(tache: Tache)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        quiLabel.text = tache.qui
        dateLabel.text = dateFormatter.string(from: tache.quand!)
        quoiLabel.text = tache.quoi
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        let prix = NSString(format:"%.2f", tache.prix) as String
        let prix2 = prix.replacingOccurrences(of: ".", with: ",")
        prixLabel.text = NSString(format:"%.2f", tache.prix) as String
        prixLabel.text = prix2

    }
    
}
