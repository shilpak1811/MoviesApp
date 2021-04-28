//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 07/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import Foundation

final class MoviesViewModel: MoviesViewModelDelegate {
    
    var moviesModel: MovieResponseModel?
    weak var view: MoviesViewDelegate?
    var repository: MovieRepositoryProtocol = MoviesRepository()
    
    private let debouncer = Debouncer(timeInterval: 0.3)
    private var currentPage = 1
    private var searchText = ""
    
    var hideCollectionView = true
    var hideErrorMessageLabel = true
    var orientation: Orientation = .list
    
    private func reset() {
        currentPage = 1
        hideCollectionView = true
        hideErrorMessageLabel = true
    }
    
    func searchBarTextDidChange(_ searchText: String) {
        view?.removeLoaderView()
        reset()
        guard !searchText.isEmpty else {
            view?.updateViewElements()
            return
        }
        self.searchText = searchText
        debouncer.renewInterval()
        debouncer.handler = { [weak self] in
            self?.getMoviesFor(search: searchText, at: 1)
        }
    }
    
    func getMoviesFor(search query: String, at page: Int) {
        view?.showLoaderView()
        repository.getMoviesResponse(with: query, page) { [weak self] (response) in
            switch response {
            case .success(let model):
                self?.updateMoviesModel(model, for: page)
                self?.hideCollectionView = false
                self?.hideErrorMessageLabel = true
                self?.view?.reloadView()
                self?.view?.removeLoaderView()
            case .failure(let error):
                self?.moviesModel = nil
                self?.reset()
                self?.view?.reloadView()
                self?.view?.removeLoaderView()
                self?.handleMoviesResponseErrorWith(error, search: query, at: page)
            }
        }
    }
    
    private func updateMoviesModel(_ model: MovieResponseModel, for page: Int) {
        if page>1 {
            moviesModel?.movies.append(contentsOf: model.movies)
        } else {
            moviesModel = model
        }
    }
    
    private func handleMoviesResponseErrorWith(_ error: MoviewError, search query: String, at page: Int) {
        switch error {
        case .invalid:
            view?.showAlertWith(title: "Error", message: defaultErrorMessage, buttonTitle: "OK")
        case .errorWithMessage(let msg):
            hideErrorMessageLabel = false
            view?.showError(with: msg)
        case .apiFailure:
            view?.showRetryAlert(with: { [weak self] (alert) in
                self?.getMoviesFor(search: query, at: page)
            })
        }
    }
    
    func getMovieDetailsForMovie(with id: String) {
        view?.showLoaderView()
        repository.getMovieDetailResponse(with: id) { [weak self] (response) in
            self?.view?.removeLoaderView()
            switch response {
            case .success(let model):
                self?.view?.showMovieDetailVC(with: model)
            case .failure(let error):
                self?.handleMoviewDetailErrorWith(error, with: id)
            }
        }
    }
    
    private func handleMoviewDetailErrorWith(_ error: MoviewError, with id: String) {
        switch error {
        case .invalid:
            view?.showAlertWith(title: "Error", message: defaultErrorMessage, buttonTitle: "OK")
        case .errorWithMessage(let msg):
            view?.showAlertWith(title: "Error", message: msg, buttonTitle: "OK")
        case .apiFailure:
            view?.showRetryAlert(with: { [weak self] (alert) in
                self?.getMovieDetailsForMovie(with: id)
            })
        }
    }
    
    func loadNextPage(for indexPath: IndexPath) {
        guard let movieCount = moviesModel?.movies.count, let totalMovieCount = moviesModel?.totalResults, indexPath.row == movieCount-1 else { return }
        if totalMovieCount > movieCount { // more items to fetch
            currentPage = 1+currentPage
            getMoviesFor(search: searchText, at: currentPage)
        }
    }
    
    func didTapToChangeOrientation() {
        switch orientation {
        case .grid:
            orientation = .list
        case .list:
            orientation = .grid
        }
        hideCollectionView = false
        hideErrorMessageLabel = true
        view?.reloadView()
    }
}
