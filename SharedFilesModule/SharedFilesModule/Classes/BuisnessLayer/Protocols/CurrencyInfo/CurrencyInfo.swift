//
//  CurrencyInfo.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

// MARK: Передача информации о валюте и доп плюхах из модуля
//(Как пример на общем экране валют, что-то надо показывать, поэтому модуль должен предоставлять инфу о своей валюте)

public typealias CurrencyInfoCompletionHandler<T> = (_ result: Result<T, CurrencyInfoError>) -> Void

public protocol CurrencyInfo {
    func getCurrency() -> Currency
    func getBalance(completion: @escaping CurrencyInfoCompletionHandler<CurrencyBalance>)
    func getRate(completion: @escaping CurrencyInfoCompletionHandler<CurrencyRate>)
    func getRatesHistory(completion: @escaping CurrencyInfoCompletionHandler<CurrencyRateHistory>)
}
