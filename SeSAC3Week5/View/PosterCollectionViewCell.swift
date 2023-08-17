//
//  PosterCollectionViewCell.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/08/16.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
}
