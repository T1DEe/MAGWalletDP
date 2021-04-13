//
//  ApplicationAssembler.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import Swinject

public class ApplicationAssembler {
    public let assembler: Assembler
    public static let shared = ApplicationAssembler()

    private init() {
        let assembler = Assembler([])
        _ = BusinessLayerAssembly(parent: assembler)
        self.assembler = assembler
    }
}
