//
//  PaymentMethodListTableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class PaymentMethodListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var imgDeleteIcon: UIImageView!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var viewBase: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
