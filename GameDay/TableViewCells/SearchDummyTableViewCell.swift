//
//  SearchDummyTableViewCell.swift
//  GameDay
//
//  Created by MAC on 22/01/21.
//

import UIKit

class SearchDummyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPitch: UIImageView!
    @IBOutlet weak var lblPitchName: UILabel!
    @IBOutlet weak var lblPitchDetails: UILabel!
    @IBOutlet weak var lblPitchAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnBookNow.layer.cornerRadius = 17.5
        btnBookNow.layer.borderColor = UIColor.lightGray.cgColor
        btnBookNow.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
