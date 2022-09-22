//
//  DataConverterTests.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/24/22.
//

import XCTest
import Combine

@testable import MarinasApp

class DataConverterTests: XCTestCase {
    let iconURL = "https://marinas.com/assets/map/marker_marina-61b3ca5ea8e7fab4eef2d25df94457f060498ca1a72e3981715f46d2ab347db4.svg"
    let thumbnailURL = "https://img.marinas.com/v2/21a35907f6cd41f5f5ab7ea73a9564d956f514d1d6b5afa07c67980c9523bfa8.jpg"
    let smallURL = "https://img.marinas.com/v2/608f157042d37bbb5627ad701796eb60125b959cbdaf568be9ada8010a2bb2a9.jpg"
    let webURL = "https://marinas.com/view/marina/95cz_Baltimore_Yacht_Basin_Baltimore_MD_United_States"
    var images: PointImages!

    private var dataConverter: DataConverter!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        images = PointImages(data: [PointImage(resource: "Resource", thumbnailUrl: thumbnailURL, smallUrl: smallURL)])
        dataConverter = DataConverter()
    }

    func test_decode_success() throws {
        let expectation = XCTestExpectation(description: "Successfully Decodes")
        guard let data = FakeJSONLoader.loadFile(for: "FakePointData") else { XCTFail("Unable load mock data");return }

        let expected = Point(id: "95cz", name: "Baltimore Yacht Basin", kind: .marina, iconURL: iconURL, images: images, url: webURL)

        dataConverter.decode(data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
              switch value {
              case .failure:
                XCTFail("Failed to get successful results")
              case .finished:
                XCTAssertNotNil(value)
                expectation.fulfill()
              }
            }, receiveValue: { (response: Point) in
                XCTAssertEqual(response.id, expected.id)
                XCTAssertEqual(response.name, expected.name)
                XCTAssertEqual(response.kind, expected.kind)
                XCTAssertEqual(response.iconURL, expected.iconURL)
                XCTAssertEqual(response.url, expected.url)
                expectation.fulfill()
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 0.5)
    }

    func test_decode_withInvalidData_returns_networkParsingError() throws {
        let expectation = XCTestExpectation(description: "Fails to Decode")
        guard let data = FakeJSONLoader.loadFile(for: "FakeFailureData") else { XCTFail("Unable load mock data");return }

        dataConverter.decode(data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { actual in
              switch actual {
              case .failure:
                  expectation.fulfill()
              case .finished:
                  XCTFail("Test should cause a failure")
              }
            }, receiveValue: { (response: Point) in
                XCTFail("Test should cause a failure")
            })
            .store(in: &subscribers)
            wait(for: [expectation], timeout: 0.5)
    }
}
