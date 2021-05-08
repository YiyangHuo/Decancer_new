//
//  ContentView.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/28/21.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @EnvironmentObject var unicontroller : UniversalController
    @EnvironmentObject var authrouter : AuthRouter
    
    
    init(){
        //UINavigationBar.appearance().backgroundColor = .
    }
    
    var body: some View {
        ZStack{
            MainView().background(EmptyView().sheet(isPresented: $unicontroller.display_login_page) {
                AuthView().environmentObject(unicontroller).environmentObject(authrouter).preferredColorScheme(.light)
            })
            if(unicontroller.display_loading_main){
                Loading().transition(AnyTransition.asymmetric(insertion: AnyTransition.opacity.animation(.easeIn(duration: 0.3)), removal: AnyTransition.opacity.animation(Animation.easeIn(duration: 0.3).delay(0.4))))
                    .allowsHitTesting(false)
            }
        }
       .preferredColorScheme(.light)
        .onAppear(){
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                sharedUser.shared.uid = user.uid
                
                sharedUser.shared.usremail = user.email ?? ""
                sharedUser.shared.photolink = user.photoURL?.absoluteString ?? ""
              // ...
            }
        }
        //ChatView()
        //DiagnoseView()
        //TestGeometry()
        //ProgressBar(progress:0.9)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


