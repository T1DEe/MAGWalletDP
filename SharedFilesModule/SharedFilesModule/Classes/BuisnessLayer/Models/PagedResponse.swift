//
//  PagedResponse.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct PagedResponse<T: Any> {
    public let isFull: Bool
    public var data: [T]
    
    public init(isFull: Bool, data: [T]) {
        self.isFull = isFull
        self.data = data
    }
}
