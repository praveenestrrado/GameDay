//
//  TimeCollectionViewCell.swift
//  GameDay
//
//  Created by MAC on 26/12/20.
//

import UIKit
protocol selectCollectionCellDelegate {

 func selectCell(cell : UICollectionViewCell )

}


 

class TimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnTime: UIButton!
}
