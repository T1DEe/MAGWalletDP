//
//  AutoblockAutoblockInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class AutoblockInteractor {
    weak var output: AutoblockInteractorOutput!
    var sharedStorage: StorageCore!
    var preventExpireActionHandler: SessionExpirePreventActionHandler!
}

// MARK: - AutoblockInteractorInput

extension AutoblockInteractor: AutoblockInteractorInput {
    func getBlockTimes() -> [AutoblockModel] {
        var models = [AutoblockModel]()
        let blockTimes = BlockTime.allValues()
        let currenctBlockTime = getCurrenctAutoblockTime()
        blockTimes.forEach { time in
            let currentBlockTimeString = getCurrenctAutoblockTimeString(time: time)
            models.append(AutoblockModel(time: time, isSelected: time == currenctBlockTime, timeString: currentBlockTimeString))
        }
        return models
    }
    
    func getCurrenctAutoblockTime() -> BlockTime {
        if let currentTimeString = sharedStorage.get(key: SharedFilesModule.Constants.SharedKeys.autoblockTime),
            let state = BlockTime(rawValue: currentTimeString) {
            return state
        } else {
            return SharedFilesModule.Constants.Settings.defautTimeoutForSessionExpiration
        }
    }
    
    func getCurrenctAutoblockTimeString(time: BlockTime) -> String {
        switch time {
        case .dontBlock:
            return R.string.localization.blockTimeNoBlock()

        case .thirtySeconds:
            return R.string.localization.blockTimeSeconds("30")

        case .oneMinute:
            return R.string.localization.blockTimeMinute("1")

        case .twoMinutes:
            return R.string.localization.blockTimeMinutes("2")
        }
    }
    
    func saveCurrentAutoblockTime(time: BlockTime) {
        try? sharedStorage.set(key: SharedFilesModule.Constants.SharedKeys.autoblockTime, value: time.rawValue)
        preventExpireActionHandler.expirationTimeDidChange()
    }
}
