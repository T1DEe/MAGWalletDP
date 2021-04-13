//
//  BusinessLayerAssembly.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

class BusinessLayerAssembly {
    init(parent: Assembler) {
        let assemblies: [Assembly] = [ServicesAssembly(), CoreComponentAssembly(), ProxyAssembly()]
        parent.apply(assemblies: assemblies)
    }
}
