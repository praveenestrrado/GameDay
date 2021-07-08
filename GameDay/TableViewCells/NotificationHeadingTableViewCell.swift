//
//  NotificationHeadingTableViewCell.swift
//  GameDay
//
//  Created by MAC on 06/01/21.
//

import UIKit

class NotificationHeadingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblHeading4: UILabel!
    @IBOutlet weak var lblHeading3: UILabel!
    @IBOutlet weak var lblHeading2: UILabel!
    @IBOutlet weak var lblHeading1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
