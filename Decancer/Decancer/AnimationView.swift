//
//  AnimationView.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/7/21.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    @State var progress: Float
    @State var changestates: Float = 0
    @State var show = false
    var body: some View {
        VStack{
            if self.show{
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(Color.red)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(self.changestates, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.red)
                        .rotationEffect(Angle(degrees: 270.0))
                        //.animation(.linear)
                    Text(String(format: "%.3f %%", min(self.changestates, 1.0)*100.0))
                        .font(.footnote)
                        .bold()
                }.frame(width: UIScreen.main.bounds.height/5)
            }
        }.onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(){
                   
                    self.show.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                    withAnimation(.easeOut(duration: 1)){
                        self.changestates = self.progress
                    }
                }
            }
            
            
        }
        .onDisappear(){
            self.changestates = 0
            self.show.toggle()
        }
    }
    
}



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


struct Triangle: Shape {
    @State var isleft = true
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        if isleft{
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + rect.width/6 , y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - rect.width/6, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
       

        return path
    }
}


