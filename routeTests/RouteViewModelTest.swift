//
//  RouteViewModelTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class RouteViewModelTest: XCTestCase {

    var viewModel: RouteViewModel!

    override func setUp() {
        super.setUp()
        viewModel = RouteViewModel()
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
        XCTAssert(loading)

        wait(for: [expectFetch], timeout: 5.0)

        XCTAssertFalse(loading)
    }

    func testShouldGetAllNodesWhenFetchFromService() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        var nodes = Set<Node>()

        //WHEN
        viewModel.onAllNodes = { (allNodes) in
            nodes = allNodes
            expect.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expect], timeout: 5.0)

        // All nodes are included
        XCTAssertEqual(nodes.count, 7)
    }

    func testShouldGetFromNodesWhenFetchFromService() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        var nodes = Set<Node>()

        //WHEN
        viewModel.onFromNodes = { (fromNodes) in
            nodes = fromNodes
            expect.fulfill()
        }

        viewModel.setupController()

        //THEN
        wait(for: [expect], timeout: 5.0)

        // All nodes less Porto, that does not have destination list
        XCTAssertEqual(nodes.count, 6)
    }
}
