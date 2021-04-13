//
//  RedirectFlowModel.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public protocol RedirectableFlowEntity {
    var destinationFlow: FlowType { get }
    var sourceFlow: FlowType { get }
}
