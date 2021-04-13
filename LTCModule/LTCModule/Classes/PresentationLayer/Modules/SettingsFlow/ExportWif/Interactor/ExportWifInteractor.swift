//
//  ExportBrainkeyExportBrainkeyInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class ExportBrainkeyInteractor {
    weak var output: ExportBrainkeyInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
}

// MARK: - ExportBrainkeyInteractorInput

extension ExportBrainkeyInteractor: ExportBrainkeyInteractorInput {
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
}
