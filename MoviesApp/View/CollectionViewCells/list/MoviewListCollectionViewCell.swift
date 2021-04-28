//
//  MoviewListCollectionViewCell.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 05/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import UIKit

final class MoviewListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var poster: UIImageView!
    @IBOutlet weak private var year: UILabel!
    @IBOutlet weak private var title: UILabel!
    
    var viewModel: Movie! {
        didSet {
            title.text = viewModel.title
            year.text = viewModel.year
            if let imageUrl = URL(string: viewModel.poster) {
                poster.af.setImage(withURL: imageUrl)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        year.text = ""
        poster.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
