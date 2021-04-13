//
//  MainMainProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum ContainerOffsetsConstant {
    static let topOffset: CGFloat = 44
    static let boottomOffset: CGFloat = 231
    static let walletAnimationHeight: CGFloat = 225
}

protocol MainViewInput: class, Presentable {
    func setupInitialState(root: MainRootType)
    func setupScrollOffset(offset: CGFloat)
    func setupAutoScroll()
}

typealias MainRootType = (
    wallet: UIViewController,
    history: UIViewController
)

protocol MainViewOutput {
    func viewIsReady()
    func actionSend()
    func actionReceive()
    func topContainerHeightChanged(height: CGFloat)
}

protocol MainModuleInput: SubflowModule {
	var viewController: UIViewController { get }
	var output: MainModuleOutput? { get set }
    var needShowBack: Bool { get set }
}

protocol MainModuleOutput: class {
    func didSelectSettings()
    func didSelectSend()
    func didSelectBack()
    func didScan(scanEntity: ScanEntity)
    func didSelectExplorer(url: URL)
}

protocol MainInteractorInput {
}

protocol MainInteractorOutput: class {
}

protocol MainRouterInput {
    func obtainRoots(walletOutput: WalletModuleOutput,
                     historyOutput: HistoryModuleOutput) -> MainRootType
    
    func obtainWalletModule(output: WalletModuleOutput) -> WalletModuleInput
    func obtainHistoryModule(output: HistoryModuleOutput) -> HistoryModuleInput
    func presentReceive()
    func presentScan(output: ScanModuleOutput)
}
