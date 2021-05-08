//
//  DiagnoseView.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/1/21.
//

import Foundation
import SwiftUI

struct DiagnoseView: View {
    @State var showImagePicker: Bool = false
    @State var showcameraPicker: Bool = false
    @State var showresult: Bool = false
    @State var record:Records = Records(id: 0, image: "", name: "", type: 0, message: "", prob: 0, isfeedback: false)
    @ObservedObject var diagnosecontroller = DiagnoseViewController()
    @EnvironmentObject var diagnoserouter : DiagnoseRouter
    

    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        
                        withAnimation(.easeInOut){
                            
                            diagnoserouter.goback()
                        }
                        
                    }) {
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.The_Red)
                    }.padding()
                    Spacer()
                    switch diagnoserouter.currentPage {
                    case .Select:
                        DiagnoseImagePickerView(diagnosecontroller: diagnosecontroller)
                        
                    case .Upload:
                        DiagnoseUploadView(showresult: self.$showresult, record: $record, diagnosecontroller: diagnosecontroller)
                    }
                    Spacer()
                    Button(action: {
                        
                        withAnimation(.easeInOut){
                            
                            diagnoserouter.goforward()
                        }
                        
                    }) {
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(self.diagnosecontroller.selectedImage == Image("") ? Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)) : Color.The_Red)
                    }.padding().disabled(self.diagnosecontroller.selectedImage == Image(""))
                    
                }
            }.blur(radius: self.showresult ? 10 : 0)
            
            if self.showresult {
                DiagnoseDetail(record: record, show: self.$showresult, diagnoseController: diagnosecontroller)
            }
            
            
        }
        
        
    }
}

struct DiagnoseUploadView: View {
    @Binding var showresult: Bool
    @Binding var record: Records
    @State private var bouncing = false
    @State var theoffset: CGFloat = 10
    @ObservedObject var diagnosecontroller:DiagnoseViewController
    @EnvironmentObject var diagnoserouter : DiagnoseRouter
    @EnvironmentObject var universalcontroller : UniversalController
    var body: some View {
        VStack{
            Text("Looks Good?").fontWeight(.bold).font(.title3).foregroundColor(Color.The_Red).padding()
            
            diagnosecontroller.selectedImage?.resizable().frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
            
            Button(action:{
                self.universalcontroller.display_loading_main = true
                self.diagnosecontroller.upload(){(finalize) -> Void in
                    switch finalize{
                        case.success(let therecord):
                            self.record = therecord
                            self.showresult = true
                    case.failure(_):
                        break
                    }
                    self.universalcontroller.display_loading_main = false
                }
            }, label: {
                Text("Upload image")
                    .foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*2/4).padding()
            })
            .background(Color.The_Red).clipShape(Capsule()).padding(.vertical,20)
            .shadow(color: .The_Red, radius: 10)
            .offset(x: 0, y: bouncing ? 0 : self.theoffset)
            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
            .onAppear {
                            self.bouncing.toggle()
                        }
            
        }
    }
}

struct DiagnoseImagePickerView: View {
    @State var showImagePicker: Bool = false
    @State var showcameraPicker: Bool = false
    @State private var bouncing = false
    @State private var bouncing2 = false
    @State var theoffset: CGFloat = 20
    @ObservedObject var diagnosecontroller:DiagnoseViewController
    @EnvironmentObject var diagnoserouter : DiagnoseRouter
    
    var body: some View {
        VStack{
            Text("To diagnose using AI").fontWeight(.bold).font(.title3).foregroundColor(Color.The_Red).frame(maxWidth:.infinity).padding()
            
            Button(action:{
                self.showImagePicker.toggle()
            }, label: {
                Text("Select image")
                    .foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*2/4).padding()
            }
            )
            .background(Color.The_Red).clipShape(Capsule()).padding(.vertical,20)
            .shadow(color: .The_Red, radius: 10)
            .offset(x: 0, y: bouncing ? 0 : self.theoffset)
            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
            
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, image: $diagnosecontroller.selectedImage).ignoresSafeArea(.all)
            })
            .onAppear {
                            self.bouncing.toggle()
                        }
            
            Text("Or").fontWeight(.bold).font(.title3).foregroundColor(Color.The_Red).padding()
                
            
            Button(action:{
                self.showcameraPicker.toggle()
            }, label: {
                Text("camera")
                    .foregroundColor(Color.white).frame(width:UIScreen.main.bounds.width*2/4).padding()
            })
            .background(Color.The_Red).clipShape(Capsule()).padding(.vertical,20)
            .shadow(color: .The_Red, radius: 10)
            .offset(x: 0, y: bouncing2 ? 0 : self.theoffset)
            .animation(Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true))
            .sheet(isPresented: $showcameraPicker, content: {
                ImagePicker(sourceType: .camera, image: $diagnosecontroller.selectedImage).ignoresSafeArea(.all)
            })
            .onAppear {
                
                    self.bouncing2.toggle()
                
                            
            }
            
        }.onChange(of: diagnosecontroller.selectedImage, perform: { newValue in
            self.diagnoserouter.goforward()
        })
    }
    
    
}
