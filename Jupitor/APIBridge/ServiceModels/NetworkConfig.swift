//
//  NetworkConfig.swift
//  Models
//
//  Created by Hassan Aftab on 19.08.22.
//

import Foundation
import Models

public protocol NetworkConfig: Codable {
    var baseUrl: String? { get }
}
