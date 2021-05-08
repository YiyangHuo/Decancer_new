//
//  FirebaseImage.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/7/21.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct FirebaseImage: View {
    @State var imagename: String
    @State private var imageURL = URL(string: "")
    @State var loaded = false
    var body: some View {
        VStack{
            if self.loaded {
                WebImage(url: imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onAppear(perform: loadImageFromFirebase)
            } else {
                 SmallLoading().clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }.onAppear(perform: loadImageFromFirebase)
        
        
        
    }
    func loadImageFromFirebase() {
        let storageRef = Storage.storage().reference(withPath:imagename)
        storageRef.downloadURL { (url, error) in
           if error != nil {
               print((error?.localizedDescription)!)
               return
           }

        self.imageURL = url!
            withAnimation(){
                self.loaded = true
            }
        }
    }
}


