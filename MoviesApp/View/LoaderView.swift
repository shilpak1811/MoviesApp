//
//  LoaderView.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 06/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import Foundation
import UIKit

final class LoaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        activityIndicator.style = .large
        self.addSubview(activityIndicator)
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 200).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200).isActive = true
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
