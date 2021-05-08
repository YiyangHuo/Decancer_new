//
//  RecordingViewController.swift
//  Decancer
//
//  Created by Yiyang Huo on 5/6/21.
//

import Foundation
import SwiftUI
import SwiftyJSON


struct Tools : Hashable {
    
    var id : Int
    var image : String
    var name : String
    var offset : CGFloat
    var place : Int
    var type: String
    var percentage: Int
}

struct Records : Hashable {
    
    var id : Int
    var image : String
    var name : String
    var type: Int
    var message : String
    var prob : Float
    var isfeedback: Bool

}

class RecordViewController : ObservableObject {
    @Published var httprequest = HttpRequest()
    @Published var selected = Records(id: 0, image: "sketch", name: "Default", type: 0, message: "Default", prob: 1, isfeedback: false)
    

    func handinfeedback(record: Records, newprediction: Int,completion: @escaping (Result<[String:String], Error>) -> Void) {
        authentification( completion :{(result) -> (Void) in
            switch result{
                case .success(let token):
                    let body = [
                        "photoid": record.image,
                        "old_predict": record.type,
                        "true_predicts" : newprediction
                    ] as [String : Any]
                    
                    self.httprequest.sendhttp(token: token, body: body, api: "handinfeedback", callback: {(outcome) -> (Void) in
                        switch outcome{
                        case.success((_, let data)):
                            completion(.success([
                                "photoid": record.image
                            ]))
                            break
                        case.failure(_):
                            break
                        }
                        
                    })
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
            }
            
        })
    }
    
    func getrecords(completion: @escaping (Result<[Records], Error>) -> Void){
        //let imageData: Data = uiImge.jpegData(compressionQuality: 1.0) ?? Data()
        authentification( completion :{(result) -> (Void) in
            DispatchQueue.main.async {
                let body = ["message" : "from_ios"]
                switch result{
                    case .success(let token):
                        self.httprequest.sendhttp(token:token, body:body, api:"records", callback: { (result) -> (Void) in
                            DispatchQueue.main.async {
                                switch result{
                                    case .success((_, let data)):
                                        let swiftyJson = JSON(data)
                                        var temp = [Records]()
                                        var theid = 0
                                        for record in swiftyJson{
                                            let prediction = record.1["prediction"].int!
                                            let newrecord = Records(
                                                                    id: theid, image: record.1["photoid"].string!,
                                                                    name: Diagnose_Constants.Constant_export_names[prediction],
                                                                    type: prediction,
                                                                    message: Diagnose_Constants.Constant_export_messages[prediction],
                                                                    prob: record.1["probability"].float!,
                                                                    isfeedback: record.1["isfeedback"].bool!)
                                            temp.append(newrecord)
                                            theid += 1
                                        }
                                        if temp.isEmpty == false {
                                            self.selected = temp[0]
                                        }
                                       
//                                        self.test_records = temp
//                                        self.the_records = temp
                                        completion(.success(temp))
                                        break
                                    case .failure(let error):
                                        completion(.failure(error))
                                        return
                                }
                            }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                        return
                }
            }
        })

    }
}
