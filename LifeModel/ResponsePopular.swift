//
//  ResponseModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/2/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki

public struct ResponsePopular {
    public let page:UInt32
    public let movies:[MovieModel]
    public let total_results:UInt64
    public let total_pages:UInt32
}


// MARK: Decodable
extension ResponsePopular: Decodable {
    public static func decode(_ e: Extractor) throws -> ResponsePopular {
        return try ResponsePopular(
            page: e <| "page",
            movies: e <|| "results",
            total_results: e <| "total_results",
            total_pages: e <| "total_pages"
        )
    }
}
