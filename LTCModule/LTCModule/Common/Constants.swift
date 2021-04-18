//
//  Constants.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum Constants {
    static let bundleIdentifier = "mag.magwallet.LTCModule"

    enum LottieConstants {
        static let lightLoader = "loaderLight"
        static let grayLoader = "loaderGray"
    }
    
    enum LTCConstants {
        static let LTCName = "Litecoin"
        static let LTCSymbol = "LTC"
        static let LTCStandartFee = "1000"
        static let LTCWordsCount = 12
        static let LTCDerivationPathMainnet = "m/44'/0'/0'/0/0"
        static let LTCDerivationPathTestnet = "m/44'/1'/0'/0/0"
        static let LTCDecimal = 8
        static let LTCDecimalString = "8"
        static let LTCZeroBalance = "0"
        
        static let LTCNetwork: LTCNetworkType = .testnet
        static let LTCUseOnlyDefaultNetwork = false
    }
    
    enum AuthConstants {
        static let seedWordsCount = 12
        static let savedWalletsKey = "kltcWallet"
        static let keystorePass = "BANKEXFOUNDATION"
        static let seedKey = "kseedKey"
    }
    
    enum InfoConstants {
        static let balancesKey = "kltcBalances"
        static let rateKey = "rateLtcKey"
        static let networkKey = "ltcNetworkKey"
    }
    
    enum CryptoApiConstants {
        static let authToken = "185c3b9f10ed72f5d39134d7f373b65d7b30bce43c7f96706f957ac4bed8f7dd"
    }
    
    enum NotificationConstants {
        static let subscribeKey = "kLtcSubscribeAddresses"
        static let possibleKey = "kLtcPossibleAddresses"
    }
    
    enum LTCExplorers {
        static let root = "https://sochain.com/"
        static let mainnetPath = "LTC"
        static let testnetPath = "LTCTEST"
    }
}
