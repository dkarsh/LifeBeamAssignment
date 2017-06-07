//
//  GenreModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki



public struct GenreModel {
    public let id: Int
    public let name:String
}

// MARK: Decodable

extension GenreModel: Decodable {
    public static func decode(_ e: Extractor) throws -> GenreModel {
        return try GenreModel(
            id: e <| "id",
            name: e <| "name"
    )
    }
}

