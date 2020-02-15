//
//  Service.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol ServiceRouteProtocol {
    func fetchRoutes(completionHandler: @escaping (Result<ListConnection, ServiceError>) -> Void)
}

struct Service {

    static let shared = Service()

    private let baseURL = Environment.baseUrl

    private init() {
    }

}

extension Service: ServiceRouteProtocol {
    func fetchRoutes(completionHandler: @escaping (Result<ListConnection, ServiceError>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                do {
                    let listConnection = try JSONDecoder().decode(ListConnection.self, from: data)
                    completionHandler(.success(listConnection))
                } catch {
                    completionHandler(.failure(.decodeError))
                }
            } else {
                completionHandler(.failure(.unavailable))
            }
        }.resume()
    }
}
