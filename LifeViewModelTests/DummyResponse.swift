//
//  DummyResponse.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

@testable import LifeModel
@testable import LifeViewModel

let dummyResponse: ResponsePopular = {
    let movie0 = MovieModel(
        poster_path: "/xbpSDU3p7YUGlu9Mr6Egg2Vweto.jpg",
        adult: false,
        overview: "Captain Jack Sparrow is",
        release_date: "2017-05-23",
        genre_ids: [28,12,35,14],
        id: 10000,
        original_title: "Pirates of the Caribbean: Dead Men Tell No Tales",
        original_language: "en",
        title: "Pirates of the Caribbean: Dead Men Tell No Tales",
        backdrop_path: "/3DVKG54lqYbdh8RNylXeCf4MBPw.jpg",
        popularity: 287.511631,
        vote_count: 645,
        video: false,
        vote_average: 6.6)
    let movie1 = MovieModel(
        poster_path: "/xbpSDU3p7YUGlu9Mr6Egg2Vweto.jpg",
        adult: false,
        overview: "ZZZZZ Captain Jack Sparrow is",
        release_date: "2017-05-23",
        genre_ids: [28,12,35,14],
        id: 10001,
        original_title: "Pirates of the Caribbean: Dead Men Tell No Tales",
        original_language: "en",
        title: "Pirates of the Caribbean: Dead Men Tell No Tales",
        backdrop_path: "/3DVKG54lqYbdh8RNylXeCf4MBPw.jpg",
        popularity: 287.511631,
        vote_count: 645,
        video: false,
        vote_average: 6.6)
    return ResponsePopular(page: 33, movies: [movie0,movie1], total_results: 1000000, total_pages: 1000)
}()

let image1x1: UIImage = {
    UIGraphicsBeginImageContextWithOptions(CGSize(width:1, height:1), true, 0)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}()
