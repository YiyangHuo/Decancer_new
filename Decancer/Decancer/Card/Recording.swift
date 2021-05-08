//
//  Recording.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/5/21.
//

import Foundation
import SwiftUI

struct RecordView : View {
    
    
    
    // to track which card is swiped...
    @ObservedObject var recordontroller = RecordViewController()
    @EnvironmentObject var unicontroller: UniversalController
    @State var the_records = [Records]()
    @State var swiped = 0
    @Namespace var name
    @State var show = false
    
    
    var body: some View{
        
        ZStack{
            VStack{
                
                // Stacked Elements....
                
                GeometryReader{reader in
                    if !self.the_records.isEmpty{
                        ScrollView(.vertical, showsIndicators:false){
                            
                            ForEach(the_records, id: \.id){record in
                                
                                CardView(record: record, reader: reader, swiped: $swiped,show: $show,selected: $recordontroller.selected,name: name)
                                    // adding gesture...
                            }
                        }
                    } else {
                        Text("No History Records").foregroundColor(Color.white).font(.title).padding()
                    }
                        
                        // Zstack will overlay on one another so revesing...
                        
                }
                
            }.blur(radius: show ? 10 : 0)
            
            if show{
                
                Detail(record: recordontroller.selected, show: $show, name: name, recordontroller: recordontroller, the_records: $the_records)
            }
        }
        .background(
            Color.Theme_Chatbot.ignoresSafeArea(.all)
        )
        .onAppear(){
            unicontroller.display_loading_main = true
            self.recordontroller.getrecords(){ (completion) -> Void in
                DispatchQueue.main.async(){
                    switch completion{
                    
                        case.success(let array):
                            withAnimation(){
                                self.the_records = array
                            }
                            
                            break
                        case.failure(let error):
                            break
                    
                    }
                }
                
                unicontroller.display_loading_main = false
                
            }
        }
    }
}
