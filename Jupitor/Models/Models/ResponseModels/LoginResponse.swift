//
//  Models.swift
//  Models
//
//  Created by Hassan Aftab on 19.08.22.
//

public struct LoginRespnse: Codable {
    
    public struct User: Codable {
        public let email: String
        public let createdAt: String
    }
    
    public struct AccessTokenContent: Codable {
        public let country: String
        public let version: String
        public let initialTime: Int64
        public let expiryTime: Int64
        
    }
    
    public let user : User
    public let refreshToken : String
    public let accessTokenContent: AccessTokenContent
    public let tokenType: String
    public let accessToken: String    
}

