//
//  WebViewPresentable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public typealias ShowWebViewHandler = (_ url: URL) -> Void

public protocol WebViewPresentable: class {
    var showWebViewHandler: ShowWebViewHandler? { get set }
}
