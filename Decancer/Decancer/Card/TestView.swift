//
//  TestView.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/4/21.
//

import Foundation
import SwiftUI

struct TestGeometry : View{
    
    @State var show = false
    @Namespace var namespace

    var body: some View {
        ZStack {
            if !show {
                ScrollView {
                    HStack {
                        VStack {
                            Text("Title").foregroundColor(.white)
                                .matchedGeometryEffect(id: "title", in: namespace)
                        }
                        .frame(width: 100, height: 100)
                        .background(
                            Rectangle().matchedGeometryEffect(id: "shape", in: namespace)
                        )
                        Rectangle()
                            .frame(width: 100, height: 100)
                        Spacer()
                    }
                    .padding(8)
                }
            } else {
                VStack {
                    Text("Title").foregroundColor(.white)
                        .matchedGeometryEffect(id: "title", in: namespace)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(
                    Rectangle().matchedGeometryEffect(id: "shape", in: namespace)
                )
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                show.toggle()
            }
        }
    }
}
