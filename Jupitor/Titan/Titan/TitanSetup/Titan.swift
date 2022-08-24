//
//  Titan.swift
//  Titan
//
//  Created by Hassan Aftab on 19.08.22.
//

import ApiBridge

final class Titan: NetworkManager {
    var configurations: NetworkConfig
    var accessTokenManager: AccessTokenManager
    init(_ configurations: NetworkConfig, _ accessTokenManager: AccessTokenManager) {
        self.configurations = configurations
        self.accessTokenManager = accessTokenManager
    }
}
