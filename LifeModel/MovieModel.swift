//
//  MovieModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/2/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki

public struct MovieModel {
    
    public let poster_path: String?
    public let adult:Bool?
    public let overview:String?
    
    public let release_date:String?
    public let genre_ids:[UInt16]?
    public let id: UInt64
    public let original_title:String?
    public let original_language:String?

    public let title:String?
    public let backdrop_path:String?
    public let popularity:Double?
    public let vote_count:Int64?

    public let video:Bool?
    public let vote_average:Double?
    
}

// MARK: Decodable

extension MovieModel: Decodable {
    public static func decode(_ e: Extractor) throws -> MovieModel {
        return try MovieModel(
            
            poster_path: e <|? "poster_path",
            adult: e <|? "adult",
            overview: e <|? "overview",

            release_date: e <|? "release_date",
            genre_ids: e <||? "genre_ids",
            id: e <| "id",
            original_title: e <|? "original_title",
            original_language: e <|? "original_language",

            title: e <| "title",
            backdrop_path: e <|? "backdrop_path",
            popularity: e <|? "popularity",
            vote_count: e <|? "vote_count",
            
            video: e <|? "video",
            vote_average: e <|? "vote_average"
        )
    }
}



