//
//  FlowEndReason.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public enum FlowEndReason {
    case canceled(needDismiss: Bool)
    case completed
    case needAuth
    case redirect(entity: RedirectableFlowEntity)
}
