//
//  API_TheMovieDB.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//



internal struct TheMovieDB {
    
    internal static let genresURL   = "https://api.themoviedb.org/3/genre/movie/list"
    internal static let apiURL      = "https://api.themoviedb.org/3/movie/"
    internal static let imgURL      = "https://image.tmdb.org/t/p/w154"
    internal static let backImgURL  = "https://image.tmdb.org/t/p/w780"
    
    internal static let popular = "popular"
    internal static let credit  = "/credits"
    
    
    internal static var requestParameters: [String: Any] {
        return [
            "api_key": Config.apiKey,
            "language": "en-US"
        ]
    }
}

extension TheMovieDB {
    struct Config {
        static let apiKey = "860fe005d0413dbdf0619239e371b9a0" // Fill with your own API key.
    }
}
