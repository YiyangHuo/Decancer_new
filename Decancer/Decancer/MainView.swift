//
//  MainView.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/30/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    @State var display_setting = false
    @State var display_chatview = false
    @State var display_diagnoseview = false
    @State var isNavigationBarHidden: Bool = false
    @EnvironmentObject var unicontroller: UniversalController
    @State var scale:CGFloat = 1
    var gradient: Gradient {
               let stops: [Gradient.Stop] = [
                .init(color: Color.Theme_Image, location: 0.5),
                .init(color: Color.Theme_Chatbot, location: 0.5)
               ]
               return Gradient(stops: stops)
           }
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    VStack{
                        HStack{
                            Spacer() // UserView(
                            NavigationLink(destination: UserView(),isActive: $display_setting) {
                                Image(systemName: "person")
                                       .resizable()
                                        .shadow(radius: 30)
                                       .frame(width: 50, height: 50)
                                       .padding(.trailing, 30)
                                       .padding(20)
                                    .foregroundColor(Color.white)

                                    
                            }
                        }.padding(.top, 100)
                        Spacer()
                    }.edgesIgnoringSafeArea(.all)

                   
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            NavigationLink(destination: ChatView(isNavigationBarHidden: $isNavigationBarHidden),isActive: $display_chatview) {
                                ZStack{
                                    Triangle()
                                        .fill(Color.gray)
                                        .frame(width: 216*scale, height: 100*scale)
                                        .offset(x:100, y:-12.5)
                                    ZStack{
                                        Triangle()
                                            .fill(Color.Theme_Chatbot)
                                            .frame(width: 216*scale, height: 100*scale)
                                        Image(systemName: "message").resizable().scaledToFit().foregroundColor(Color.white).frame(width:40*scale,height:40*scale).offset(x: -216/4, y:0)
                                    }
                                        .offset(x:90*scale, y:-20*scale)
                                        .shadow(radius: 30*scale)

                                    
                                }
                               
                                    
                                    //.rotationEffect(.degrees(90))
                                    
                            }
                            
                            
                            NavigationLink(destination:DiagnoseView(),isActive: $display_diagnoseview) {
                                ZStack{
                                    
                                    Triangle(isleft: false)
                                        .fill(Color.gray)
                                        .frame(width: 216*scale, height: 100*scale)
                                        .offset(x:-100*scale, y:12.5*scale)
                                    ZStack{
                                        Triangle(isleft: false)
                                            .fill(Color.Theme_Image)
                                            .frame(width: 216*scale, height: 100*scale)
                                        Image(systemName: "camera").resizable().scaledToFit().foregroundColor(Color.white).frame(width:40*scale,height:40*scale).offset(x: 216/4, y:0)
                                    }
                                   
                                        .offset(x:-90*scale,y:20*scale)
                                        .shadow(radius: 30*scale)

                                }
                                
                                    //.rotationEffect(.degrees(-90))
                            }


                            Spacer()
                        }
                        Spacer()
                    }.edgesIgnoringSafeArea(.all)
                    
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(self.isNavigationBarHidden)
            .background(
                LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor( Color.The_light_user)
        
       
    }
}


struct UserView: View {
    @EnvironmentObject var unicontroller: UniversalController
    @State var Message = ""
    @State var display_history = false
    var thegradient: Gradient {
               let stops: [Gradient.Stop] = [
                .init(color: Color.gradient4, location: 0.25),
                .init(color: Color.gradient3, location: 0.25),
                .init(color: Color.gradient3, location: 0.5),
                .init(color: Color.gradient2, location: 0.5),
                .init(color: Color.gradient2, location: 0.75),
                .init(color: Color.gradient1, location: 0.75),
               ]
               return Gradient(stops: stops)
           }
    var body: some View {
        ZStack{
            VStack{
               
                VStack{
                    if sharedUser.shared.photolink == "" {
                        Image("Avatar_default")
                            .resizable()
                            .scaledToFit()
                            .frame(width:UIScreen.main.bounds.width/4, height:UIScreen.main.bounds.width/4)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 8))
                            .shadow(radius: 10)
                    } else {
                        WebImage(url:URL(string: sharedUser.shared.photolink))
                            .resizable()
                            .scaledToFit()
                            .frame(width:UIScreen.main.bounds.width/4, height:UIScreen.main.bounds.width/4)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 8))
                            .shadow(radius: 10)
                    }
                    
                    VStack{
                        if sharedUser.shared.authenticated{
                            Text(sharedUser.shared.usremail).foregroundColor(Color.white).padding(5)
                        } else {
                            Button(action:{
                                unicontroller.display_login_page = true
                            }) {
                                Text("Press to log in").foregroundColor(Color.white).padding(5)
                            }
                        }
                        
                    }.frame(minWidth: UIScreen.main.bounds.width/5).padding(5).background(sharedUser.shared.authenticated ? Color.gradient2 : Color.Unselected_Text )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white, lineWidth: 5))
                    .padding(.top, 20)
                    .shadow(radius: 10)
                    
                    
                    
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height*2/5)
                .offset(x: 0, y: -50)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.gradient5, .gradient5]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.top)
                )
                Spacer()
            }
            VStack{
                Spacer()
                VStack{
                    
                    if(sharedUser.shared.authenticated){
                        HStack{
                            Button(action:{
                                sharedUser.shared.objectWillChange.send()
                                DispatchQueue.main.async {
                                    if (sharedUser.shared.signout()){
                                        withAnimation(){
                                            sharedUser.shared.authenticated = false
                                            sharedUser.shared.uid = ""
                                            sharedUser.shared.usremail = ""
                                            sharedUser.shared.photolink = ""
                                            self.Message = "Successfully signed out"
                                        }
                                       
                                        sharedUser.shared.objectWillChange.send()
                                    }
                                }
                                
                            }) {
                                VStack{
                                    Image(systemName:"escape").resizable().scaledToFit().frame(width:60, height:60)
                                    Text("Logout").fontWeight(.bold)
                                }.foregroundColor(Color.white)
                                .shadow(color:Color.white, radius: 25)
                                .padding(.bottom, UIScreen.main.bounds.width*1/3)
                               
                            }.transition(.slide)
                            NavigationLink(destination:RecordView(),isActive: $display_history) {
                                VStack{
                                    Image(systemName:"clock").resizable().scaledToFit().frame(width:60, height:60)
                                    Text("History\nRecords").fontWeight(.bold).multilineTextAlignment(.center)
                                }.foregroundColor(Color.white)
                                .shadow(color:Color.white, radius: 25)
                                .padding(.top, UIScreen.main.bounds.width*1/3)
                                    
                            }.transition(.slide)
                        }
                        
                    } else {
                        Button(action:{
                            unicontroller.display_login_page = true
                        }) {
                            VStack{
                                Image(systemName:"network").resizable().scaledToFit().frame(width:60, height:60)
                                Text("Log in for more").fontWeight(.bold).multilineTextAlignment(.center)
                            }.foregroundColor(Color.white)
                            .shadow(color:Color.white, radius: 25)
                        }.transition(.scale)
                    }
                    

                }.frame(width:UIScreen.main.bounds.width*8/9, height:UIScreen.main.bounds.height*2/3)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient(gradient: thegradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.vertical)
                )
//                .clipShape( RoundedRectangle(cornerRadius: 25)
//                                .fill(Color.white)
//                                .padding(.vertical))
                .shadow(radius: 30, x: 0, y: 30)
                .offset(x: 0, y: 80)
                Spacer()
            }
            Text(self.Message).opacity(0)
        }
        
        .onAppear(){
            authentification( completion :{(result) -> (Void) in
                switch result{
                    case.success(let token):
                        self.Message = "already signed in"
                    case.failure(_):
                        break
                }

            })
        }
    }
}
