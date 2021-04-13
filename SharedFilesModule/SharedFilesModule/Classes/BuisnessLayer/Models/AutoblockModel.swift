//
//  AutoblockModel.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum BlockTime: String {
    case dontBlock
    case thirtySeconds
    case oneMinute
    case twoMinutes
    
    public static func allValues() -> [BlockTime] {
        return [.dontBlock, .thirtySeconds, .oneMinute, .twoMinutes]
    }
    
    public func secondsValue() -> Double {
        switch self {
        case .dontBlock:
            return Double.greatestFiniteMagnitude

        case .thirtySeconds:
            return 30

        case .oneMinute:
            return 60

        case .twoMinutes:
            return 120
        }
    }
}

public struct AutoblockModel {
    public var timeString: String
    public var time: BlockTime
    public var isSelected: Bool
    
    public init(time: BlockTime, isSelected: Bool, timeString: String) {
        self.time = time
        self.isSelected = isSelected
        self.timeString = timeString
    }
}
