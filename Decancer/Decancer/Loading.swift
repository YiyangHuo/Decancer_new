//
//  Loading.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/5/21.
//

import Foundation
import SwiftUI

struct Loading: View {

   
    
    let screenFrame = Color(.systemBackground)
    var body: some View {
        ZStack {
            Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                    .blur(radius: 20)
            SmallLoading(image_width: 100, circle_width: 150)

        }.edgesIgnoringSafeArea(.all)
    }
}

struct SmallLoading: View{
    @State private var animateStrokeStart = false
    @State private var animateStrokeEnd = true
    @State private var isRotating = true
    @State var image_width : CGFloat = 50
    @State var circle_width : CGFloat = 70
    
    var body: some View {
        ZStack{
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: image_width)
            Circle()
                .trim(from: animateStrokeStart ? 1/3 : 1/9, to: animateStrokeEnd ? 2/5 : 1)
                            .stroke(lineWidth: 5)
                .frame(width: circle_width, height: circle_width)
                .foregroundColor(Color.The_Red)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .onAppear() {
                    
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    {
                        self.isRotating.toggle()
                    }
                    
                    withAnimation(Animation.linear(duration: 1).delay(0.5).repeatForever(autoreverses: true))
                    {
                        self.animateStrokeStart.toggle()
                    }
                    
                    withAnimation(Animation.linear(duration: 1).delay(1).repeatForever(autoreverses: true))
                                   {
                                       self.animateStrokeEnd.toggle()
                                   }
            }
        }

    }
}
