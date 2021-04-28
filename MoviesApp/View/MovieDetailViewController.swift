//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 06/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import UIKit

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak private var poster: UIImageView!
    @IBOutlet weak private var movieTitle: UILabel!
    @IBOutlet weak private var released: UILabel!
    @IBOutlet weak private var genre: UILabel!
    @IBOutlet weak private var director: UILabel!
    @IBOutlet weak private var actors: UILabel!
    @IBOutlet weak private var plot: UILabel!
    
    var viewModel: MovieDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        if let imageUrl = URL(string: viewModel.poster) {
            poster.af.setImage(withURL: imageUrl)
        }
        movieTitle.text = viewModel.title
        released.text = viewModel.releaseDate
        genre.text = viewModel.genre
        director.text = viewModel.director
        actors.text = viewModel.actors
        plot.text = viewModel.plot
    }
}
