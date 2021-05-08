//
//  ChatView.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/28/21.
//

import Foundation
import SwiftUI
import CoreData


struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .multilineTextAlignment(isCurrentUser ? .trailing : .leading)
            .lineLimit(nil)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.theblack)
            .background(isCurrentUser ? Color.Theme_Image : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}

struct MessageView : View {
    var currentMessage: Message
    
//    @ObservedObject var imageLoader:ImageLoader
//    @State var image:UIImage = UIImage()
    init(currentMessage: Message){
        self.currentMessage = currentMessage
//        self.imageLoader = ImageLoader(urlString: currentMessage.user.avatar)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !currentMessage.user.isCurrentUser {
                Image(systemName:currentMessage.user.avatar)
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
                ContentMessageView(contentMessage: currentMessage.content,
                                   isCurrentUser: currentMessage.user.isCurrentUser)
                Spacer()
            } else {
                Spacer()
                ContentMessageView(contentMessage: currentMessage.content,
                                   isCurrentUser: currentMessage.user.isCurrentUser)
//                Image(uiImage: image)
//                .resizable()
//                .frame(width: 40, height: 40, alignment: .center)
//                .cornerRadius(20)
//                .onReceive(imageLoader.didChange) { data in
//                                self.image = UIImage(data: data) ?? UIImage()
//                        }
                
            }
           
        }.padding()
    }
}

struct ChatView: View{
    @ObservedObject var chatviewcontroller = CharViewController()
    @EnvironmentObject var unicontroller: UniversalController
    @Binding var isNavigationBarHidden: Bool
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader{ value in
                    LazyVStack{
                        ForEach(chatviewcontroller.messages, id: \.id) { msg in
                            MessageView(currentMessage: msg).id(msg.id)
                        }
//                        List(chatviewcontroller.messages, id: \.self) { msg in
//                            MessageView(currentMessage: msg)
//                        }.id(UUID())
                    }.onChange(of: chatviewcontroller.messages.count) { _ in
                        withAnimation(.easeIn(duration: 0.5)){
                                value.scrollTo(chatviewcontroller.messages.last?.id, anchor: .bottom)
                            }
                    }
                }
                
            }.padding(.top).background(Color.Theme_Chatbot)
           HStack {
            TextField("Message...", text: $chatviewcontroller.message_to_send)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .frame(minHeight: CGFloat(30))
            Button(action:chatviewcontroller.sendMessage) {
                Image(systemName: "paperplane").foregroundColor(Color.Theme_Chatbot)
                 }
           }.padding()
           .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
           
           .clipShape(RoundedRectangle(cornerRadius: 10.0, style:.continuous))
           .shadow(radius:8, x:8, y: 8)
           .shadow(radius:-8, x:-8, y: -8)
        }.onTapGesture {
            self.hideKeyboard()
        }
        .background(Color.Theme_Chatbot.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Chat room", displayMode: .inline)
        .onAppear(perform: {
            self.isNavigationBarHidden = false
            self.chatviewcontroller.messages = [Message]()
            //unicontroller.display_loading_main = true
            DispatchQueue.main.async{
                //self.chatviewcontroller.messages = [Message]()
                self.chatviewcontroller.synchronization(finalize: { (result) -> (Void) in
                    //unicontroller.display_loading_main = false
                    })
            }

                // your code here
                //unicontroller.display_loading_main = false
            
        })
        .onDisappear(perform: {
            
            self.chatviewcontroller.disconnect()

        })
    }
}
