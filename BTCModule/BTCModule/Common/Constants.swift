//
//  Constants.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum Constants {
    static let bundleIdentifier = "mag.magwallet.BTCModule"

    enum LottieConstants {
        static let lightLoader = "loaderLight"
        static let grayLoader = "loaderGray"
    }
    
    enum BTCConstants {
        static let BTCName = "Bitcoin"
        static let BTCSymbol = "BTC"
        static let BTCStandartFee = "1000"
        static let BTCWordsCount = 12
        static let BTCDerivationPathMainnet = "m/44'/0'/0'/0/0"
        static let BTCDerivationPathTestnet = "m/44'/1'/0'/0/0"
        static let BTCDecimal = 8
        static let BTCDecimalString = "8"
        static let BTCZeroBalance = "0"
        
        static let BTCNetwork: BTCNetworkType = .testnet
        static let BTCUseOnlyDefaultNetwork = false
    }
    
    enum AuthConstants {
        static let seedWordsCount = 12
        static let savedWalletsKey = "kbtcWallet"
        static let keystorePass = "BANKEXFOUNDATION"
        static let seedKey = "kseedKey"
    }
    
    enum InfoConstants {
        static let balancesKey = "kbtcBalances"
        static let rateKey = "rateBtcKey"
        static let networkKey = "btcNetworkKey"
    }
    
    enum CryptoApiConstants {
        static let authToken = "185c3b9f10ed72f5d39134d7f373b65d7b30bce43c7f96706f957ac4bed8f7dd"
    }
    
    enum NotificationConstants {
        static let subscribeKey = "kBtcSubscribeAddresses"
        static let possibleKey = "kBtcPossibleAddresses"
    }
    
    enum BTCExplorers {
        static let mainnet = "https://live.blockcypher.com/btc"
        static let testnet = "https://live.blockcypher.com/btc-testnet"
    }
}
