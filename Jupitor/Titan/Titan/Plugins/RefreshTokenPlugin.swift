//
//  RefreshTokenPlugin.swift
//  Titan
//
//  Created by Hassan Aftab on 23.08.22.
//

import Moya
import Models
import ApiBridge
import RxSwift


final class RefreshTokenPlugin: PluginType {
    
    private let disposeBag = DisposeBag()
    var tokenManager: AccessTokenManager
    var refreshTokenApiHandler: LoginApis
    private var semaphore = DispatchSemaphore(value: 0)
    var token : AccessToken? {
        self.tokenManager.fetch()
    }
    
    public init(_ accessTokenManager: AccessTokenManager, refreshTokenApiHandler: LoginApis) {
        self.tokenManager = accessTokenManager
        self.refreshTokenApiHandler = refreshTokenApiHandler
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard let token = self.token else { // Check if we have any existing token
            return request // if there is no existing token, we cannot
        }
        
        let now = Date().timeIntervalSince1970
        
        // if token expired, refresh token.
        if Double(token.accessTokenContent.expiryTime) < now {
            
            NSLog("start refresh token automatic", "")
            
            //Refresh Token now
            
            refreshTokenApiHandler.refreshToken(with: token.refreshToken).subscribe { event in
                if let response = event.element, let unwrappedResponse = response {
                    //Save the token that was received
                    try? self.tokenManager.save(token: unwrappedResponse)
                }
                self.semaphore.signal()
            }.disposed(by: disposeBag)
            semaphore.wait()
        }
        
        return request
    }
    
}

typealias AccessToken = LoginRespnse
protocol AccessTokenManager {
    func save(token accessToken: AccessToken) throws
    func fetch() -> AccessToken?
}
