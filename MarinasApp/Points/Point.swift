//
//  Point.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

enum Kind: String, Codable {
    case anchorage
    case bridge
    case ferry
    case harbor
    case inlet
    case landmark
    case lighthouse
    case lock
    case marina
    case ramp
}

struct Point: Codable, Hashable {
    let id: String
    let name: String?
    let kind: Kind
    let iconURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case kind
        case iconURL = "icon_url"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.id == rhs.id
    }
}
