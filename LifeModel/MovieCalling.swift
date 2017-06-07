//
//  MovieSearching.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import ReactiveSwift

import enum Result.NoError
public typealias NoError = Result.NoError

public protocol MovieCalling{
    func callPopular(nextPageTrigger trigger: SignalProducer<(), NoError>) -> SignalProducer<ResponsePopular, NetworkError>
    func callCredit(movieID:String) -> SignalProducer<ResponseCredits, NetworkError>
    func callGenres() -> SignalProducer<ResponseGenres, NetworkError>
}
