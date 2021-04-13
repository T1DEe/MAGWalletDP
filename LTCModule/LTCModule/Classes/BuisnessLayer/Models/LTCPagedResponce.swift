//
//  LTCPagedResponce.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct LTCPagedResponse<T: Any> {
    let totalResults: Int
    let data: [T]
}
