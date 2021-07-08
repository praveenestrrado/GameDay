//
//  NotificationListTableViewCell.swift
//  GameDay
//
//  Created by MAC on 06/01/21.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblHeading2LeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblHeadingLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgDeleteIcon: UIImageView!
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
