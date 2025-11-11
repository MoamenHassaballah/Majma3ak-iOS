import UIKit
import Alamofire

class WebService: NSObject {
    
    static let shared = WebService()
    
    
    func sendRequest<T: Decodable>(
        url: String,
        params: [String: Any]? = [:],
        method: RMethod,
        isAuth: Bool,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        let lang = UserProfile.shared.currentAppleLanguage()
        var headers: HTTPHeaders = [:]
        if isAuth {
            if !Helper.access_token.isEmpty {
                headers.add(name: "Authorization", value: "Bearer \(Helper.access_token)")
            }
            headers.add(name: "Accept", value: "application/json")
            headers.add(name: "Accept-Language", value:lang)
        }
        
        let httpMethod: HTTPMethod
        switch method {
        case .get: httpMethod = .get
        case .post: httpMethod = .post
        case .delete: httpMethod = .delete
        case .put: httpMethod = .put
        }
        
        AF.request(url, method: httpMethod, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let decodedObject):
                    completion(.success(decodedObject))
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("🔍 Response Body:", errorMessage)
                    }
                    completion(.failure(error))
                }
            }
    }
    
    
//    func sendRequest(url:String, params: [String:Any]? = [:], method: RMethod, isAuth: Bool, completion: ((DataResponse<Data?, AFError>, Error?) -> Void)!) {
//        
//        var headers: HTTPHeaders = [:]
//        if isAuth {
//            
//            if Helper.access_token == "" {
//                
//            }else{
//                headers = ["Authorization": "Bearer \(Helper.access_token)"]
//            }
//           
//            headers["accept"]     = "application/json"
//            // headers["X-Requested-With"] = "XMLHttpRequest"
////            headers["Content-Type"]     = "application/json"
//            
//            
//        }
////        headers["Accept-Language"]    = Locale.preferredLanguageCode
//        
//        
//        
//        var _method: HTTPMethod!
//        
//        if method == .get {
//            _method = .get
//        } else if method == .post{
//            _method = .post
//        }else{//delete
//            _method = .delete
//        }
//        
//        AF.request(url, method: _method, parameters: params, encoding: URLEncoding.default, headers: headers).response { response in
//            print(response)
//            switch response.result {
//            case .success(_):
//                completion(response,nil)
//            case .failure(let fail):
//                completion(response,fail)
//            }
//        }
//        
//    }
    
//    static func send2PostRequest(url: String,isAuth: Bool, completion: @escaping ((DataResponse<Any>), Error?)-> ()){
//        
//        var headers: HTTPHeaders = [:]
//        
//        if isAuth{
//            let ud = UserDefaults.standard
//            let value = ud.value(forKey: "token_key") as? String ?? ""
//            headers["Authorization"] = "Bearer \(value)"
//        }
//        
//        AF.request(url, method: .post, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//            //print(response.value!)
//            if response.error != nil {
//                completion(response, response.error)
//                return
//            }
//            completion(response, nil)
//        }
//    }
    
    

    
    
    func uploadImage(url: String, imageData: Data?, parameters: [String: Any], imageParameter: String, completion: @escaping (Result<Any, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer \(Helper.access_token)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let stringValue = value as? String {
                    multipartFormData.append(Data(stringValue.utf8), withName: key)
                } else if let intValue = value as? Int {
                    multipartFormData.append(Data("\(intValue)".utf8), withName: key)
                } else if let arrayValue = value as? [Any] {
                    for element in arrayValue {
                        let keyObj = key + "[]"
                        if let stringElement = element as? String {
                            multipartFormData.append(Data(stringElement.utf8), withName: keyObj)
                        } else if let intElement = element as? Int {
                            multipartFormData.append(Data("\(intElement)".utf8), withName: keyObj)
                        }
                    }
                }
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: imageParameter, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            }
        }, to: url, method: .post, headers: headers)
        .validate()
        .responseData { response in
            
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                    
                    if let data = response.data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                if String(data: prettyData, encoding: .utf8) != nil {
                                    print("(prettyString)")
                                }
                            } catch {
                                print("JSON parsing error:", error)
                            }
                        }
                }
            case .failure(let error):
                completion(.failure(error))
                
                if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            if let prettyString = String(data: prettyData, encoding: .utf8) {
                                print("\(prettyString)")
                            }
                        } catch {
                            print("JSON parsing error:", error)
                        }
                    }
            }
        }
        
    }
    
    
    func uploadVideo(url: String, videoData: Data?, parameters: [String: Any], completion: @escaping (Result<Any, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let stringValue = value as? String {
                    multipartFormData.append(Data(stringValue.utf8), withName: key)
                } else if let intValue = value as? Int {
                    multipartFormData.append(Data("\(intValue)".utf8), withName: key)
                } else if let arrayValue = value as? [Any] {
                    for element in arrayValue {
                        let keyObj = key + "[]"
                        if let stringElement = element as? String {
                            multipartFormData.append(Data(stringElement.utf8), withName: keyObj)
                        } else if let intElement = element as? Int {
                            multipartFormData.append(Data("\(intElement)".utf8), withName: keyObj)
                        }
                    }
                }
            }
            
            if let data = videoData {
                multipartFormData.append(data, withName: "video", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
            }
        }, to: url, method: .post, headers: headers)
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// Enum for request methods
enum RMethod {
    case post
    case get
    case delete
    case put
}
