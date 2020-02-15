//
//  ConvertDtoTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class ReadJsonTest: XCTestCase {

    func testShouldReadConnectionsList() throws {
        let listConnections = try loadDataFromFile(named: "connections",
                                              ofType: ".json",
                                              typeClass: ListConnection.self)

        XCTAssertNotNil(listConnections)
        XCTAssertNotNil(listConnections.connections)
        XCTAssertEqual(listConnections.connections.count, 9)
    }

}

extension ReadJsonTest {

    private func loadDataFromFile<T>(named: String,
                                     ofType: String,
                                     typeClass: T.Type) throws -> T where T: Decodable {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: named, ofType: ofType)
        let data = try Data(contentsOf: URL(fileURLWithPath: path!))
        let dto = try JSONDecoder().decode(T.self, from: data)
        return dto
    }
}
