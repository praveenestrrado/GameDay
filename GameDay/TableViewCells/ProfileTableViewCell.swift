//
//  ProfileTableViewCell.swift
//  GameDay
//
//  Created by MAC on 21/12/20.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProfileItem: UILabel!
    @IBOutlet weak var imgProfileIcons: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
