//
//  File.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/5/21.
//

import Foundation
import SwiftUI

struct CardView : View {
    
    var record : Records
    var reader : GeometryProxy
    @Binding var swiped : Int
    @Binding var show : Bool
    @Binding var selected : Records
    var name : Namespace.ID
    
    var body: some View{
        
        VStack{
            
            Spacer(minLength: 0)
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)){
                VStack{
                    HStack{
                        
                        FirebaseImage(imagename: "\(record.image)")
                            .frame(width: UIScreen.main.bounds.width/6)
                            .matchedGeometryEffect(id: record.image, in: name)
                            .padding(.top)
                            .padding(.horizontal,25)
                        
                        HStack{
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("\(record.name)")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.theblack)
                                    .matchedGeometryEffect(id: record.image + "name", in: name)
                                
                                Text("Probability: \(String(format: "%.3f", Double(record.prob*100)))%")
                                    .font(.system(size: 10))
                                    .foregroundColor(.theblack)
                                    .matchedGeometryEffect(id: record.image + "prob", in: name)
                                

                            }
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal,30)
                        .padding(.top,25)
                    }
                    HStack{
                        VStack{
                            if self.record.isfeedback {
                                Image(systemName: "checkmark.seal.fill")
                                    .resizable().scaledToFit().frame(width: 30).padding(.horizontal,30).padding(.bottom,30)
                                    .foregroundColor(Color.Theme_Chatbot)
                            } else {
                                Image(systemName: "xmark.seal.fill")
                                    .resizable().scaledToFit().frame(width: 30).padding(.horizontal,30).padding(.bottom,30)
                                    .foregroundColor(Color.The_Red)
                            }
                        }.matchedGeometryEffect(id: record.image + "feedback", in: name)

                        Spacer()
                        Button(action: {
                            
                            withAnimation(.easeInOut){
                                
                                selected = record
                                show.toggle()
                            }
                            
                        }) {
                            
                            Text("Know More >")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.The_Red)
                                .opacity(show ? 0 : 1)
                        }.padding(.horizontal,30).padding(.bottom,30)
                    }
                   
                }
                
            }
            // setting dynamic frame....
            .frame(maxHeight: reader.frame(in: .global).height/3)
            .padding(.vertical,10)
            .background(
                RoundedRectangle(cornerRadius: 25).fill(Color.white)
                    .matchedGeometryEffect(id: record.image + "back", in: name)
                    .padding(.vertical)
            )
            .padding(.horizontal,30)
            .shadow(color: Color.theblack.opacity(0.12), radius: 5, x: 0, y: 5)
            
            Spacer(minLength: 0)
        }
    }
}

struct Detail : View {
    
    @State var record: Records
    @Binding var show : Bool
    var name : Namespace.ID
    @ObservedObject var recordontroller:RecordViewController
    @Binding var the_records : [Records]
    @State var theopacity: Double = 0
    @EnvironmentObject var unicontroller: UniversalController
    @EnvironmentObject var diagnoserouter: DiagnoseRouter
    @State var showfeedback = false
    @State var chosenfeedback = ""
    var body: some View{
        
        VStack{
            ZStack{
                VStack{
                    VStack(spacing: 12) {
                        HStack{
                            
                            Button(action: {
                                
                                withAnimation(.easeInOut){
                                    
                                    show.toggle()
                                    diagnoserouter.goback()
                                }
                                
                            }) {
                                
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.theblack)
                            }
                            Spacer()
                        }
                        
                        FirebaseImage(imagename: "\(record.image)")
                            .frame(maxHeight: UIScreen.main.bounds.height/4)
                            .matchedGeometryEffect(id: record.image, in: name)
                            .padding()
                            .shadow(radius: 30)
                    }
                    .padding(.leading,20)
                    .padding([.top,.bottom,.trailing])
                    
                    // for smaller size phones..
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack{
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text(record.name)
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.theblack)
                                        .matchedGeometryEffect(id: record.image + "name", in: name)
                                    
            //                        Text("Probability \(String(format: "%.3f", Double(record.prob*100)))%")
            //                            .font(.system(size: 20))
            //                            .foregroundColor(.theblack)
            //                            .matchedGeometryEffect(id: record.image + "prob", in: name)
                                    HStack{

                                        ProgressBar(progress: Float(record.prob)).frame(height: UIScreen.main.bounds.width/4)
                                        Spacer()
                                            //.matchedGeometryEffect(id: record.image + "prob", in: name)
                                    }
                                    
                                    Text(record.message)
                                        .font(.system(size: 20))
                                        .foregroundColor(.theblack)
                                        .opacity(theopacity)
                                        .padding(.vertical)
                                    
                                    HStack{
                                        Spacer()
                                        Button(action:{
                                            withAnimation(){
                                                self.showfeedback = true
                                            }
                                        }){
                                            Text(!record.isfeedback ? "Submit feedback" : "feedback Submitted").foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*2/4).padding()
                                                .matchedGeometryEffect(id: record.image + "feedback", in: name)
                                        }
                                        .disabled(record.isfeedback)
                                        .background(!record.isfeedback ? Color.The_Red : Color.Unselected_Text).clipShape(Capsule()).padding(.vertical,20)
                                        Spacer()
                                    }
                                    
                                        
                                    Spacer()
                                }.padding()
                                .foregroundColor(Color.gray.opacity(0.7))
                            .padding(.vertical)
                            }

                        }.frame(maxHeight:.infinity).clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }.blur(radius: self.showfeedback ? 10 : 0)
                if self.showfeedback{
                    VStack{
                        Picker("test", selection:$chosenfeedback){
                            ForEach(Diagnose_Constants.Constant_export_names, id:\.self){
                                Text("\($0)")
                            }
                        }.padding()
                        
                        HStack{
                            Spacer()
                            Button(action:{
                                withAnimation(){
                                    self.showfeedback = false
                                }
                            }) {
                                Text("Cancel").foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*1/4).padding()
                            }.background(Color.The_Red).clipShape(Capsule()).padding()
                            
                            Spacer()
                            Button(action:{
                                self.unicontroller.display_loading_main = true
                                recordontroller.handinfeedback(record: self.record
                                                               , newprediction: Diagnose_Constants.Constant_export_names.firstIndex(of: self.chosenfeedback)!){ (completion) -> Void in
                                    DispatchQueue.main.async {
                                        switch completion{
                                        case.success(let update):
                                            
                                            let index = the_records.firstIndex(where: {$0.image == update["photoid"]})
                                            withAnimation(){
                                                the_records[index!].isfeedback = true
                                                self.record.isfeedback = true
                                            }
                                        case .failure(_):
                                            break
                                        }
                                        self.unicontroller.display_loading_main = false
                                        withAnimation(){
                                            self.showfeedback = false
                                        }
                                    }
                                }
                                
                            }){
                                Text("Upload").foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*1/4).padding()
                            
                            }.background(Color.The_Red).clipShape(Capsule()).padding()
                            
                            Spacer()
                        
                        }
                        
                    }.background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white).padding(.horizontal)
                            
                    ).shadow(radius: 20)
                }
                
            }
            
           
            
            
        }.onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(){
                    theopacity = 1
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width*8/9)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.9)
                .matchedGeometryEffect(id: record.image + "back", in: name)
                
        )
        
        
        
    }
}





struct DiagnoseDetail : View {
    
    @State var record: Records
    @Binding var show : Bool
    @State var theopacity: Double = 1
    @EnvironmentObject var unicontroller: UniversalController
    @EnvironmentObject var diagnoserouter: DiagnoseRouter
    @ObservedObject var diagnoseController : DiagnoseViewController
    @State var showfeedback = false
    @State var chosenfeedback = ""
    var body: some View{
        
        VStack{
           
            VStack{
                VStack(spacing: 12) {
                    HStack{
                        
                        Button(action: {
                            
                            withAnimation(.easeInOut){
                                diagnoserouter.goback()
                                show.toggle()
                                
                                //diagnoseController.selectedImage = Image("")
                            }
                            
                        }) {
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.theblack)
                        }
                        Spacer()
                    }
                    
                    FirebaseImage(imagename: "\(record.image)")
                    
                        .frame(maxHeight: UIScreen.main.bounds.height/4)
                        .padding()
                        .shadow(radius: 30)
                }
                .padding(.leading,20)
                .padding([.top,.bottom,.trailing])
                
                // for smaller size phones..
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text(record.name)
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.theblack)
                                    
        //                        Text("Probability \(String(format: "%.3f", Double(record.prob*100)))%")
        //                            .font(.system(size: 20))
        //                            .foregroundColor(.theblack)
        //                            .matchedGeometryEffect(id: record.image + "prob", in: name)
                                HStack{

                                    ProgressBar(progress: Float(record.prob)).frame(height: UIScreen.main.bounds.width/4)
                                    Spacer()
                                        //.matchedGeometryEffect(id: record.image + "prob", in: name)
                                }
                                
                                Text(record.message)
                                    .font(.system(size: 20))
                                    .foregroundColor(.theblack)
                                    .opacity(theopacity)
                                    .padding(.vertical)
                                Spacer()
                            }.padding()
                            .foregroundColor(Color.gray.opacity(0.7))
                        .padding(.vertical)
                        }

                    }.frame(maxHeight:.infinity).clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }.blur(radius: self.showfeedback ? 10 : 0)
                
            
            
           
            
            
        }
        .frame(width: UIScreen.main.bounds.width*8/9)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    
                    .fill(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                   
            }
           
                
                
        )
        
        
        
    }
}





