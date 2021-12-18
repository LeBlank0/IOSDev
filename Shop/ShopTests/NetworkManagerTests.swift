@testable import Shop
import XCTest

class NetworkManagerTests: XCTestCase {

    let bundle = Bundle(for: NetworkManagerTests.self)
    var networkManager = NetworkManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDataParsingShouldParseWithSuccess() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let expectation = expectation(description: "testDataParsingShouldParseWithSuccess")
        
        guard let resource = bundle.url(forResource: "Shop", withExtension: "json") else {
            XCTFail()
            return
        }

        networkManager.data(from: resource, type: Shop.self) { result in
            // Check documentation: https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html
            switch result {
                case let .success(shop):
                    _ = shop
                    expectation.fulfill()
                case let .failure(error):
                    _ = error
                    XCTFail()
                    return
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testMalformedDataParsingShouldParseWithFailure() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = expectation(description: "testMalformedDataParsingShouldParseWithFailure")

        guard let resource = bundle.url(forResource: "MalformedShop", withExtension: "json") else {
            XCTFail()
            return
        }

        networkManager.data(from: resource, type: Shop.self) { result in
            switch result {
                case let .success(shop):
                    _ = shop
                    XCTFail()
                    return
                case let .failure(error):
                    _ = error
                    expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
