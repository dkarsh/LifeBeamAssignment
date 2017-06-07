//
//  ResponseGenres.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki

public struct ResponseGenres {
    public let genres:[GenreModel]
}


// MARK: Decodable
extension ResponseGenres: Decodable {
    public static func decode(_ e: Extractor) throws -> ResponseGenres {
        return try ResponseGenres(
            genres: e <|| "genres"
        )
    }
}
