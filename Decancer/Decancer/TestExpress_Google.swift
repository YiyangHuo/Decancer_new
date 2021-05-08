//
//  TestExpress_Google.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/28/21.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

struct TestView: View {
    @ObservedObject var testviewver = TestViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Spacer()
        Button(action:{
            testviewver.retrieve(finalize: {(result) -> (Void) in
            })

        }) {
            Text("Send test message")
        }
        Spacer()
        Text("\(testviewver.Message)")
        Spacer()
        Button("Press to dismiss") {
                   presentationMode.wrappedValue.dismiss()
               }
               .font(.title)
               .padding()
               .background(Color.theblack)
        Spacer()
    }
}


class TestViewModel: ObservableObject{
    @Published var httprequest = HttpRequest()
    @Published var Message = ""
    
    func retrieve(finalize: @escaping(Result<String,Error>) -> Void) {
        authentification( completion :{(result) -> (Void) in
            var body = ["message" : "from_ios"]
            DispatchQueue.main.async {
                switch result{
                    case .success(let token):
                        self.httprequest.sendhttp(token: token, body: body, api: "secret/hello", callback: { (result) -> (Void) in
                            DispatchQueue.main.async {
                                switch result{
                                    case .success((_, let data)):
                                        if let returnData = String(data: data, encoding: .utf8) {
                                            self.Message = returnData
                                        } else {
                                            self.Message = "failed to decode response"
                                        }
                                        finalize(.success("Success"))
                                    case .failure(let error):
                                        finalize(.failure(error))
                                        return
                                }
                            }
                        })
                    case .failure(let error):
                        self.Message = "You are not authorized"
                        finalize(.failure(error))
                        return
                }
            }
            
        })
    }
    
    
}
