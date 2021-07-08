//
//  PaymentFirst5TableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class PaymentFirst5TableViewCell: UITableViewCell {
    @IBOutlet weak var btnSamsungPay: UIButton!
    @IBOutlet weak var btnApplePay: UIButton!
    @IBOutlet weak var btnPayBow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnApplePay.layer.borderWidth = 0.5
        self.btnApplePay.layer.borderColor = UIColor.white.cgColor

        self.btnSamsungPay.layer.borderWidth = 0.5
        self.btnSamsungPay.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
