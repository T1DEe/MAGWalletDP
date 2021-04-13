//
//  CommonService.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

final class CommonServiceImp: CommonService {
    let networkAdapter: CommonNetworkAdapter

    public init(networkAdapter: CommonNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
    
    func coins(completion: @escaping (Result<[String], CryptoApiError>) -> Void) {
        networkAdapter.coins(completion: completion)
    }
}
