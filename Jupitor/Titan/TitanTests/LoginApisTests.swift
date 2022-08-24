//
//  LoginApisTests.swift
//  TitanTests
//
//  Created by Hassan Aftab on 22.08.22.
//

import XCTest
import Moya
import RxSwift
import ApiBridge
@testable import Titan

class LoginApisTests: XCTestCase {
    
    var anyProvider: AnyProvider<LoginApi>!
    var loginManager: LoginApiManager!
    var disposeBag = DisposeBag()
    override func setUpWithError() throws {
        anyProvider = AnyProvider(MockLoginProvider(networkConfig: MockTitan()))
        loginManager = LoginApiManager(anyProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() throws {
        // given the email and password
        let email = "sometestemail@hassan.com"
        let password = "testpassword"
        
        // when the api is called
        let res = loginManager.login(with: email, and: password)
        
        // correct response is fetched
        let expectation = expectation(description: "wait for response in the block")
        res.subscribe { loginResponse in
            if loginResponse.isCompleted {
                expectation.fulfill()
            } else {
                XCTAssertEqual(loginResponse.event.element??.accessToken, "someaccesstoken")
            }
        }.disposed(by: disposeBag)

        waitForExpectations(timeout: 3)
        
    }
}

class MockLoginProvider: OnlineProvider {
    
    typealias T = LoginApi
    var provider: MoyaProvider<LoginApi>
    var networkConfig: NetworkManager
    
    init(networkConfig: NetworkManager,
         endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.immediatelyStub,
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
class MockTitan: NetworkManager {
    var configurations: NetworkConfig {
        NetworkConfigImpl(with: [
            "BASEURL_WITH_SUBDOMAIN" : "%@-api.%@.stg.portal.restaurant/"
        ])
    }
}
