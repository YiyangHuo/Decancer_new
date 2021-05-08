//
//  DiagnoseViewController.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/1/21.
//

import Foundation
import SwiftUI


class DiagnoseViewController: ObservableObject{
    @Published var selectedImage: Image? = Image("")
    @Published var httprequest = HttpRequest()
    @Published var message = ""
    //@Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    func upload(finalize: @escaping (Result<Records, Error>) -> Void){
        let uiImge: UIImage = self.selectedImage.asUIImage()
        //let imageData: Data = uiImge.jpegData(compressionQuality: 1.0) ?? Data()
        authentification( completion :{(result) -> (Void) in
            DispatchQueue.main.async {
                switch result{
                    case .success(let token):
                        self.httprequest.sendfile(token: token, image: uiImge, api: "upload", callback: { (result) -> (Void) in
                            DispatchQueue.main.async {
                                switch result{
                                case .success((_, let data)):
                                        let theresponse = try! JSONDecoder().decode(Uploadreturn.self, from: data)
                                        let thetype = theresponse.prediction!
                                        let newrecord = Records(id: 0, image: theresponse.photoid!,
                                                                name: Diagnose_Constants.Constant_export_names[thetype],
                                                                type: thetype,
                                                                message: Diagnose_Constants.Constant_export_messages[thetype],
                                                                prob: theresponse.probability,
                                                                isfeedback: theresponse.isfeedback!)
                                       
                                        //self.message = "success"
                                        finalize(.success(newrecord))
                                        return
                                        break
                                    case .failure(let error):
                                        //self.message = "failure"
                                        finalize(.failure(error))
                                }
                            }
                        })
                    case .failure(let error):
                        finalize(.failure(error))
                }
            }
        })

    }
}


struct Uploadreturn: Codable {
    let timestamp: String?
    let isfeedback: Bool?
    let photoid: String?
    let prediction: Int?
    let probability: Float
}

class DiagnoseRouter: ObservableObject {
    
    @Published var currentPage: DiagnosePage
    @Published var logosize: CGFloat
    //@Published var logsizeidentifier: [AuthPage: CGFloat] = [.SignUp: 80, .Login: 120]
    
   
    
    init() {
        self.logosize = 0
        self.currentPage = DiagnosePage.Select
    }
    
    func changeto(diagpage: DiagnosePage) {
        withAnimation(.spring()){
            self.objectWillChange.send()
            self.currentPage = diagpage
        }
    }
    
    func goback(){
        self.changeto(diagpage:.Select)
    }
    
    func goforward(){
        self.changeto(diagpage:.Upload)
    }
    
    
}

enum DiagnosePage:CaseIterable {
    case Select
    case Upload
}
