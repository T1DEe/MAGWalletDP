//
//  Notifiable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum NotifiableInfoError: Error {
    case innerError
    case notSupported // method not supported in module
}

public typealias NotifiableCompletionHandler<T> = (_ result: Result<T, NotifiableInfoError>) -> Void

public protocol Notifiable {
    func subscribeAll(completion: @escaping NotifiableCompletionHandler<Void>)
    func unsubscribeAll(clearPossibleAddresses: Bool, completion: @escaping NotifiableCompletionHandler<Void>)
    func updateAll(completion: @escaping NotifiableCompletionHandler<Void>)
    func subscribeAddress(address: String, completion: @escaping NotifiableCompletionHandler<Void>)
    func unsubscribeAddress(address: String, completion: @escaping NotifiableCompletionHandler<Void>)
}
