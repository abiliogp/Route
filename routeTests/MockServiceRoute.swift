//
//  MockServiceRoute.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
@testable import route

class MockServiceRoute: ServiceRouteProtocol{

    var forceDecodeError = false
    var forceUnavailableError = false

    func fetchRoutes(completionHandler: @escaping (Result<ListConnection, ServiceError>) -> Void) {
        if forceDecodeError{
            completionHandler(.failure(.decodeError))
        } else if forceUnavailableError{
            completionHandler(.failure(.unavailable))
        } else{
            do {
                let listConnections = try ReadJson().loadDataFromFile(named: "connections",
                                                                      ofType: ".json",
                                                                      typeClass: ListConnection.self)

                completionHandler(.success(listConnections))
            } catch{
                completionHandler(.failure(.decodeError))
            }
        }
    }

    func clear(){
        forceDecodeError = false
        forceUnavailableError = false
    }

}
