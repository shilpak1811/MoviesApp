//
//  ViewController.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 05/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import UIKit

enum Orientation: String {
    case list = "Show in Grid"
    case grid = "Show in List"
}

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var changeOrientationButton: UIButton!
    @IBOutlet weak private var errorMessageLabel: UILabel!
    
    private var loaderView: LoaderView?
    private var viewModel: MoviesViewModel = MoviesViewModel()
    private var size: CGSize = .zero
    private let gridCellId = "MoviewGridCollectionViewCell"
    private let listCellId = "MoviewListCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.view = self
        searchBar.delegate = self
        registerCells()
        collectionView.showsVerticalScrollIndicator = false
        updateViewElements()
    }
    
    private func registerCells() {
        let gridCellNib = UINib(nibName: gridCellId, bundle: nil)
        collectionView.register(gridCellNib, forCellWithReuseIdentifier: gridCellId)
        
        let listCellNib = UINib(nibName: listCellId, bundle: nil)
        collectionView.register(listCellNib, forCellWithReuseIdentifier: listCellId)
    }
    
    @IBAction func changeOrientationTapped(_ sender: UIButton) {
        viewModel.didTapToChangeOrientation()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarTextDidChange(searchText)
    }
}

extension ViewController: MoviesViewDelegate {
    
    func showMovieDetailVC(with viewModel: MovieDetail) {
        guard let moviewDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        moviewDetailVC.viewModel = viewModel
        self.navigationController?.pushViewController(moviewDetailVC, animated: true)
    }
    
    func showLoaderView() {
        let loader = LoaderView(frame: view.bounds)
        self.loaderView = loader
        loader.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.view.addSubview(loader)
    }
    
    func removeLoaderView() {
        guard let loader = loaderView else { return }
        loader.removeFromSuperview()
    }
    
    func showAlertWith(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRetryAlert(with handler: @escaping ((UIAlertAction)->Void)) {
        let alert = UIAlertController(title: "", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(with message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = viewModel.hideErrorMessageLabel
    }
    
    func updateViewElements() {
        collectionView.isHidden = viewModel.hideCollectionView
        changeOrientationButton.isHidden = viewModel.hideCollectionView
        errorMessageLabel.isHidden = viewModel.hideErrorMessageLabel
        changeOrientationButton.setTitle(viewModel.orientation.rawValue, for: .normal)
    }
    
    func reloadView() {
        updateViewElements()
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesModel?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.loadNextPage(for: indexPath)
        switch viewModel.orientation {
        case .grid:
            return movieGridCollectionViewCell(collectionView, at: indexPath)
        case .list:
            return movieListCollectionViewCell(collectionView, at: indexPath)
        }
    }
    
    private func movieGridCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> MoviewGridCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as! MoviewGridCollectionViewCell
        cell.viewModel = viewModel.moviesModel!.movies[indexPath.item]
        return cell
    }
    
    private func movieListCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> MoviewListCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! MoviewListCollectionViewCell
        cell.viewModel = viewModel.moviesModel!.movies[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.orientation {
        case .grid: size = CGSize(width: collectionView.frame.size.width/2-20, height: 250)
        case .list: size = CGSize(width: collectionView.frame.size.width-32, height: 100)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imdb = viewModel.moviesModel?.movies[indexPath.item].imdbID else { return }
        viewModel.getMovieDetailsForMovie(with: imdb)
    }
}

