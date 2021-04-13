//
//  FlowType.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public enum FlowType {
    case auth(needShowBack: Bool)
    case main(needShowBack: Bool)
    case send(Any?)
    case settings
}
