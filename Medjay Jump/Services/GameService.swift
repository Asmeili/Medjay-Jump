//
//  GameService.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import QuartzCore

final class GameService {

    typealias OnGameLoopCallback = () -> Void
    
    private var display: CADisplayLink?
    private var callbacks: [OnGameLoopCallback]
    
    init() {
        display = nil
        callbacks = []
    }
    
    func setup() {
        display = CADisplayLink(target: self, selector: #selector(self.onLoop))
        
        if #available(iOS 15.0, *) {
            display?.preferredFrameRateRange = .default
        } else {
            display?.preferredFramesPerSecond = 1
        }
        
        display?.add(to: RunLoop.main, forMode: .common)
    }
    
    func destroy() {
        callbacks = []
        display?.invalidate()
        display = nil
    }
    
    @objc private func onLoop() {
        for callback in callbacks {
            callback()
        }
    }
    
    func loop(_ callback: @escaping OnGameLoopCallback) {
        callbacks.append(callback)
    }
}
