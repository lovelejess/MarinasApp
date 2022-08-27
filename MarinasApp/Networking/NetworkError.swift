//
//  NetworkError.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation

enum NetworkError: Error {
    case networking(description: String)
    case parsing(description: String)
}
