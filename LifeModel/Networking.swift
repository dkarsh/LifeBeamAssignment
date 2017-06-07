//
//  Networking.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

public protocol Networking {
    func requestJSON(url: String, parameters: [String : Any]?) -> SignalProducer<Any, NetworkError>
    func requestImage(url: String) -> SignalProducer<UIImage, NetworkError>
    func requestBackImage(url: String) -> SignalProducer<UIImage, NetworkError>
}
