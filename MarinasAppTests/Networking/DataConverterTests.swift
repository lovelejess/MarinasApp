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

    private var dataConverter: DataConverter!
    private var subscribers = [AnyCancellable]()

    override func setUpWithError() throws {
        dataConverter = DataConverter()
    }

    func test_decode_success() throws {
        let expectation = XCTestExpectation(description: "Successfully Decodes")
        guard let data = FakeJSONLoader.loadFile(for: "FakePointData") else { XCTFail("Unable load mock data");return }

        let expected = Point(id: "95cz", name: "Baltimore Yacht Basin", kind: .marina)

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
