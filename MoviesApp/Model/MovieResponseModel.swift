//
//  MovieResponseModel.swift
//  MoviesApp
//
//  Created by Shilpa Kumari on 06/04/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import Foundation

struct MovieResponseModel {
    var movies: [Movie]
    let totalResults: Int
    init?(jsonDict: [String: Any]) {
        if let searchResponse = jsonDict["Search"] as? [[String: Any]] {
            movies = searchResponse.compactMap({ (dict) -> Movie? in
                let movie = Movie(jsonDict: dict)
                return movie
            })
        } else {
            movies = []
        }
        let count = jsonDict["totalResults"] as? String ?? ""
        totalResults =  Int(count) ?? 0
    }
}

struct Movie {
    let poster: String
    let title: String
    let type: String
    let year: String
    let imdbID: String
    
    init?(jsonDict: [String: Any]) {
        guard let poster = jsonDict["Poster"] as? String,
            let title = jsonDict["Title"] as? String,
            let type = jsonDict["Type"] as? String,
            let year = jsonDict["Year"] as? String,
            let imdbId = jsonDict["imdbID"] as? String
            else { return nil }
        
        self.poster = poster
        self.title = title
        self.type = type
        self.year = year
        self.imdbID = imdbId
    }
}

struct MovieDetail {
    let title: String
    let releaseDate: String
    let genre: String
    let director: String
    let actors: String
    let plot: String
    let poster: String
    
    init?(jsonDict: [String: Any]) {
        guard let title = jsonDict["Title"] as? String,
            let released = jsonDict["Released"] as? String,
            let genre = jsonDict["Genre"] as? String,
            let director = jsonDict["Director"] as? String,
            let actors = jsonDict["Actors"] as? String,
            let plot = jsonDict["Plot"] as? String,
            let poster = jsonDict["Poster"] as? String
            else { return nil }
        
        self.title = title
        self.releaseDate = released
        self.genre = genre
        self.director = director
        self.actors = actors
        self.plot = plot
        self.poster = poster
    }
}


