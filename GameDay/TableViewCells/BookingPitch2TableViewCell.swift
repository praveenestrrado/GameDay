//
//  BookingPitch2TableViewCell.swift
//  GameDay
//
//  Created by MAC on 24/12/20.
//

import UIKit

class BookingPitch2TableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var PitchdetailsCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
            self.PitchdetailsCollectionView.delegate = self
            self.PitchdetailsCollectionView.dataSource = self
        self.PitchdetailsCollectionView.reloadData()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func registerCell() {
        PitchdetailsCollectionView.register(BookPitch1CollectionViewCell.self, forCellWithReuseIdentifier: "BookPitch1CollectionViewCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PitchdetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "BookPitch1CollectionViewCell", for: indexPath) as! BookPitch1CollectionViewCell
//        cell.lblPitchFacilities.text = "12132"
        return cell
    }

 
}
