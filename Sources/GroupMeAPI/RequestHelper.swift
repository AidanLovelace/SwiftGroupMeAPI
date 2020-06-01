//
//  URLSessionExtension.swift
//  TestingEnvironment
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation
import Promises

enum HTTPError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(code: Int)
    case noData
}

func promiseRequest(request: URLRequest) -> Promise<Data> {
    return Promise<Data> { fulfill, reject in
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                reject(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                reject(HTTPError.invalidResponse)
                return
            }
            guard let data = data else {
                reject(HTTPError.noData)
                return
            }
            fulfill(data)
        }.resume()
    }
}
