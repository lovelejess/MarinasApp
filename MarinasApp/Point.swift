//
//  Point.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

struct Point: Codable, Hashable {
    let id: String
    let name: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.id == rhs.id
    }
}
