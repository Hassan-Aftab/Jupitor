//
//  OnlineProvider.swift
//  ApiBridge
//
//  Created by Hassan Aftab on 22.08.22.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import ApiBridge

final class AnyProvider<T: TargetType>: OnlineProvider {
    
    typealias U = T
    
    var provider: MoyaProvider<T> {
        _provider()
    }
    
    var networkConfig: NetworkManager {
        _networkConfig()
    }
    
    private var _provider: () -> MoyaProvider<T>
    private var _networkConfig: () -> NetworkManager
    private var _requestWithoutAuthentication: (_ target: T) -> Single<Response>
    private var _requestWithAuthentication: (_ target: T, _ token: String) -> Single<Response>
    
    init<OP: OnlineProvider>(_ newProvider: OP) where OP.U == U {
        
        _provider = { newProvider.provider }
        _networkConfig = { newProvider.networkConfig }
        self._requestWithoutAuthentication = {
            newProvider.requestWithoutAuthentication(target: $0)
        }
        self._requestWithAuthentication = {
            newProvider.requestWithAuthentication(target: $0, token: $1)
        }
    }
    
    func requestWithoutAuthentication(target: T) -> Single<Response> {
        self._requestWithoutAuthentication(target)
    }
    
    func requestWithAuthentication(target: U, token: String) -> Single<Response> {
        self._requestWithAuthentication(target, token)
    }
}

protocol OnlineProvider {
    associatedtype U: TargetType
    var provider: MoyaProvider<U> { get }
    var networkConfig: NetworkManager { get }
    
    func requestWithoutAuthentication(target: U) -> Single<Response>

    func requestWithAuthentication(target: U, token: String) -> Single<Response>
}
