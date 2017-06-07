//
//  ResponseModelSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/2/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble
import Himotoki
@testable import LifeModel

class ResponseModelSpec: QuickSpec {
    override func spec() {
        let json: [String: Any] = [
            "page": 123,
            "results": [movieJSON, movieJSON],
            "total_results":81237681,
            "total_pages":3262
        ]
        
        it("parses JSON data to create a new instance.") {
            let response: ResponsePopular? = try? decodeValue(json)
            expect(response).notTo(beNil())
            expect(response?.page) == 123
            expect(response?.movies.count) == 2
            expect(response?.total_results) == 81237681
            expect(response?.total_pages) == 3262
        }
    }
}
