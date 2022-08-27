//
//  NetworkService.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import Combine

protocol Networkable: AnyObject {
    /**
     Performs the given `URLRequest` and maps the response to the given Output type
     - Parameter request: The `URLRequest` used to make the request
     - Returns: A publisher, with either the mapped Output on success,  or an Error on failure
     */
    func decodableDataTaskPublisher<Output>(with request: URLRequest) -> AnyPublisher<Output, Error> where Output: Decodable
}

/**
A concrete implementation of `Networkable` that is used for accessing the network data layer
*/
public class NetworkService: Networkable {
    private let urlSession: URLSession
    private let dataConverter: DataConverterable

    init(urlSession: URLSession, dataConverter: DataConverterable = DataConverter()) {
        self.urlSession = urlSession
        self.dataConverter = dataConverter
    }

    /**
    Performs the given URLRequest and decodes and maps the response to the given `Output `type.
    - Parameter request: The URLRequest used to make the request
    - Returns: A publisher, with either the mapped `Output` on success,  or an Error on failure
    */
    func decodableDataTaskPublisher<Output>(with request: URLRequest) -> AnyPublisher<Output, Error> where Output: Decodable {
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { data, response -> Data  in
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200..<300) ~= httpResponse.statusCode else {
                        throw NetworkError.networking(description: "Non-Successful HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
                return data
            }
            .flatMap(maxPublishers: .max(1)) {
                self.dataConverter.decode($0)
            }
            .mapError({
                $0 as Error
            })
            .eraseToAnyPublisher()
    }
}
