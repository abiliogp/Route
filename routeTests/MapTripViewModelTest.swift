//
//  MapTripViewModelTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 21/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class MapTripViewModelTest: XCTestCase {

    var mapTripViewModel: MapTripViewModel?
    var routeViewModel: RouteViewModel!

    override func setUp() {
        super.setUp()
        routeViewModel = RouteViewModel()
    }

    func testShouldSetupMapViewForTrip() {
        //GIVEN
        let expect = XCTestExpectation(description: "expect")
        let expectMapView = XCTestExpectation()

        var steps = 0

        //WHEN
        routeViewModel.onTripReady = { (tripSteps) in
            steps = tripSteps
            expect.fulfill()
        }

        routeViewModel.setupController()
        routeViewModel.findRoute(from: "New York", destination: "Porto")

        wait(for: [expect], timeout: 10)

        guard let mapTripViewModel = routeViewModel.mapViewModel else { return }

        var mapTripList: [MapTrip]?

        mapTripViewModel.onMapReady = { (listMap) in
            mapTripList = listMap
            expectMapView.fulfill()
        }

        mapTripViewModel.setupController()

        wait(for: [expectMapView], timeout: ValuesForTest.timeoutExpect)

        //THEN
        XCTAssertEqual(steps, 5)
        XCTAssertNotNil(mapTripList)
        XCTAssertEqual(mapTripList?.count, steps)
    }

}
