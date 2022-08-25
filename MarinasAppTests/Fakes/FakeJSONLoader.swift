//
//  FakeJSONLoader.swift
//  MarinasAppTests
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
@testable import MarinasApp

class FakeJSONLoader {

    static func loadFile(for name: String) -> Data? {
        guard let path = Bundle(for: FakeJSONLoader.self).path(forResource: name, ofType: "json") else {
            fatalError("Failed to locate \(name) in bundle.")
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Failed to load \(name) from bundle.")
        }

        return data
    }
}
