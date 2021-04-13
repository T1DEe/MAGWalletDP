//
//  ModularSubflow.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

//общий тип для строгой типизации конструктора
public typealias SubflowsCore = (
    main: SubflowsCoreItem,
    auth: SubflowsCoreItem,
    send: SubflowsCoreItem,
    settingOptions: [SettingsType]
)

public typealias ModuleFlowsCompletionHandler<T> = (_ result: Result<T, ModuleFlowError>) -> Void

public struct SubflowsCoreItem { //элемент какой-то независимой единицы во флоу, по типу main, auth, history и тд
    let type: FlowType
    let module: SubflowModule
}

//протокол для основного взаимодействия с сабкошельками
public protocol ModularSubflow: AccountInfo, SecureData, SnackBarsPresent, ChangePinRequirable,
                                SettingConfiguratable, Clearable, NetworkConfigurable, WebViewPresentable, Notifiable {
    var didFinishAllFlows: (() -> Void)? { get set } //используется для завершения всего, например логаут,
    
    var didEndFlow: ((_ flow: FlowType, _ reason: FlowEndReason) -> Void)? { get set } //нужно понимать, какой флоу закончился
    var didSelectFlow: ((_ flow: FlowType) -> Void)? { get set } //нужно понимать, какой флоу выбрал пользователь
    
    var currentFlow: FlowType { get set } //чтобы завершить флоу нужно занть какой сейчас идет
    
    func getFlow(type: FlowType) -> SubflowModule
    func finishFlow()
}

public protocol SubflowModule: class { //протокол для обобщения наших вайпер модулей
    var viewController: UIViewController { get }
}
