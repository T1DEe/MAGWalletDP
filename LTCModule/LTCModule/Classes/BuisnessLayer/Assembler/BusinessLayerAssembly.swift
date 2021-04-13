//
//  BusinessLayerAssembly.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

class BusinessLayerAssembly {
    init(parent: Assembler) {
        let assemblies: [Assembly] = [ServicesAssembly(), CoreComponentAssembly(), ProxyAssembly(), FacadesAssembly()]
        parent.apply(assemblies: assemblies)
    }
}
