//
//  File.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/4/21.
//

import Foundation
import SwiftUI

enum AuthPage:CaseIterable {
    case SignUp
    case Login
}

class AuthRouter: ObservableObject {
    
    @Published var currentPage: AuthPage
    @Published var logosize: CGFloat
    @Published var logsizeidentifier: [AuthPage: CGFloat] = [.SignUp: 80, .Login: 120]
    
   
    
    init() {
        self.logosize = 0
        self.currentPage = AuthPage.Login
        self.logosize = logsizeidentifier[AuthPage.Login]!
    }
    
    func changeto(authpage: AuthPage) {
        withAnimation(.spring()){
            self.objectWillChange.send()
            self.currentPage = authpage
            self.logosize = logsizeidentifier[authpage]!
        }
    }
    
    func goback(){
        self.changeto(authpage: .Login)
    }
    
    
}

class LoginViewController: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var lineThickness = CGFloat(2.0)
    var buttonColor: Color {
        return (self.email != "" && self.password != "") ? Color.The_Red : Color.Unselected_Text
    }
    
}

class SignupViewController: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirm_password = ""
    @Published var lineThickness = CGFloat(2.0)
    var buttonColor: Color {
        return (self.email != "" && self.password != "" && self.password == self.confirm_password) ? Color.The_Red : Color.Unselected_Text
    }
    
}
