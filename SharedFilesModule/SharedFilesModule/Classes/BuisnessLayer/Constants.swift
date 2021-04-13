//
//  Constants.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public enum Constants {
    public enum SharedKeys {
        public static let isFingerprintOn = "kisFingerprintOn"
        public static let blockTime = "kBlockTime"
        public static let lastSessionPreventInterval = "klastSessionPreventInterval"
        public static let autoblockTime = "kAutoblockTime"
        public static let notificationStatus = "kNotificationStatus"
        public static let firebaseToken = "kFirebaseToken"
        public static let previousFirebaseToken = "kPreviousFirebaseToken"
    }
    
    enum Keys {
        static let walletsPublicDataMap = "kWalletsPublicDataMap"
        static let fingerprint = "kFingerprint"
    }
    
    public enum Settings {
        public static let defautTimeoutForSessionExpiration: BlockTime = BlockTime.thirtySeconds
    }
    
    public enum USDCurrency {
        public static let symbol = "$"
        public static let decimals = 2
        public static let name = "usd"
    }
}
