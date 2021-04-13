//
//  SessionExpireEventProxyImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public final class SessionExpireEventProxyImp: SessionExpireEventProxy {
    weak public var timeoutDelegate: SessionTimeoutDelegate? {
        didSet {
            timeoutDelegates.addObject(timeoutDelegate)
        }
    }
    
    var sharedStorage: StorageCore!
    
    private var timer: RepeatingTimer?
    private var localTime: Double?
    private var experationTime: Double {
        if let localTime = localTime {
            return localTime
        }

        if let currentTimeString = sharedStorage.get(key: Constants.SharedKeys.autoblockTime),
            let state = BlockTime(rawValue: currentTimeString) {
            return state.secondsValue()
        } else {
            return Constants.Settings.defautTimeoutForSessionExpiration.secondsValue()
        }
    }
    private var expireDelegates = NSPointerArray.weakObjects()
    private var timeoutDelegates = NSPointerArray.weakObjects()
    private var isStopped = false
    
    public func preventSeesionExpireAction() {
        try? sharedStorage.set(key: Constants.SharedKeys.lastSessionPreventInterval,
                               value: String(Date.timeIntervalSinceReferenceDate))
        
        if isStopped == false {
            checkExpiration()
        }
    }
    
    public func expirationTimeDidChange() {
        preventSeesionExpireAction()
    }

    public func setLocalExpireTime(time: BlockTime) {
        localTime = time.secondsValue()
        preventSeesionExpireAction()
    }

    public func removeLocalExpireTime() {
        localTime = nil
        preventSeesionExpireAction()
    }
    
    public func startMonitoring() {
        stopMonitoring()
        
        isStopped = false
        
        let nextUpdateTime: Double = Double(experationTime)
        
        let timer = RepeatingTimer()
        timer.expireTime = nextUpdateTime
        timer.eventHandler = {  [weak self] in
            self?.checkExpiration()
        }
        
        timer.resume()
        self.timer = timer
    }
    
    public func stopMonitoring() {
        guard let timer = timer else {
            return
        }
        
        timer.suspend()
        self.timer = nil
        isStopped = true
    }
    
    public func isSessionExpire() -> Bool {
        let aSecondsSinceLastPreventAction = secondsSinceLastPreventAction()
        
        return aSecondsSinceLastPreventAction >= experationTime
    }
    
    func actionSessionDidTimeout() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            // swiftlint:disable empty_count
            if self.timeoutDelegates.count > 0 {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            // swiftlint:enable empty_count
            
            self.timeoutDelegates.compact()
            
            for index in 0..<self.timeoutDelegates.count {
                if let delegate = self.timeoutDelegates.object(at: index) as? SessionTimeoutDelegate {
                    delegate.sessionActivityTimeout()
                }
            }
        }
    }
    
    private func secondsSinceLastPreventAction() -> Double {
        let secondsSinceLastPreventAction: String? = sharedStorage.get(key: Constants.SharedKeys.lastSessionPreventInterval)
        if let secondsSinceLastPreventAction = secondsSinceLastPreventAction,
            let lastFailedTime = Double(secondsSinceLastPreventAction) {
            let now = Date.timeIntervalSinceReferenceDate
            let difference = now - lastFailedTime
            return difference
        } else {
            return -1
        }
    }
    
    private func checkExpiration() {
        let aSecondsSinceLastPreventAction = secondsSinceLastPreventAction()
        
        startMonitoring()
        
        if aSecondsSinceLastPreventAction >= experationTime {
            actionSessionDidTimeout()
        }
    }
}
