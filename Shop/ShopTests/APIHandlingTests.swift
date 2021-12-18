@testable import Shop
import XCTest

// API Handler tests
//
// The goal of those tests are to check your api handler implementation.
// In this case, we want to see that the API handler is actually calling the network manager.
// Fill up those already created methods.
class APIHandlingTests: XCTestCase {

    let networkManager = MockNetworkManager()
    lazy var apiHandler = APIHandler(networkManager: networkManager)

    func testShouldCallNetworkingManagerWhenFetchShopCalled(completion: ((Result<Shop, NetworkError>) -> Void)?) throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("CallCounter:", networkManager.dataCallCount)
        let testValue = apiHandler.fetchShop(completion: completion!)
//        let apiValue = apiHandler.fetchShop(completion: ((Result<Shop, NetworkError>) -> Void)?)
        
        // TODO: Assert
        print("CallCounter:", networkManager.dataCallCount)
        XCTAssertEqual(networkManager.dataCallCount, 1)
    }
}
