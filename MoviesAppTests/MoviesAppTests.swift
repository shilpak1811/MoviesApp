//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Shilpa Kumari on 07/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import XCTest
@testable import MoviesApp

class MoviesAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testMoviesResponseParsing() throws {
        let repository = MockRespository()
        let dict = try XCTUnwrap(repository.getMovieResponseDict())
        let model = try XCTUnwrap(MovieResponseModel(jsonDict: dict))
        XCTAssertTrue(model.totalResults == 7)
        XCTAssertTrue(model.movies.count == 7)
        XCTAssertTrue(model.movies[0].title == "Whit Monday")
        XCTAssertTrue(model.movies[0].poster == "https://m.media-amazon.com/images/M/MV5BMTkxOTQ5MTQ0N15BMl5BanBnXkFtZTgwNjAyMTM2MTE@._V1_SX300.jpg")
        XCTAssertTrue(model.movies[0].year == "1991")
        XCTAssertTrue(model.movies[0].imdbID == "tt0308195")
        
    }
    
    func testMovieDetailParsing() throws {
        let repository = MockRespository()
        let dict = try XCTUnwrap(repository.getMovieDetailDict())
        let model = try XCTUnwrap(MovieDetail(jsonDict: dict))
        XCTAssertTrue(model.poster == "https://m.media-amazon.com/images/M/MV5BNjM0NTc0NzItM2FlYS00YzEwLWE0YmUtNTA2ZWIzODc2OTgxXkEyXkFqcGdeQXVyNTgwNzIyNzg@._V1_SX300.jpg")
        XCTAssertTrue(model.title == "Guardians of the Galaxy Vol. 2")
        XCTAssertTrue(model.releaseDate == "05 May 2017")
        XCTAssertTrue(model.genre == "Action, Adventure, Comedy, Sci-Fi")
        XCTAssertTrue(model.actors == "Chris Pratt, Zoe Saldana, Dave Bautista, Vin Diesel")
        XCTAssertTrue(model.director == "James Gunn")
        XCTAssertTrue(model.plot == "The Guardians struggle to keep together as a team while dealing with their personal family issues, notably Star-Lord's encounter with his father the ambitious celestial being Ego.")
    }
    
    func testMoviesViewModel() {
        let viewModel = MoviesViewModel()
        viewModel.repository = MockRespository()
        let view = MockView(viewModel: viewModel)
        view.viewModel = viewModel
        viewModel.searchBarTextDidChange("whit")
        let expectation = XCTestExpectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        XCTAssertTrue(viewModel.moviesModel!.movies.count == 7)
        XCTAssertTrue(viewModel.hideCollectionView == false)
        XCTAssertTrue(viewModel.hideErrorMessageLabel == true)
    }
    
    func testMoviesOrientaion() {
        let viewModel = MoviesViewModel()
        viewModel.repository = MockRespository()
        let view = MockView(viewModel: viewModel)
        view.viewModel = viewModel
        viewModel.didTapToChangeOrientation()
        XCTAssertTrue(viewModel.orientation == .grid)
        XCTAssertTrue(viewModel.hideCollectionView == false)
        XCTAssertTrue(viewModel.hideErrorMessageLabel == true)
        viewModel.didTapToChangeOrientation()
        XCTAssertTrue(viewModel.orientation == .list)
    }
}

class MockView: MoviesViewDelegate {
    
    var viewModel: MoviesViewModel!
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        viewModel.view = self
    }
    
    func showMovieDetailVC(with viewModel: MovieDetail) {
        
    }
    
    func showLoaderView() {
        
    }
    
    func removeLoaderView() {
        
    }
    
    func showAlertWith(title: String, message: String, buttonTitle: String) {
        
    }
    
    func showRetryAlert(with handler: @escaping ((UIAlertAction) -> Void)) {
        
    }
    
    func showError(with message: String) {
        
    }
    
    func updateViewElements() {
        
    }
    
    func reloadView() {
        
    }
}

class MockRespository: MovieRepositoryProtocol {
    
    func getMovieDetailResponse(with id: String, completion: @escaping (Result<MovieDetail, MoviewError>) -> ()) {
        if let dict = getMovieDetailDict(), let model = MovieDetail(jsonDict: dict) {
            completion(.success(model))
        }
    }
    
    func getMoviesResponse(with queryString: String, _ page: Int, completion: @escaping (Result<MovieResponseModel, MoviewError>) -> ()) {
        if let dict = getMovieResponseDict(), let model = MovieResponseModel(jsonDict: dict) {
            completion(.success(model))
        }
    }
    
    func getMovieResponseDict() -> [String: Any]? {
        let bundle = Bundle(for: MoviesAppTests.self)
        let path = bundle.path(forResource: "MockMoviesResponse", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return dict
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
        }
        return nil
    }
    
    func getMovieDetailDict() -> [String: Any]? {
        let bundle = Bundle(for: MoviesAppTests.self)
        let path = bundle.path(forResource: "MockMovieDetailResponse", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return dict
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
        }
        return nil
    }
}
