//
//  DataConverter.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import Combine

protocol DataConverterable: AnyObject {
    /**
     Decodes the given data via `JSONDecoder`.
     - Parameter data: Data to be decoded
     - Returns: A publisher, with either the decoded data on success, or an Error on failure
     */
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error>
}

class DataConverter: DataConverterable {

    init(dateStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) {
        self.dateStrategy = dateStrategy
    }

    /**
    Decodes the given data via `JSONDecoder`.
    - Parameter data: Data to be decoded
    - Returns: A publisher, with either the decoded data on success, or a `NetworkError` on failure
    */
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateStrategy
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                print("error: \(error)")
                return error
            }
            .eraseToAnyPublisher()
    }

    private var dateStrategy: JSONDecoder.DateDecodingStrategy
}
