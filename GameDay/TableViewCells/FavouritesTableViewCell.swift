//
//  FavouritesTableViewCell.swift
//  GameDay
//
//  Created by MAC on 21/12/20.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBookingInfo: UILabel!
    
    @IBOutlet var btnSelection: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var btnBookingNow: UIButton!
    @IBOutlet weak var lblPitchInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnBookingNow.layer.borderColor = UIColor.lightGray.cgColor
        btnBookingNow.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
