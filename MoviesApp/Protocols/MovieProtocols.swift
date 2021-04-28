//
//  MovieProtocols.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 07/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesViewModelDelegate {
    func getMoviesFor(search query: String, at page: Int) -> ()
    func searchBarTextDidChange(_ searchText: String)
    func getMovieDetailsForMovie(with id: String)
    func loadNextPage(for indexPath: IndexPath)
    func didTapToChangeOrientation()
}

protocol MoviesViewDelegate: class {
    func showMovieDetailVC(with viewModel: MovieDetail)
    func showLoaderView()
    func removeLoaderView()
    func showAlertWith(title: String, message: String, buttonTitle: String)
    func showRetryAlert(with handler: @escaping ((UIAlertAction)->Void))
    func showError(with message: String)
    func updateViewElements()
    func reloadView()
}

protocol MovieRepositoryProtocol {
    func getMovieDetailResponse(with id: String, completion: @escaping (Swift.Result<MovieDetail, MoviewError>)->())
    func getMoviesResponse(with queryString: String, _ page: Int, completion: @escaping (Swift.Result<MovieResponseModel, MoviewError>) -> ())
}
