//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 06/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import Foundation
import Alamofire

let defaultErrorMessage: String = "Something went wrong"

enum MoviewError: Error {
    case apiFailure
    case invalid
    case errorWithMessage(String)
}

struct MovieEndpoints {
    
    static let baseUrl = "http://www.omdbapi.com/"
    static let apikey = "54b806f5"
    
    static func getMoviesRsponseUrl(from queryString: String, and page: Int) -> String {
        return "\(baseUrl)?apikey=\(apikey)&s=\(queryString)&page=\(page)"
    }
    
    static func getMovieDetailUrl(from imdbId: String) -> String {
        return "\(baseUrl)?i=\(imdbId)&apikey=\(apikey)"
    }
}


class MoviesRepository: MovieRepositoryProtocol {
    
     func getMoviesResponse(with queryString: String, _ page: Int, completion: @escaping (Swift.Result<MovieResponseModel, MoviewError>) -> ()) {
        let url = MovieEndpoints.getMoviesRsponseUrl(from: queryString, and: page)
        let request = AF.request(url) 
        request.responseJSON { (response) in
            switch response.result {
            case .success(let model):
                if let dict = model as? [String: Any], let dictResponse = dict["Response"] as? String {
                    if dictResponse == "True" {
                        if let movieResponseModel = MovieResponseModel(jsonDict: dict) {
                            completion(.success(movieResponseModel))
                        } else {
                            completion(.failure(.invalid))
                        }
                    } else if dictResponse == "False" {
                        completion(.failure(.errorWithMessage(dict["Error"] as? String ?? defaultErrorMessage)))
                    } else {
                        completion(.failure(.invalid))
                    }
                } else {
                    completion(.failure(.invalid))
                }
            case .failure(_):
                completion(.failure(.apiFailure))
            }
        }
    }
    
     func getMovieDetailResponse(with id: String, completion: @escaping (Swift.Result<MovieDetail, MoviewError>)->()) {
        let url = MovieEndpoints.getMovieDetailUrl(from: id)
        let request = AF.request(url)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let model):
                if let dict = model as? [String: Any], let dictResponse = dict["Response"] as? String {
                    if dictResponse == "True" {
                        if let movieDetailResponse = MovieDetail(jsonDict: dict) {
                            completion(.success(movieDetailResponse))
                        } else {
                            completion(.failure(.invalid))
                        }
                    } else if dictResponse == "False" {
                        completion(.failure(.errorWithMessage(dict["Error"] as? String ?? defaultErrorMessage)))
                    } else {
                        completion(.failure(.invalid))
                    }
                } else {
                    completion(.failure(.invalid))
                }
            case .failure(_):
                completion(.failure(.apiFailure))
            }
        }
    }
    
     func getMovieImdbIdFromDeeplink(with url: URL, completion: @escaping (_ id: String?)->()) {
        let request = AF.request(url)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let model):
                if let dict = model as? [String: Any], let dictResponse = dict["Response"] as? String {
                    if dictResponse == "True", let id = dict["imdbID"] as? String {
                        completion(id)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(_): 
                completion(nil)
            }
        }
    }
}
