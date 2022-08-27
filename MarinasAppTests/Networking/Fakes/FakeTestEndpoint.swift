//
//  FakeTestEndpoint.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/27/22.
//

import Foundation
@testable import MarinasApp

enum FakeTestEndpoint {
    case points(id: String)

    var urlString: String {
        switch self {
        case .points(let id):
            return MarinasFetcher.Endpoints.points(id: id).url.absoluteString
        }
    }

    var defaultResponseFileName: String {
        switch self {
        case .points:
            return "FakePointData"
        }
    }

    var defaultResponseFailureFileName: String {
        return "FakeFailureData"
    }
}
