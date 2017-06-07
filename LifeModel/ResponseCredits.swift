//
//  ResponseCredits.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki

public struct ResponseCredits {
    public let id:Int
    public let cast:[CastModel]
}


// MARK: Decodable
extension ResponseCredits: Decodable {
    public static func decode(_ e: Extractor) throws -> ResponseCredits {
        return try ResponseCredits(
            id: e <| "id",
            cast: e <|| "cast"
        )
    }
}
