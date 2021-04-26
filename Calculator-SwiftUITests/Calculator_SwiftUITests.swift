//
//  Calculator_SwiftUITests.swift
//  Calculator-SwiftUITests
//
//  Created by Yousef on 4/25/21.
//

import XCTest
@testable import Calculator_SwiftUI

class Calculator_SwiftUITests: XCTestCase {

    var suit: CurrencyConverterViewModel?
    
    override func setUpWithError() throws {
        suit = CurrencyConverterViewModel()
    }

    override func tearDownWithError() throws {
        suit = nil
    }

    func testExample() throws {
        let expectation = self.expectation(description: "waiting currency conversion")
        let amount: Double = 30
        CurrencyConvertService.EGP_USDRatio { res in
            switch res {
            case .success(let ratio):
                let res = "\((ratio * amount).asFormattedString()) USD"
                self.suit?.egpAmount = String(amount)
                self.suit?.convert()
                self.suit?.$result.sink { val in
                    XCTAssert(val == res, "Expected \(res) Found: \(val)")
                    expectation.fulfill()
                }
            case .failure(let err):
                XCTFail("APIError: \(err.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 30)
        
    }

}
