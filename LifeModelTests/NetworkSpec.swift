//
//  NetworkSpec.swift
//  LifeBloo
//
//  Created by Daniel Karsh on 6/3/17.
//  Copyright © 2017 Daniel Karsh. All rights reserved.
//

import Quick
import Nimble
@testable import LifeModel

class NetworkSpec: QuickSpec {
    override func spec() {
        var network: Network!
        beforeEach {
            network = Network()
        }
        
        describe("JSON") {
            it("eventually gets JSON data as specified with parameters.") {
                var json: [String: Any]? = nil
                let url = "https://httpbin.org/get"
                network.requestJSON(url: url, parameters: ["a": "b", "x": "y"])
                    .on(value: { json = $0 as? [String: Any] })
                    .start()
                
                expect(json).toEventuallyNot(beNil(), timeout: 5)
                expect((json?["args"] as? [String: Any])?["a"] as? String)
                    .toEventually(equal("b"), timeout: 5)
                expect((json?["args"] as? [String: Any])?["x"] as? String)
                    .toEventually(equal("y"), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                let url = "https://not.existing.server.comm/get"
                network.requestJSON(url: url, parameters: ["a": "b", "x": "y"])
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error)
                    .toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }
        }
        
        describe("Image") {
            it("eventually gets an image.") {
                var image: UIImage?
                network.requestImage(url: "https://httpbin.org/image/jpeg")
                    .on(value: { image = $0 })
                    .start()
                
                expect(image).toEventuallyNot(beNil(), timeout: 5)
            }
            it("eventually gets an error if incorrect data for an image is returned.") {
                var error: NetworkError?
                network.requestImage(url: "https://httpbin.org/get")
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(
                    equal(NetworkError.IncorrectDataReturned), timeout: 5)
            }
        }
    }
}
