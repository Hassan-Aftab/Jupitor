//
//  NetworkConfig.swift
//  Titan
//
//  Created by Hassan Aftab on 23.08.22.
//

import Models
import ApiBridge

final class NetworkConfigImpl: NetworkConfig {

    var baseUrl: String?

    public init(with infoDict: [String: Any]?) {
        
        guard let infoDict = infoDict else { fatalError() }
        
        baseUrl = infoDict["BASE_URL"] as? String
        
    }
}
