//
//  FirebaseServiceImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Firebase
import FirebaseMessaging
import Foundation
import SharedFilesModule

class FirebaseServiceImp: NSObject, FirebaseService {
    private var fireBaseInfoFileName = "GoogleService-Info"
    var sharedStorage: StorageCore!
    var firebaseTokenActionHandler: FirebaseTokenActionHandler!
    
    var token: String? {
        get {
            return sharedStorage.get(key: SharedFilesModule.Constants.SharedKeys.firebaseToken)
        }
        set {
            if let newValue = newValue {
                try? sharedStorage.set(key: SharedFilesModule.Constants.SharedKeys.firebaseToken, value: newValue)
            } else {
                sharedStorage.remove(key: SharedFilesModule.Constants.SharedKeys.firebaseToken)
            }
        }
    }
    
    var previousToken: String? {
        get {
            return sharedStorage.get(key: SharedFilesModule.Constants.SharedKeys.previousFirebaseToken)
        }
        set {
            if let newValue = newValue {
                try? sharedStorage.set(key: SharedFilesModule.Constants.SharedKeys.previousFirebaseToken, value: newValue)
            } else {
                sharedStorage.remove(key: SharedFilesModule.Constants.SharedKeys.previousFirebaseToken)
            }
        }
    }
    
    func configure() {
        if let path = Bundle.main.path(forResource: fireBaseInfoFileName, ofType: "plist") {
            if let _ = NSDictionary(contentsOfFile: path) {
                if let option = FirebaseOptions(contentsOfFile: path) {
                    FirebaseApp.configure(options: option)
                    Messaging.messaging().delegate = self
                }
            }
        }
    }
}

extension FirebaseServiceImp: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.previousToken = self?.token
            self?.token = fcmToken
            if let fcmToken = fcmToken {
                self?.firebaseTokenActionHandler.actionChangeFirebaseToken(newToken: fcmToken, previousToken: self?.previousToken)
            }
        }
    }
}
