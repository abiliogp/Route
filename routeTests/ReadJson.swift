//
//  ReadJson.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class ReadJson {

    func loadDataFromFile<T>(named: String,
                             ofType: String,
                             typeClass: T.Type) throws -> T where T: Decodable {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: named, ofType: ofType)
        let data = try Data(contentsOf: URL(fileURLWithPath: path!))
        let dto = try JSONDecoder().decode(T.self, from: data)
        return dto
    }

}
