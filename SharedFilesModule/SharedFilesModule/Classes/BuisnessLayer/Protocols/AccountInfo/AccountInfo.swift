//
//  AccountInfo.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

// MARK: Инфо о залогиненом аккаунте
public typealias AccountInfoCompletionHandler<T> = (_ result: Result<T, AccountInfoError>) -> Void

public protocol AccountInfo: class {
    func getAccountsTitle() -> String
    
    func hasAccounts() -> Bool
    func obtainCurrentAccount() throws -> String
    func obtainAccounts() throws -> [String]
    func selectAccount(_ account: String) throws
    func deleteAccount(_ account: String) throws
    
    func obtainWalletIcon() -> UIImage
    func obtainWalletName() -> String
    func obtainWalletCurrency() -> String
    func obtainTokenName() throws -> String
    func obtainTokenCurrency() throws -> String
    
    func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>)
    func obtainCurrentTokenBalance(completion: @escaping AccountInfoCompletionHandler<String>)
    
    func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>)
    func obtainTokenBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>)
    
    func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>)
    func obtainTokenRate(completion: @escaping AccountInfoCompletionHandler<String>)
}
