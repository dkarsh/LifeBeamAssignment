//
//  CastModel.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/5/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Himotoki

public struct  CastModel {
    
    public let cast_id: Int?
    public let character:String?
    public let id:UInt64
    public let name:String?
}

extension CastModel: Decodable {
    public static func decode(_ e: Extractor) throws -> CastModel {
        return try CastModel(
            cast_id: e <| "cast_id",
            character: e <|? "character",
            id: e <| "id",
            name: e <| "name"
        )
    }
}
