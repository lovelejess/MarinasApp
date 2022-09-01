//
//  Point.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

enum Kind: String, Codable, CaseIterable {
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

    /// This returns a list of popular `Kinds` for `Points`
    ///
    /// - Returns: a list of "popular" `Kind`
    static func getPopularFilters() -> [Kind] {
        return [.harbor, .landmark, .marina, .ramp]
    }
}

struct PointImage: Codable, Hashable {
    let resource: String
    let thumbnailUrl: String
    let smallUrl: String
    
    enum CodingKeys: String, CodingKey {
        case resource
        case thumbnailUrl = "thumbnail_url"
        case smallUrl = "small_url"
    }
}

struct PointImages: Codable, Hashable {
    let data: [PointImage]
}

struct Point: Codable, Hashable {
    let id: String
    let name: String?
    let kind: Kind
    let iconURL: String?
    let images: PointImages

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case kind
        case iconURL = "icon_url"
        case images
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.id == rhs.id
    }
}
