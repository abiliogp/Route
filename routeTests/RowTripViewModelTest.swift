//
//  RowTripViewModelTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 19/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class RowTripViewModelTest: XCTestCase {

    var routeViewModel: RouteViewModel!

    override func setUp() {
        super.setUp()
        routeViewModel = RouteViewModel()
    }

    func testShouldSetupRowForTrip() {
        //GIVEN
        let expect = XCTestExpectation(description: "expect")
        let expectRowTitle = XCTestExpectation()
        let expectRowPrice = XCTestExpectation()
        let expectRowImage = XCTestExpectation()

        var steps = 0
        var cityTitle = ""
        var cityPrice = ""
        var imageStage: UIImage?

        //WHEN
        routeViewModel.onTripReady = { (tripSteps) in
            steps = tripSteps
            expect.fulfill()
        }

        routeViewModel.setupController()
        routeViewModel.findRoute(from: "New York", destination: "Porto")

        wait(for: [expect], timeout: 10)

        guard let rowViewModel = routeViewModel.rowViewModel(for: 4) else { return }

        rowViewModel.onTitleReady = { (title) in
            cityTitle = title
            expectRowTitle.fulfill()
        }

        rowViewModel.onPriceReady = { (price) in
            cityPrice = price
            expectRowPrice.fulfill()

        }

        rowViewModel.onStageImageReady = { (image) in
            imageStage = image
            expectRowImage.fulfill()
        }

        rowViewModel.setupViewCell()

        wait(for: [expectRowTitle, expectRowPrice, expectRowImage], timeout: ValuesForTest.timeoutExpect)

        //THEN
        XCTAssertEqual(steps, 5)

        XCTAssertEqual(cityTitle, "Porto")
        XCTAssertEqual(cityPrice, "€ 520")
        XCTAssertNotNil(imageStage)

    }

    func testShouldSetupRowForTripDeparture() {
        //GIVEN
        let expect = XCTestExpectation()
        let expectRowTitle = XCTestExpectation()
        let expectRowPrice = XCTestExpectation()
        let expectRowImage = XCTestExpectation()

        var steps = 0
        var cityTitle = ""
        var cityPrice = ""
        var imageStage: UIImage?

        //WHEN
        routeViewModel.onTripReady = { (tripSteps) in
            steps = tripSteps
            expect.fulfill()
        }

        routeViewModel.setupController()
        routeViewModel.findRoute(from: "New York", destination: "Porto")

        wait(for: [expect], timeout: 10)

        guard let rowViewModel = routeViewModel.rowViewModel(for: 0) else { return }

        rowViewModel.onTitleReady = { (title) in
            cityTitle = title
            expectRowTitle.fulfill()
        }

        rowViewModel.onPriceReady = { (price) in
            cityPrice = price
            expectRowPrice.fulfill()

        }

        rowViewModel.onStageImageReady = { (image) in
            imageStage = image
            expectRowImage.fulfill()
        }

        rowViewModel.setupViewCell()

        wait(for: [expectRowTitle, expectRowPrice, expectRowImage], timeout: ValuesForTest.timeoutExpect)

        //THEN
        XCTAssertEqual(steps, 5)

        XCTAssertEqual(cityTitle, "New York")
        XCTAssertEqual(cityPrice, "€ 0")
        XCTAssertNotNil(imageStage)
    }

    func testShouldSetupRowForTripConnection() {
        //GIVEN
        let expect = XCTestExpectation()
        let expectRowTitle = XCTestExpectation()
        let expectRowPrice = XCTestExpectation()
        let expectRowImage = XCTestExpectation()

        var steps = 0
        var cityTitle = ""
        var cityPrice = ""
        var imageStage: UIImage?

        //WHEN
        routeViewModel.onTripReady = { (tripSteps) in
            steps = tripSteps
            expect.fulfill()
        }

        routeViewModel.setupController()
        routeViewModel.findRoute(from: "New York", destination: "Porto")

        wait(for: [expect], timeout: 10)

        guard let rowViewModel = routeViewModel.rowViewModel(for: 1) else { return }

        rowViewModel.onTitleReady = { (title) in
            cityTitle = title
            expectRowTitle.fulfill()
        }

        rowViewModel.onPriceReady = { (price) in
            cityPrice = price
            expectRowPrice.fulfill()

        }

        rowViewModel.onStageImageReady = { (image) in
            imageStage = image
            expectRowImage.fulfill()
        }

        rowViewModel.setupViewCell()

        wait(for: [expectRowTitle, expectRowPrice, expectRowImage], timeout: ValuesForTest.timeoutExpect)

        //THEN
        XCTAssertEqual(steps, 5)

        XCTAssertEqual(cityTitle, "Los Angeles")
        XCTAssertEqual(cityPrice, "€ 120")
        XCTAssertNotNil(imageStage)
    }

    func testShouldNotSetupRowForIndexOutOfBounds() {
        //GIVEN
        let expect = XCTestExpectation()

        //WHEN
        routeViewModel.onTripReady = { (tripSteps) in
            expect.fulfill()
        }

        routeViewModel.setupController()
        routeViewModel.findRoute(from: "New York", destination: "Porto")

        wait(for: [expect], timeout: 10)

        let rowViewModel = routeViewModel.rowViewModel(for: 10)

        //THEN
        XCTAssertNil(rowViewModel)
    }
}
