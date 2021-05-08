//
//  HttpRequest.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/28/21.
//

import Foundation
import Firebase
import GoogleSignIn
import UIKit
import SwiftUI

struct Failure_message: Codable {
    let message: String?
}

enum NetworkError:Error {
    case General
}

enum LocalError:Error{
    case Not_Auth
}


enum constants: String{
    case httpurl = "http://155.138.196.10:8000/"
    case wsurl = "ws://155.138.196.10:8000"
    case default_user_name = "LimeWhaleUser"
    case app_store_link = "itms-apps://apple.com/app/id"
}

struct Diagnose_Constants {
    static var Constant_export_messages = ["An actinic keratosis is a rough, scaly patch on the skin that develops from years of sun exposure. It's often found on the face, lips, ears, forearms, scalp, neck or back of the hands. A typical IEC is a well defined, pink or red, scaly and flat (or almost flat) lesion.\n\nPrevent:\n\nUse sunscreen\n\nCover up\n\nAvoid tanning beds\n\nCheck your skin regularly and report changes to your doctor\n\nTreatment:\n\nAn actinic keratosis sometimes disappears on its own but might return after more sun exposure. It's hard to tell which actinic keratoses will develop into skin cancer, so they're usually removed as a precaution. Possible medication treatments are medicated cream or gel to remove them, such as fluorouracil (Carac, Fluoroplex, others), imiquimod (Aldara, Zyclara), ingenol mebutate or diclofenac (Solaraze). Other treatments are freezing, scraping, laser therapy, photodynamic therapy.",
                                           
                                           
                                           "Basal cell carcinoma is a type of skin cancer. Basal cell carcinoma begins in the basal cells — a type of cell within the skin that produces new skin cells as old ones die off.\n\nPrevent:\n\nAvoid the sun during the middle of the day.\n\nWear sunscreen year-round.\n\nWear protective clothing\n\nAvoid tanning beds.\n\nCheck your skin regularly and report changes to your doctor.\n\nTreatment:\n\nThe goal of treatment for basal cell carcinoma is to remove the cancer completely. Which treatment is best for you depends on the type, location and sizeof your cancer, as well as your preferences and ability to do follow-up visits. Treatment selection can also depend on whether this is a first-time or a recurring basal cell carcinoma. The options are surgery, Curettage and electrodessication, Radiation therapy, Freezing, Topical treatments, Photodynamic therapy. If the cancer spreads, the treatments are targeted drug therapy, and chemotherapy.",
                                           
                                           
                                    "A seborrheic keratosis is a common noncancerous skin growth. People tend to get more of them as they get older. Seborrheic keratoses are usually brown, black or light tan. The growths look waxy, scaly and slightly raised. They usually appear on the head, neck, chest or back.\n\nPrevent:\n\nIt can’t be prevented. You're generally more likely to develop seborrheic keratoses if you're over age 50. You're also more likely to have them if you have a family history of the condition.\n\nTreatment:\n\nTreatment of a seborrheic keratosis isn't usually needed. Be careful not to rub, scratch or pick at it. This can lead to itching, pain and bleeding. You can have a seborrheic keratosis removed if it becomes irritated or bleeds, or if you don't like how it looks or feels. If want to remove the seborrheic keratosis, the options are cryosurgery, curettage, electrocautery, ablation, applying a solution of hydrogen peroxide.",


                                    "Dermatofibromas are small, noncancerous (benign) skin growths that can develop anywhere on the body but most often appear on the lower legs, upper arms or upper back. They can be pink, gray, red or brown in color and may change color over the years. They are firm and often feel like a stone under the skin. When pinched from the sides, the top of the growth may dimple inward.\n\nPrevent:\n\nBecause no one knows what causes dermatofibromas, there is no way to prevent them.\n\nTreatment:\n\nMost dermatofibromas do not require treatment. If need, it can be removed by surgery, laser procedures, and freezing a growth with liquid nitrogen or injecting it with corticosteroids.",


                                    "What it is:\n\nMelanocytic nevus is a form of skin lesion that appears within the first two decades of life. It originates in the melanocytes (the pigment producing cells) that colonize the epidermis. This disease can appear underneath the skin or on the skin’s surface.\n\nPrevention:\n\nTaking annual skin examinations yearly if having a family history of melanocytic nevus.\n\nWearing quality sun screen with an SPF rating of 30 or more\n\nTreatment:\n\nThe abnormal mole should be removed. Surgery, where a wide, local incision is made can result in a high risk of the lesion returning, but it is the most widely used treatment option. Radiation (the use of ionizing radiation beams to kill cells) and cryotherapy (the use of extreme cold to kill cells) may also be used to treat melanocytic venues. But the two are not widely used and they yield mixed results.",


                                    "A pyogenic granuloma or lobular capillary hemangioma is a vascular tumor that occurs on both mucosa and skin, and appears as an overgrowth of tissue due to irritation, physical trauma, or hormonal factors. It is often found to involve the gums, skin, or nasal septum, and has also been found far from the head, such as in the thigh.\n\nPrevent:\n\nIt can’t be prevented directly. Pyogenic granulomas are caused by proliferation of capillaries and are not caused by infection or cancer.",


                                    "Melanoma, the most serious type of skin cancer, develops in the cells (melanocytes) that produce melanin — the pigment that gives your skin its color. Melanoma can also form in your eyes and, rarely, inside your body, such as in your nose or throat.\n\nPrevent:\n\nAvoid the sun during the middle of the day.\n\nWear protective clothing.\n\nAvoid tanning lamps and beds.\n\nBecome familiar with your skin so that you'll notice changes.\n\nTreatment:\n\nTreatment for early-stage melanomas usually includes surgery to remove the melanoma. A very thin melanoma may be removed entirely during the biopsy and require no further treatment. If melanoma has spread beyond the skin, treatment options may include: Surgery to remove affected lymph nodes, Immunotherapy, Targeted therapy, Radiation therapy, and Chemotherapy"
                                        
                                        ]

    static var Constant_export_names = ["Akiec Keratoses",
                                        "Basal Cell Carcinoma",
                                        "Benign Keratosis",
                                        "Dermatifubroma",
                                        "Melanocytic Nevi",
                                        "Pyogenic Granulomas",
                                        "Melanoma"]
    static var longsentence = ""
}





func authentification(completion: @escaping (Result<String, Error>) -> Void) {
    if let currentuser = Auth.auth().currentUser{
        currentuser.getIDTokenForcingRefresh(true) { idToken, error in
          if let _ = error {
            completion(.failure(LocalError.Not_Auth))
          }
            sharedUser.shared.authenticated = true
            completion(.success(idToken!))
          // Send token to your backend via HTTPS
          // ...
        }
    } else {
        completion(.success("guest"))
    }
    return
}

class HttpRequest {
    var resourceURL = constants.httpurl
    var urlconfig =  URLSessionConfiguration.default
    public init() {
        urlconfig.timeoutIntervalForRequest = 120
        urlconfig.timeoutIntervalForResource = 120
    }
    public func sendhttp(token:String, body:[String:Any], api:String, callback: @escaping (Result<(URLResponse, Data), Error>) ->(Void)) {
        guard let requestURL  = URL(string:resourceURL.rawValue + api) else {fatalError()}
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                callback(.failure(error))
                return
            }
            
            callback(.success((response!, data!)))
            return
        }.resume()
    }
    
    public func sendfile(token: String, image: UIImage, api:String, callback: @escaping (Result<(URLResponse, Data), Error>) ->(Void)) {
        guard let requestURL  = URL(string:resourceURL.rawValue + api) else {fatalError()}
        //let boundary = UUID().uuidString
        var request = URLRequest(url: requestURL)
        let boundary = "Boundary-\(UUID().uuidString)"
        
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }

        request.httpMethod = "POST"

        request.allHTTPHeaderFields = [
                    "X-User-Agent": "ios",
                    "Accept-Language": "en",
                    "Accept": "application/json",
                    "Content-Type": "multipart/form-data; boundary=\(boundary)",
                    "Authorization" : token,
                ]

        let dataBody = createDataBody(media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody

        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                callback(.failure(error))
                return
            }
            callback(.success((response!, data!)))
            return
        }.resume()
    }

    
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}

func createDataBody(media: [Media]?, boundary: String) -> Data {

    let lineBreak = "\r\n"
    var body = Data()

//    if let parameters = params {
//        for (key, value) in parameters {
//            body.append("--\(boundary + lineBreak)")
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//            body.append("\(value + lineBreak)")
//        }
//    }

    if let media = media {
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
    }

    body.append("--\(boundary)--\(lineBreak)")

    return body
}

struct TextView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
