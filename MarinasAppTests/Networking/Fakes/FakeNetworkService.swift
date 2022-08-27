//
//  FakeNetworkService.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/27/22.
//

import Foundation
import XCTest
import Combine
@testable import MarinasApp

class FakeNetworkService: Networkable {
    var testDataForUrlRequest = [String: Data]()
    var requests: [URLRequest] = []

    init(dateStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) {
        self.dateStrategy = dateStrategy
    }

    func fakeEndpoints(_ endpoints: [FakeTestEndpoint]) {
        for endpoint in endpoints {
            fakeEndpoint(endpoint, with: endpoint.defaultResponseFileName)
        }
    }

    func fakeEndpoint(_ endpoint: FakeTestEndpoint, with fileName: String) {
        guard let mockData = FakeJSONLoader.loadFile(for: fileName) else {
            XCTFail("Could not create mock data from: \(fileName).json")
            return
        }

        setTestData(path: endpoint.urlString, data: mockData)
    }

    func setTestData(urlRequest: URLRequest, data: Data) {
        guard let path = urlRequest.url?.path else {
            XCTFail("Invalid path for URLRequest")
            return
        }

        setTestData(path: path, data: data)
    }

    func setTestData(path: String, data: Data) {
        testDataForUrlRequest[path] = data
    }

    func decode<T: Decodable>(_ data: Data, _ response: URLResponse) -> AnyPublisher<T, Error> {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = dateStrategy
      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }

    func decodableDataTaskPublisher<Output>(with request: URLRequest) -> AnyPublisher<Output, Error> where Output: Decodable {
        requests.append(request)
        if let url = request.url?.absoluteString,
           let data = testDataForUrlRequest[url] {
            return decode(data, URLResponse())
        }

        return decode(Data(), URLResponse())
    }

    private var dateStrategy: JSONDecoder.DateDecodingStrategy
}
