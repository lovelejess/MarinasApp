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
    let webURL = "https://weburl.com"
    private var viewModel: MarinasPointViewModel!
    private var urlSessionMock: URLSession!
    private var fakeMarinasFetcher: FakeMarinasFetcher!
    private var fakeNetworkService: FakeNetworkService!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        fakeNetworkService = FakeNetworkService()
        fakeMarinasFetcher = FakeMarinasFetcher(networkService: fakeNetworkService)
    }

    func test_getPointInfo_returnsPoint() throws {
        let expectation = XCTestExpectation(description: "Successfully Gets Points")
        let images = PointImages(data: [PointImage(resource: "Resource", thumbnailUrl: "Thumnail URL", smallUrl: "Small URL")])
        let expected = Point(id: "1234", name: "Fake Harbor", kind: .harbor, iconURL: iconURL, images: images, url: webURL)

        viewModel = MarinasPointViewModel(marinasFetcher: fakeMarinasFetcher)

        viewModel.point
        .receive(on: DispatchQueue.main)
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

        viewModel.getPointInfo(for: id)

        wait(for: [expectation], timeout: 0.5)
    }
}
