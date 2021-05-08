//
//  AuthView.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/30/21.
//

import Foundation
import SwiftUI
import GoogleSignIn


struct AuthView: View {
    @State private var showingSheet = false
    @EnvironmentObject var authrouter: AuthRouter
    @EnvironmentObject var unicontroller: UniversalController
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight:UIScreen.main.bounds.height/4).padding()
                google().frame(width:UIScreen.main.bounds.height/6, height:50)
                Text("or").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color.Unselected_Text).padding(10)
                VStack{
                    switch authrouter.currentPage {
                    case .Login:
                        LoginView().environmentObject(unicontroller).environmentObject(authrouter)
                    case .SignUp:
                        SignUpView().environmentObject(unicontroller).environmentObject(authrouter)
                    }
                }
                Spacer()
            }
            
            if(unicontroller.display_loading_sheet){
                Loading().transition(AnyTransition.asymmetric(insertion: AnyTransition.opacity.animation(.easeIn(duration: 0.3)), removal: AnyTransition.opacity.animation(Animation.easeIn(duration: 0.3).delay(0.4))))
                    .allowsHitTesting(false)
            }
        }
        //google().frame(width:UIScreen.main.bounds.height/6, height:50)
    }
}


struct LoginView: View {
    @ObservedObject var logincontroller = LoginViewController()
    @EnvironmentObject var authrouter: AuthRouter
    @EnvironmentObject var unicontroller: UniversalController
    var body: some View {
        VStack{
            VStack{
                TextField("Enter email", text:$logincontroller.email)
                HorizontalLine(color: Color.Unselected_Text)
            }.padding(.bottom, logincontroller.lineThickness).padding(.horizontal, 24).padding(.bottom, 24)
            VStack{
                SecureField("Enter password", text:$logincontroller.password)
                HorizontalLine(color: Color.Unselected_Text)
            }.padding(.bottom, logincontroller.lineThickness).padding(.horizontal, 24).padding(.top, 24)
            HStack{
                Spacer()
                Text("Forgot Password?").foregroundColor(Color.The_Red).padding(.horizontal, 24)
            }
            Button(action:{}){
                Text("Login")
                    .foregroundColor(.white).frame(width:UIScreen.main.bounds.width*3/4).padding()
                    .background(logincontroller.buttonColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5)).padding(20).shadow(color: logincontroller.buttonColor, radius:5 )
            }
            HStack(){
                Text("Don't have an account? ").foregroundColor(Color.Unselected_Text)
                Button(action:{
                    self.authrouter.changeto(authpage: AuthPage.SignUp)
                }) {
                    Text("Register Now").foregroundColor(Color.The_Red)
                }
            }
        }
    }
}

struct SignUpView: View {
    @ObservedObject var signupcontroller = SignupViewController()
    @EnvironmentObject var authrouter: AuthRouter
    @EnvironmentObject var unicontroller: UniversalController
    var body: some View {
        VStack{
            VStack{
                VStack{
                    TextField("Enter email", text:$signupcontroller.email)
                    HorizontalLine(color: Color.Unselected_Text)
                }.padding(.bottom, signupcontroller.lineThickness).padding(.horizontal, 24).padding(.bottom, 24)
                VStack{
                    TextField("Enter password", text:$signupcontroller.password)
                    HorizontalLine(color: Color.Unselected_Text)
                }.padding(.bottom, signupcontroller.lineThickness).padding(24)
                VStack{
                    TextField("Confirm password", text:$signupcontroller.confirm_password)
                    HorizontalLine(color: Color.Unselected_Text)
                }.padding(.bottom, signupcontroller.lineThickness).padding(24)
                Button(action:{}){
                    Text("Sign up and Log in")
                        .foregroundColor(.white).frame(width:UIScreen.main.bounds.width*3/4).padding()
                        .background(signupcontroller.buttonColor)
                        .clipShape(RoundedRectangle(cornerRadius: 5)).padding(20).shadow(color: signupcontroller.buttonColor, radius:5 )
                }
                HStack(){
                    Button(action:{
                        self.authrouter.changeto(authpage: AuthPage.Login)
                    }) {
                        Text("Back to Log in").foregroundColor(Color.The_Red)
                    }
                }
            }
        }
    }
}

struct google: UIViewRepresentable {
    @EnvironmentObject var unicontroller: UniversalController
    
    func makeUIView(context: Context) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.style = .standard
        button.colorScheme = .light
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<google>) {

    }
    
}
