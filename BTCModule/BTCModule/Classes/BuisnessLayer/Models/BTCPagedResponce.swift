//
//  BTCPagedResponce.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct BTCPagedResponse<T: Any> {
    let totalResults: Int
    let data: [T]
}
