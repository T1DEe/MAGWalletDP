//
//  Constants.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum Constants {
    static let bundleIdentifier = "com.pixelplex.ETHModule"
    static let ethNetworkUrl = "https://697-crypto-api.pixelplexlabs.com/api"

    enum LottieConstants {
        static let lightLoader = "loaderLight"
        static let grayLoader = "loaderGray"
    }
    
    enum ETHConstants {
        static let ETHName = "Ethereum"
        static let ETH2ETH = "ae15465f"
        static let ETHPrefix = "0x"
        static let ETHDecimal = 18
        static let ETHDecimalString = "18"
        static let ETHSymbol = "ETH"
        static let ETHZeroBalance = "0"
        static let ETHStandartFee = "0.000021"
        
        static let ETHNetwork: ETHNetworkType = .rinkeby
        static let ETHUseOnlyDefaultNetwork = false
    }
    
    enum Keys {
        static let ethCurrentNetwork = "ethCurrentNetworkV011"
    }
    
    enum AuthConstants {
        static let keystorePass = "BANKEXFOUNDATION"
        static let savedWalletsKey = "kethWallet"
        static let seedKey = "kseedKey"
        static let seedWordsCount = 12
    }
    
    enum InfoConstants {
        static let balancesKey = "kethBalances"
        static let rateKey = "rateEthKey"
        static let tokenRateKey = "tokenEthRateKey"
        static let networkKey = "ethNetworkKey"
    }
    
    enum NotificationConstants {
        static let subscribeKey = "kEthSubscribeAddresses"
        static let possibleKey = "kEthPossibleAddresses"
    }
    
    enum ETHExplorerUrl {
        static let rinkeby = "https://rinkeby.etherscan.io"
    }
    
    enum CryptoApiConstants {
        static let authToken = "185c3b9f10ed72f5d39134d7f373b65d7b30bce43c7f96706f957ac4bed8f7dd"
    }
}
