//
//  MarinasFetcherTests.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/27/22.
//

import XCTest
import Combine
@testable import MarinasApp

class MarinasFetcherTests: XCTestCase {
    private let id = "95cz"
    private var marinasFetcher: MarinasFetcher!
    private var urlSessionMock: URLSession!
    private var fakeNetworkService: FakeNetworkService!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        fakeNetworkService = FakeNetworkService()
        marinasFetcher = MarinasFetcher(networkService: fakeNetworkService)
    }

    func test_GETPointsEndpoint_returnsCorrectURL() throws {
        let expectedURL = "https://api.marinas.com/v1/points/\(id)"
        let expectedComponents = try XCTUnwrap(URLComponents(string: expectedURL))
        let expectedQueryItems = [URLQueryItem(name: "access_token", value: "cPEQZFRWsBNZBV3YNi1T")]

        let actual = try XCTUnwrap(MarinasFetcher.Endpoints.points(id: id).url)
        let actualComponents = try XCTUnwrap(URLComponents(url: actual, resolvingAgainstBaseURL: true))
        let actualQueryItems = actualComponents.queryItems

        XCTAssertEqual(actualComponents.host, expectedComponents.host)
        XCTAssertEqual(actualComponents.path, expectedComponents.path)
        XCTAssertEqual(actualQueryItems, expectedQueryItems)
    }

    func test_GETPoints_successfullyRetreivesData() throws {
        let expectation = XCTestExpectation(description: "Complete Get Points")
        fakeNetworkService.fakeEndpoint(.points(id: id), with: FakeTestEndpoint.points(id: id).defaultResponseFileName)

        marinasFetcher
            .points(for: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                XCTFail("Failed to get successful results")
              case .finished:
                XCTAssertNotNil(value)
                expectation.fulfill()
              }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                XCTAssertEqual(response.id, self.id)
                expectation.fulfill()
            })
            .store(in: &subscribers)

        wait(for: [expectation], timeout: 0.5)
    }

    func test_GETPoints_failsToRetreiveData() throws {
        let expectation = XCTestExpectation(description: "Fails to Get Points")
        fakeNetworkService.fakeEndpoint(.points(id: id), with: FakeTestEndpoint.points(id: id).defaultResponseFailureFileName)

        marinasFetcher
            .points(for: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                expectation.fulfill()
              case .finished:
                XCTFail("Test should cause a failure")
              }
            }, receiveValue: { _ in
                XCTFail("Test should cause a failure")
            })
            .store(in: &subscribers)

        wait(for: [expectation], timeout: 0.5)
    }

}
