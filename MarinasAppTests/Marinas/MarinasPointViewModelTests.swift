//
//  MarinasPointViewModelTests.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/28/22.
//
import Combine
import XCTest
@testable import MarinasApp

class MarinasPointViewModelTests: XCTestCase {
    let id = "1234"
    let iconURL = "https://fakeurl.com"
    private var viewModel: MarinasPointViewModel!
    private var urlSessionMock: URLSession!
    private var fakeMarinasFetcher: FakeMarinasFetcher!
    private var fakeNetworkService: FakeNetworkService!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        fakeNetworkService = FakeNetworkService()
        fakeMarinasFetcher = FakeMarinasFetcher(networkService: fakeNetworkService)
    }

    func test_getPoints_returnsPoint() throws {
        let expectation = XCTestExpectation(description: "Successfully Gets Points")
        let expected = [Point(id: "1234", name: "Fake Harbor", kind: .harbor, iconURL: iconURL)]

        viewModel = MarinasPointViewModel(marinasFetcher: fakeMarinasFetcher)

        viewModel.getPointInfo(for: id)

        viewModel.$points
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                  XCTFail("Failed to get successful results")
                case .finished:
                  XCTAssertNotNil(value)
                  expectation.fulfill()
                }
              }, receiveValue: { actual in
                  XCTAssertEqual(actual, expected)
                  expectation.fulfill()
              })

              .store(in: &subscribers)
          wait(for: [expectation], timeout: 0.5)
    }
}
