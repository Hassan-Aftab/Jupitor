//
//  Titan.swift
//  Titan
//
//  Created by Hassan Aftab on 17.08.22.
//

import RxSwift
import Moya
import RxMoya
import ApiBridge

final class LoginProvider: OnlineProvider {
        
    typealias T = LoginApi
    var provider: MoyaProvider<LoginApi>
    var networkConfig: NetworkManager
    
    init(networkConfig: NetworkManager,
         endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        provider = MoyaProvider(endpointClosure: endpointClosure,
                                requestClosure: requestClosure,
                                stubClosure: stubClosure,
                                callbackQueue: nil,
                                plugins: plugins,
                                trackInflights: trackInflights)
        self.networkConfig = networkConfig
    }
    
    func requestWithoutAuthentication(target: LoginApi) -> Single<Response> {
        provider.rx.request(target)
    }
    
    func requestWithAuthentication(target: LoginApi, token: String) -> Single<Response> {
        
        let authToken = AccessTokenPlugin { _ in
            token
        }
        
        provider = MoyaProvider(endpointClosure: provider.endpointClosure,
                                requestClosure: provider.requestClosure,
                                stubClosure: provider.stubClosure,
                                plugins: provider.plugins + [authToken],
                                trackInflights: provider.trackInflights)
        
        return provider.rx.request(target)
    }
    
}
