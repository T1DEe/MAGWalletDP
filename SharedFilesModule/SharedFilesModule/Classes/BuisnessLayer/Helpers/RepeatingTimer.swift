//
//  RepeatingTimer.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class RepeatingTimer {
    private lazy var timer: DispatchSourceTimer = {
        let aTimer = DispatchSource.makeTimerSource()
        aTimer.schedule(deadline: .now() + expireTime)
        aTimer.setEventHandler { [weak self] in
            self?.eventHandler?()
        }
        return aTimer
    }()
    
    var eventHandler: (() -> Void)?
    var expireTime: Double = 10
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
