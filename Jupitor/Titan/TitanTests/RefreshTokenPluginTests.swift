//
//  RefreshTokenPluginTests.swift
//  TitanTests
//
//  Created by Hassan Aftab on 24.08.22.
//

import XCTest
import AccessTokenManagerBridge
import ApiBridge
import RxSwift
import RxTest
import Models
import Moya
@testable import Titan

class RefreshTokenPluginTests: XCTestCase {

    var accessTokenManager: MockAccessTokenManager!
    var refreshTokenPlugin: RefreshTokenPlugin!
    override func setUpWithError() throws {
        accessTokenManager = MockAccessTokenManager()
        refreshTokenPlugin = RefreshTokenPlugin(accessTokenManager, refreshTokenApiHandler: MockLoginApis())
        
        let url = Bundle(for: RefreshTokenPlugin.self).url(forResource: "LoginResponseStub", withExtension: "json")
        let data = try Data(contentsOf: url!)
        let expiredToken = try JSONDecoder().decode(AccessToken.self, from: data)
        
        try accessTokenManager.save(token: expiredToken)
    }

    override func tearDownWithError() throws {
        refreshTokenPlugin = nil
    }
    
    func testRefreshToken() throws {
        // given refresh token plugin
        // when we prepare for request
        _ = refreshTokenPlugin.prepare(URLRequest(url: URL(string: "https://www.google.com/")!), target: LoginApi.login(username: "", password: ""))
        
        // check if token was updated
        XCTAssertEqual(accessTokenManager.fetch()?.accessTokenContent.exp, 5661246362)
    }
    
}

class MockAccessTokenManager: AccessTokenManager {
    
    private var accessToken : AccessToken?
    func save(token accessToken: AccessToken) throws {
        self.accessToken = accessToken
    }
    
    func fetch() -> AccessToken? {
        return accessToken
    }
}

class MockLoginApis: LoginApis {
    func login(with username: String, and password: String) -> Observable<LoginRespnse?> {
        return Observable.just(nil)
    }
    
    func refreshToken(with param: String) -> Observable<LoginRespnse?> {
        let url = Bundle(for: RefreshTokenPlugin.self).url(forResource: "LoginResponseNotExpired", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {
            return Observable.just(nil)
        }
        if let token = try? JSONDecoder().decode(AccessToken.self, from: data){
            return Observable.just(token)
        }
        return Observable.just(nil)
        
    }
    
    
}
