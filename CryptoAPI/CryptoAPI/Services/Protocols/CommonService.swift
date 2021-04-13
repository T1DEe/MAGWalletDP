//
//  CommonService.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public protocol CommonService {
/**
    Get Coins
    - Parameter completion: Callback which returns an [[String]]([String]) result  or error
*/
    func coins(completion: @escaping (Result<[String], CryptoApiError>) -> Void)
}
