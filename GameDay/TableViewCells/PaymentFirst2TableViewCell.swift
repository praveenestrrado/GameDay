//
//  PaymentFirst2TableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class PaymentFirst2TableViewCell: UITableViewCell {

   
    @IBOutlet weak var btnVisa: UIButton!
    @IBOutlet weak var btnMasterCard: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnVisa.layer.borderWidth = 0.5
             self.btnVisa.layer.borderColor = UIColor.white.cgColor
     
             self.btnMasterCard.layer.borderWidth = 0.5
             self.btnMasterCard.layer.borderColor = UIColor.white.cgColor
     
          
             
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
