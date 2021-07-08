//
//  RecentBookingsTableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class RecentBookingsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPaymentTime: UILabel!
    @IBOutlet weak var lblPaymentData: UILabel!
    @IBOutlet weak var lblPaymentRecievedFor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
