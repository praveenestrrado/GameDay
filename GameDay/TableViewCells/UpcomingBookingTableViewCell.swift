//
//  UpcomingBookingTableViewCell.swift
//  GameDay
//
//  Created by MAC on 05/01/21.
//

import UIKit

class UpcomingBookingTableViewCell: UITableViewCell {

    @IBOutlet var btnCellSelection: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var lblHeading2: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
