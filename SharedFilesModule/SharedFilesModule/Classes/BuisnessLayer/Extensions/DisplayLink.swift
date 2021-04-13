//
//  DisplayLink.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public protocol DisplayUpdateReceiver: class {
    func displayWillUpdate(deltaTime: CFTimeInterval)
}

public class DisplayUpdateNotifier {
    // **********************************************
    // MARK: - Variables
    // **********************************************
    
    /// A weak reference to the delegate/listener that will be notified/called on display updates
    weak var listener: DisplayUpdateReceiver?
    
    /// The display link that will be initiating our updates
    internal var displayLink: CADisplayLink?
    
    /// Tracks the timestamp from the previous displayLink call
    internal var lastTime: CFTimeInterval = 0.0
    
    // **********************************************
    // MARK: - Setup & Tear Down
    // **********************************************
    
    deinit {
        stopDisplayLink()
    }
    
    public init(listener: DisplayUpdateReceiver) {
        // setup our delegate listener reference
        self.listener = listener
        
        // setup & kick off the display link
        //startDisplayLink()
    }
    
    // **********************************************
    // MARK: - CADisplay Link
    // **********************************************
    
    /// Creates a new display link if one is not already running
    public func startDisplayLink() {
        guard displayLink == nil else {
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(linkUpdate))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
        lastTime = 0.0
    }
    
    /// Invalidates and destroys the current display link. Resets timestamp var to zero
    public func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        lastTime = 0.0
    }
    
    /// Notifier function called by display link. Calculates the delta time and passes it in the delegate call.
    @objc
    private func linkUpdate() {
        // bail if our display link is no longer valid
        guard let displayLink = displayLink else {
            return
        }
        
        // get the current time
        let currentTime = displayLink.timestamp
        
        // calculate delta (
        let delta: CFTimeInterval = currentTime - lastTime
        
        // store as previous
        lastTime = currentTime
        
        // call delegate
        listener?.displayWillUpdate(deltaTime: delta)
    }
}
