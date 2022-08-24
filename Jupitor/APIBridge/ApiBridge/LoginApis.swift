//
//  APIBridge.swift
//  APIBridge
//
//  Created by Hassan Aftab on 16.08.22.
//

import Foundation
import RxSwift
import Models

public protocol LoginApis {
    func login(with username: String, and password: String) -> Observable<LoginRespnse?>
    func refreshToken(with refreshToken: String) -> Observable<LoginRespnse?>
}
