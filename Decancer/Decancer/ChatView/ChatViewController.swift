//
//  ChatViewController.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/30/21.
//

import Foundation
import SwiftUI
import SocketIO
import SwiftyJSON

struct Message: Hashable {
    let id = UUID()
    var content: String
    var user: User
}


struct User: Hashable {
    var name: String
    var avatar: String
    var isCurrentUser: Bool = false
}

struct MessageModel: Codable {
    let Name:String
    let message: String
}

//class ChatHelper : ObservableObject {
//    var didChange = PassthroughSubject<Void, Never>()
//    @Published var realTimeMessages = DataSource.messages
//
//    func sendMessage(_ chatMessage: Message) {
//        realTimeMessages.append(chatMessage)
//        didChange.send(())
//    }
//}
extension Decodable {
  init(from any: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: any)
    self = try JSONDecoder().decode(Self.self, from: data)
  }
}

class CharViewController: ObservableObject{
    var manager = SocketManager(socketURL:URL(string:constants.wsurl.rawValue)!, config:[.log(true), .compress])
    var socket:SocketIOClient!
    @Published var messages = [Message]()
    @Published var message_to_send = ""
    @Published var initialized = false
    
    init() {
        self.socket = manager.defaultSocket
        self.socket.on(clientEvent: .connect){ (data, ack) in
            print("Connected")
            
        }
        self.initialized = false
        
        self.socket.on("INCOME_MESSAGE") { [weak self](data, ack) in
            let swiftyJson = JSON(data[0])
            for message in swiftyJson{
                let rawMessage = message.1["message"].string
                let rawName = message.1["Name"].string
                let curbool = !(rawName == "bot")
                var theUser = User(name: rawName!, avatar: "person.circle.fill", isCurrentUser: curbool)
                if (curbool) {
                    theUser.avatar = sharedUser.shared.photolink
                }
                self?.objectWillChange.send()
                    if ((self?.initialized)!){
                        withAnimation(){
                            self?.messages.append(Message(content:rawMessage!, user: theUser))
                        }
                    } else {
                        self?.messages.append(Message(content:rawMessage!, user: theUser))
                    }
            }
            self?.initialized = true

        }
        self.socket.connect()
    }
    
    func synchronization(finalize: @escaping(Bool) -> Void) {
        var data = ["idToken":"guest"]
       
        self.initialized = false
        authentification( completion :{(result) -> (Void) in
            switch result{
                case.success(let token):
                    data["idToken"] = token
                case.failure(_):
                    break
            }
            self.socket.emit("SYNCHRONIZATION", data)
            finalize(true)
        })
    }
    
    func disconnect() {
        self.socket.emit("DISCONNECT", [])
    }
    
    func sendMessage() {
        if self.message_to_send == "" {
            return
        }
        var data = ["idToken":"guest", "message":self.message_to_send]
        withAnimation(.easeInOut){
            self.message_to_send = ""
        }
        authentification( completion :{(result) -> (Void) in
            switch result{
                case.success(let token):
                    data["idToken"] = token
                    
                case.failure(_):
                    break
            }

                self.socket.emit("MESSAGE_FROM_CLIENT", data)
        })
        
    }
    
    
}
