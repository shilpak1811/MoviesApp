//
//  MoviewGridCollectionViewCell.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 05/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import UIKit
import AlamofireImage

final class MoviewGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var poster: UIImageView!
    
    var viewModel: Movie! {
        didSet {
            title.text = viewModel.title
            if let imageUrl = URL(string: viewModel.poster) {
                poster.af.setImage(withURL: imageUrl)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        poster.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
