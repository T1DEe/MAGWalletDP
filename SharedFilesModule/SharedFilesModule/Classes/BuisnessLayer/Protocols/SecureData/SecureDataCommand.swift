//
//  SecureDataCommand.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum SecureDataCommandError: Error {
    case handlerNotSettup
    case userCanceled
    case encryptionError
    case storageError
}

public typealias SecureDataCommandCompletionHandler<T> = (_ result: Result<T, SecureDataCommandError>) -> Void

public class SecureDataCommand {
    public let key: String
    public let completion: SecureDataCommandCompletionHandler<String>
    
    public init(key: String, completion: @escaping SecureDataCommandCompletionHandler<String>) {
        self.key = key
        self.completion = completion
    }
}

public final class SecureDataStoreCommand: SecureDataCommand {
    public let value: String
    
    public init(value: String,
                key: String,
                completion: @escaping SecureDataCommandCompletionHandler<String>) {
        self.value = value
        super.init(key: key, completion: completion)
    }
}

public final class SecureDataLoadCommand: SecureDataCommand {
}

public final class SecureDataRemoveCommand: SecureDataCommand {
}
