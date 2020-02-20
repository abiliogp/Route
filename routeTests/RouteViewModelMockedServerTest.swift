//
//  RouteViewModelMockedServerTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class RouteViewModelMockedServerTest: XCTestCase {

    var viewModel: RouteViewModel!
    var mockService: MockServiceRoute!

    override func setUp() {
        super.setUp()
        mockService = MockServiceRoute()
        viewModel = RouteViewModel(service: mockService)
    }

    func testShouldShowLoadWhenFetchFromService() {
        //GIVEN
        let expectFetch = XCTestExpectation()
        expectFetch.expectedFulfillmentCount = 2

        var loading = false

        //WHEN
        viewModel.onLoading = { (load) in
            loading = load
            expectFetch.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expectFetch], timeout: ValuesForTest.timeoutExpect)

        XCTAssertFalse(loading)
    }

    func testShouldGetAllNodesWhenFetchFromService() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        var nodes = [String]()

        //WHEN
        viewModel.onAllNodes = { (allNodes) in
            nodes = allNodes
            expect.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        // All nodes are included
        XCTAssertEqual(nodes.count, ValuesForTest.countAllNodes)
    }

    func testShouldGetDecodeError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockService.forceDecodeError = true

        var error: ServiceError!

        viewModel.onServiceError = { (serviceError) in
            error = serviceError
            expect.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, ServiceError.decodeError)
    }

    func testShouldGetUnavailableError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockService.forceUnavailableError = true

        var error: ServiceError!

        viewModel.onServiceError = { (serviceError) in
            error = serviceError
            expect.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, ServiceError.unavailable)
    }

}
