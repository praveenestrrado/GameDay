//
//  PitchListTableViewCell.swift
//  GameDay
//
//  Created by MAC on 22/12/20.
//

import UIKit

class PitchListTableViewCell: UITableViewCell {

    @IBOutlet var imgOffIcon: UIImageView!
    @IBOutlet var lblOff: UILabel!
    @IBOutlet var lblOffValue: UILabel!
    @IBOutlet weak var imgPitch: UIImageView!
    @IBOutlet weak var lblPitchName: UILabel!
    @IBOutlet weak var lblPitchDetails: UILabel!
    @IBOutlet weak var lblPitchAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet var btnFavoritesPitchList: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btnBookNow.layer.cornerRadius = 17.5
//        btnBookNow.layer.borderColor = UIColor.lightGray.cgColor
//        btnBookNow.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
