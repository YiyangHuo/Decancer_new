//
//  UserInfo.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/28/21.
//

import Foundation

class UserInfo: ObservableObject{
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    var isUserAuthenticated: FBAuthState = .undefined
}
