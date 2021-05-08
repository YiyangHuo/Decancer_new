//
//  DataModel.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/30/21.
//

import Foundation
import Firebase
import GoogleSignIn
import Combine
import SwiftUI

struct sharedUser {
    static var shared = UserData()
}

class UserData: ObservableObject{
    @Published var authenticated = false
    @Published var uid = ""
    @Published var usremail = ""
    @Published var photolink = ""
    func signout() -> Bool {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
            return false
        }
        GIDSignIn.sharedInstance().signOut()
        
        return true
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}




