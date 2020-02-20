//
//  RouteViewModelMockedEngineTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class RouteViewModelMockedEngineTest: XCTestCase {

    var viewModel: RouteViewModel!
    var mockService: MockServiceRoute!
    var mockEngine: MockEngine!

    override func setUp() {
        super.setUp()
        mockService = MockServiceRoute()
        mockEngine = MockEngine()
        viewModel = RouteViewModel(service: mockService,
                                   routeCalculator: mockEngine)
    }

    func testShouldGetAllNodesWhenFetchFromService() {
        //GIVEN
        let expect = XCTestExpectation()

        var steps = 0

        //WHEN
        viewModel.onTripReady = { (tripSteps) in
            steps = tripSteps
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(steps, 1)
    }

    func testShouldGetEmptyListError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockEngine.forceErrorEngine = .emptyNodeList

        var error: EngineError!

        viewModel.onEngineError = { (engineError) in
            error = engineError
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, EngineError.emptyNodeList)
    }

    func testShouldGetNotReachableError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockEngine.forceErrorEngine = .notReachable

        var error: EngineError!

        viewModel.onEngineError = { (engineError) in
            error = engineError
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, EngineError.notReachable)
    }

    func testShouldGetNotValidFromError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockEngine.forceErrorEngine = .notValidFrom

        var error: EngineError!

        viewModel.onEngineError = { (engineError) in
            error = engineError
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, EngineError.notValidFrom)
    }

    func testShouldGetNotValidToError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockEngine.forceErrorEngine = .notValidTo

        var error: EngineError!

        viewModel.onEngineError = { (engineError) in
            error = engineError
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, EngineError.notValidTo)
    }

    func testShouldGetSameFromAndToError() {
        //GIVEN
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 1

        mockEngine.forceErrorEngine = .sameFromAndTo

        var error: EngineError!

        viewModel.onEngineError = { (engineError) in
            error = engineError
            expect.fulfill()
        }

        viewModel.setupController()
        viewModel.findRoute(from: "London", destination: "Porto")

        //THEN
        wait(for: [expect], timeout: ValuesForTest.timeoutExpect)

        XCTAssertEqual(error, EngineError.sameFromAndTo)
    }

}
