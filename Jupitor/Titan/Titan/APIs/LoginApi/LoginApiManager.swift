//
//  LoginApiManager.swift
//  Titan
//
//  Created by Hassan Aftab on 18.08.22.
//

import Moya
import RxMoya
import RxSwift
import ApiBridge
import Models

public final class LoginApiManager:LoginApis {
    
    let provider: AnyProvider<LoginApi>
    
    init(_ provider: AnyProvider<LoginApi>) {
        self.provider = provider
    }
    
    public func login(with username: String, and password: String) -> Observable<LoginRespnse?>  {
        let api = LoginApi.login(username: username, password: password)
        guard let baseUrl = provider.networkConfig.configurations.baseUrl else {
            fatalError("Base URL not found")
        }
        
        LoginApi.baseUrlString = baseUrl
        
        return provider.requestWithoutAuthentication(target: api).asObservable().filterSuccessfulStatusCodes().map { response -> LoginRespnse? in
            return try? JSONDecoder().decode(LoginRespnse.self, from: response.data)
        }
    }
    public func refreshToken(with param: String) -> Observable<LoginRespnse?> {
        return Observable.just(nil)
    }

}

