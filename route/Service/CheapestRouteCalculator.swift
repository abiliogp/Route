//
//  CheapestRouteCalculator.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CheapestRouteCalculatorProtocol {
    
    func calculate(connections: ListConnection,
                   fromCity: Connection,
                   toCity: Connection) -> [Connection]
}

struct CheapestRouteCalculator {

}

extension CheapestRouteCalculator: CheapestRouteCalculatorProtocol{

    func calculate(connections: ListConnection,
                   fromCity: Connection,
                   toCity: Connection) -> [Connection] {

        if fromCity == toCity {
            return [fromCity]
        }

        return [fromCity]
    }

}
