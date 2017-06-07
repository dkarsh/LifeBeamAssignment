//
//  MovieModelSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/2/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble
import Himotoki
@testable import LifeModel

class MovieModelSpec: QuickSpec {
    override func spec() {
        it("parses JSON data to create a new instance.") {
            let movie: MovieModel? = try? decodeValue(movieJSON)
            
            expect(movie).notTo(beNil())
            expect(movie?.id) == 166426
            expect(movie?.poster_path) == "/xbpSDU3p7YUGlu9Mr6Egg2Vweto.jpg"
            expect(movie?.adult) == false
            expect(movie?.overview) == "Captain Jack Sparrow is pursued by an old rival, Captain Salazar, who along with his crew of ghost pirates has escaped from the Devil's Triangle, and is determined to kill every pirate at sea. Jack seeks the Trident of Poseidon, a powerful artifact that grants its possessor total control over the seas, in order to defeat Salazar."
            expect(movie?.release_date) == "2017-05-23"
            expect(movie?.genre_ids) == [28,12,35,14]
            expect(movie?.original_title) == "Pirates of the Caribbean: Dead Men Tell No Tales"
            expect(movie?.original_language) == "en"
            expect(movie?.title) == "Pirates of the Caribbean: Dead Men Tell No Tales"
            expect(movie?.backdrop_path) == "/3DVKG54lqYbdh8RNylXeCf4MBPw.jpg"
            expect(movie?.popularity) ==  287.511631
            expect(movie?.vote_count) == 645
            expect(movie?.video) == false
            expect(movie?.vote_average) == 6.6
        }
        it("ignores an extra JOSN element.") {
            var extraJSON = movieJSON
            extraJSON["extraKey"] = "extra element"
            let video: MovieModel? = try? decodeValue(extraJSON)
            expect(video).notTo(beNil())
        }
    }
}
