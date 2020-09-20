//
//  Services.swift
//  Shanab
//
//  Created by Macbook on 3/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class Services {
    //MARK:- Get Adds
    func getAdds(item_id: Int, item_type: String ,completion: @escaping( _ error: Error?, _ result: [Add]?) -> Void){
        let url = ConfigURLs.getAdds
        let parameters = [
            "item_type": item_type,
            "item_id": item_id
            ] as [String : Any]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let Adds = try
                        JSONDecoder().decode(GetAddsModelJSON.self, from: response.data!)
                    if Adds.status == true, let AddsList = Adds.data?.adds {
                        print(AddsList)
                        completion(nil, AddsList)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- Get All Restaurants
    func getAllRestaurants(type: [String] ,completion: @escaping(_ error: Error?, _ restaurants: [Restaurant]?)->Void) {
        let url = ConfigURLs.getAllRestaurants
        let parameters = [
            "type": type
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                print(json)
                do {
                    let restaurants = try
                        JSONDecoder().decode(AllRestaurantsModelJSON.self, from: response.data!)
                    if restaurants.status == true, let AllRestaurants = restaurants.data?.restaurants {
                        print(AllRestaurants)
                        completion(nil, AllRestaurants)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- post Restaurant Details
    func postRestaurantDetails(restaurant_id: Int, completion: @escaping(_ error: Error?, _ details: RestaurantDetail?)->Void) {
        let url = ConfigURLs.postRestaurantDetails
        let device_token = Helper.getDeviceToken() ?? ""
        let token = Helper.getApiToken() ?? ""
        let parameters = [
            "restaurant_id": restaurant_id
        ]
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let details = try
                        JSONDecoder().decode(RestaurantDetailsModelJSON.self, from: response.data!)
                    if details.status == true, let restaurantDetails = details.data?.restaurantDetail {
                        print(restaurantDetails)
                        completion(nil, restaurantDetails)
                    }
                } catch {
                    print(error)
                    completion(error, nil)
                    
                }
        }
        
    }
    //MARK:- Get All Catgeories
    func getAllCatgeories(completion: @escaping(_ error: Error?, _ catgeories: [Category]?)->Void) {
        let url = ConfigURLs.getAllCatgeories
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                print(json)
                do {
                    let catgeories = try
                        JSONDecoder().decode(AllCatgeoriesModelJSON.self, from: response.data!)
                    if catgeories.status == true, let allCatgeories = catgeories.data?.categories {
                        print(allCatgeories)
                        completion(nil, allCatgeories)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- Restaurant Meals
    func postRestaurantMeals(restaurant_id: Int, type: String, category_id: Int, completion: @escaping( _ error: Error?, _ Meals: [RestaurantMeal]?)->Void) {
        let url = ConfigURLs.postRestaurantMeals
        let parameters = [
            "restaurant_id": restaurant_id,
            "type": type,
            "category_id": category_id
            ] as [String : Any]
        let device_token = Helper.getDeviceToken() ?? ""
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let meaLs = try
                        JSONDecoder().decode(RestaurantMealsModelJSON.self, from: response.data!)
                    if meaLs.status == true, let restaurantMeals = meaLs.data?.restaurantMeals {
                        print(restaurantMeals)
                        completion(nil, restaurantMeals)
                    }
                }
                catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- get Settings
    func getSettings(completion: @escaping(_ error: Error?,  _ supporting: [Setting]?)->Void) {
        let url = ConfigURLs.getSettings
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let supporting = try
                        JSONDecoder().decode(SettingModelJSON.self, from: response.data!)
                    if supporting.status == true, let result = supporting.data?.settings {
                        print(result)
                        completion(nil, result)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    //MARK:- post Login
    func postLogin(email: String, password: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postLogin
        let parameters = [
            "email": email,
            "password": password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case.failure(let error):
                    completion(error, nil)
                case.success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "تم تسجيل الدخول بنجاح"
                        if let token = json["data"]["user"]["token"].string, let email = json["data"]["user"]["email"].string, let user_id = json["data"]["user"]["user_id"].int
                            
                        {
                            Singletone.instance.appUserType = .Customer
                            Helper.saveUserRole(role: Singletone.instance.appUserType.rawValue)
                            Helper.saveApiToken(token: token, email: email, user_id: user_id)
                            completion(nil, successMsg)
                        }
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.account = errorArr["account"] as? [String] ?? [""]
                        errorMsg.device_token = errorArr["device_token"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- post User Register
    func postUserRegister(name: String, email: String, password: String, phone: String, password_confirmation: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postUserRegister
        let parameters = [
            "name": name,
            "email": email,
            "password": password,
            "phone": phone,
            "password_confirmation": password_confirmation
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "true"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.name = errorArr["name"] as? [String] ?? [""]
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.phone = errorArr["phone"] as? [String] ?? [""]
                        errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- User ChangePassword
    func postUserChangePassword(email: String, password: String, password_confirmation: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postUserChangePassword
        let parameters = [
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "changed"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- User Profile Change Password
    func postUserProfileChangePassword(password: String, old_password: String, password_confirmation: String, completion: @escaping(_ error: Error?,_ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postUserPostChangeProfilePassword
        let token = Helper.getApiToken() ?? ""
        let parameters = [
            "password": password,
            "old_password": old_password,
            "password_confirmation": password_confirmation
        ]
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "changed"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.old_password = errorArr["old_password"] as? [String] ?? [""]
                        errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
        
    }
    //MARK:- User Change Profile Image
    func UserChangeProfileImage(image: UIImage, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?, _ progress: Progress?)->Void) {
        let url = ConfigURLs.postChangeUserProfileImage
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.upload(multipartFormData: { (form:MultipartFormData) in
            if let data = image.jpegData(compressionQuality: 0.8) {
                form.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to:  url, method: .post, headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                completion(error, nil, nil)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: { (progress: Progress) in
                    print("Uploading Image: \(progress.fractionCompleted)")
                    completion(nil, nil, progress)
                })
                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                    switch response.result {
                    case .failure(let error):
                        completion(error, nil, nil)
                    case .success(let value):
                        let json = JSON(value)
                        print("image updated \(json)")
                        if json["status"] == true {
                            let successMsg = SuccessError_Model()
                            successMsg.successMessage = json["message"].string ?? ""
                            completion(nil, successMsg, nil)
                        } else {
                            let errorMsg = SuccessError_Model()
                            guard let errorArr = json["data"]["errors"].dictionaryObject else {return}
                            errorMsg.image = errorArr["image"] as? [String] ?? [""]
                            completion(nil, errorMsg, nil)
                        }
                    }
                })
            }
        }
    }
    //MARK:- Get Code
    func postForgetPassword(email: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postForgetPassword
        let parameters = [
            "email": email
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "true"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    
    //MARK:- Set Token
    static func postUserSetToken(type: String, device_token: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postUserSetToken
        let parameter = [
            "device_token": device_token,
            "type": type
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.device_token = errorArr["device_token"] as? [String] ?? [""]
                        errorMsg.type = errorArr["type"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Driver Get Code
    func postDriverGetCode(email: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverGetCode
        let parameter = [
            "email": email
        ]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "true"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Driver Change Password
    func postDriverChangePassword(email: String, password: String, password_confirmation: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverChangePassword
        let parameter = [
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        Alamofire.request(url, method: .post, parameters:parameter, encoding:  URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "changed"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
                
        }
        
    }
    //MARK:- Driver ChangePassword Profile
    func postDriverChangePasswordProfile(password: String, old_password: String, password_confirmation: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverChangePasswordProfile
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameter = [
            "password": password,
            "old_password": old_password,
            "password_confirmation": password_confirmation
        ]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "changed"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.password = errorArr["password"] as? [String] ?? [""]
                        errorMsg.old_password = errorArr["old_password"] as? [String] ?? [""]
                        errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Driver Registrtion
    func postDriverRegistrtion(name: String, password: String, phone: String, password_confirmation: String,email: String, documents:  [UIImage], completion: @escaping(_ error: Error? , _  result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverRegistrtion
        let parameters = [
            "name": name,
            "password": password,
            "phone": phone,
            "password_confirmation": password_confirmation,
            "email": email,
        ]
        Alamofire.upload(multipartFormData: { (form :MultipartFormData) in
            
            for image in documents {
                if let data = image.jpegData(compressionQuality: 0.3) {
                    form.append(data, withName: "documents", fileName: "documents_images.jpeg", mimeType: "image/jpeg")
                }
            }
            
            for (key, value) in parameters {
                form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post,headers: nil) { (result :SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                completion(error, nil)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress { (progress :Progress) in
                    print(progress)
                } .responseJSON { (response :DataResponse<Any>) in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        completion(error, nil)
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        if json["status"] == true {
                            let successMsg = SuccessError_Model()
                            successMsg.successMessage = "Successful"
                            completion(nil, successMsg)
                        } else {
                            let errorMsg = SuccessError_Model()
                            guard let errorArr = json["errors"].dictionaryObject else {return}
                            errorMsg.name = errorArr["name"] as? [String] ?? [""]
                            errorMsg.phone = errorArr["phone"] as? [String] ?? [""]
                            errorMsg.password = errorArr["password"] as? [String] ?? [""]
                            errorMsg.password_confirmation = errorArr["password_confirmation"] as? [String] ?? [""]
                            errorMsg.email = errorArr["email"] as? [String] ?? [""]
                            completion(nil, errorMsg)
                        }
                        
                    }
                }
            }
        }
    }
    //MARK: Driver Login
    func postDriverLogin(email: String, password: String ,completion: @escaping( _ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverLogin
        let parameters = [
            "email": email,
            "password": password
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "true"
                        if let token = json["data"]["user"]["token"].string, let email = json["data"]["user"]["email"].string, let user_id = json["data"]["user"]["id"].int
                        {
                            Singletone.instance.appUserType = .Driver
                            Helper.saveUserRole(role: Singletone.instance.appUserType.rawValue)
                            Helper.saveApiToken(token: token, email: email, user_id: user_id)
                            completion(nil, successMsg)
                            
                        } else {
                            let errorMsg = SuccessError_Model()
                            guard let errorArr = json["errors"].dictionaryObject else {return}
                            errorMsg.email = errorArr["email"] as? [String] ?? [""]
                            errorMsg.password = errorArr["password"] as? [String] ?? [""]
                            errorMsg.account = errorArr["account"] as? [String] ?? [""]
                            errorMsg.device_token = errorArr["device_token"] as? [String] ?? [""]
                            completion(nil, errorMsg)
                        }
                        
                    }
                }
        }
    }
    //MARK: Driver Change Image
    func postDriverChangeImage(image: UIImage,completion: @escaping(_ error: Error?, _ result: SuccessError_Model?, _ progress: Progress?)->Void){
        let url = ConfigURLs.postDriverChangeImage
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.upload(multipartFormData: { (form:MultipartFormData) in
            if let data = image.jpegData(compressionQuality: 0.8) {
                form.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to:  url, method: .post, headers: headers) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let error):
                completion(error, nil, nil)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: { (progress: Progress) in
                    print("Uploading Image: \(progress.fractionCompleted)")
                    completion(nil, nil, progress)
                })
                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                    switch response.result {
                    case .failure(let error):
                        completion(error, nil, nil)
                    case .success(let value):
                        let json = JSON(value)
                        print("image updated \(json)")
                        if json["status"] == true {
                            let successMsg = SuccessError_Model()
                            successMsg.successMessage = json["message"].string ?? ""
                            completion(nil, successMsg, nil)
                        } else {
                            let errorMsg = SuccessError_Model()
                            guard let errorArr = json["data"]["errors"].dictionaryObject else {return}
                            errorMsg.image = errorArr["image"] as? [String] ?? [""]
                            completion(nil, errorMsg, nil)
                        }
                    }
                })
            }
        }
        
    }
    //MARK:- post Is Available
    func getIsAvailable(completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.gettDriverIsAvailableChange
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    }
                }
        }
        
    }
    //MARK:- Driver Set Token
    static func postDriverSetToken(type: String, device_token: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverSetToken
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameters = [
            "type": type,
            "token": device_token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.device_token = errorArr["device_token"] as? [String] ?? [""]
                        errorMsg.type = errorArr["type"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Driver Order List
    func getDriverOrderList(type: [String],completion: @escaping(_ error: Error?, _ result: [OrderList]?,_ orderErrors: OrdersErrors?)->Void) {
        let url = ConfigURLs.getDriverOrderList
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameters = [
            "type": type
        ]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value )
                print(json)
                do {
                    let list = try
                        JSONDecoder().decode(DriverOrderListModelJSON.self, from: response.data!)
                    if list.status == true, let order_list = list.data?.orders {
                        print(order_list)
                        completion(nil, order_list, nil)
                    } else if list.status == false, let OrderErrors = list.errors {
                        print(OrderErrors.account ?? "")
                        completion(nil, nil, OrderErrors)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil, nil)
                }
        }
    }
    //MARK:- Driver Order Details
    func postDriverOrderDetails(id: Int, completion: @escaping(_ error: Error?, _ details: [DriverOrder]?)->Void) {
        let url = ConfigURLs.getDriverOrderDetails
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameters = [
            "id": id
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let details = try
                        JSONDecoder().decode(DriverOrderDetalilsModelJSON.self, from: response.data!)
                    if details.status == true, let order_details = details.data?.orders {
                        print(order_details)
                        completion(nil, order_details)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
    }
    //MARK:- post User Create Order
    func postUserCreateOrder(lat: Double, long: Double, quantity: Int, currency: String, total: Int, message: String, address_id: Int, cartItems: [onlineCart], completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postUserCreateOrder
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        var cartItem = [[String: Any]]()
        for item in cartItems {
            var options = [[String:Any]]()
            for option in item.optionsContainer ?? [] {
                let addition = ["option_id" : option.id ?? 0]
                options.append(addition)
            }
            let order = ["order" : [
                "meal_id" : item.mealID ?? 0,
                "option" :options,
                "quantity": item.quantity ?? 0,
                "message": item.message ?? ""
                ]]
            cartItem.append(order)
        }
        
        
        print(modelToJSON(cartItems: cartItems))
        let parameters = [
                    "lat": lat,
                    "long": long,
                    "quantity": quantity,
                    "currency": currency,
                    "total": total,
                    "message": message,
                    "cartItems":
                        //(modelToJSON(cartItems: cartItems)),
      "[{\"order\":{\"meal_id\":6,\"quantity\":4,\"message\":\"notes\"},\"option\":[{\"option_id\":1},{\"option_id\":2}]},{\"order\":{\"meal_id\":7,\"quantity\":4}}]" ,
                    "address_id": address_id
                    ] as [String : Any]

        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding:JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    print("error in create order:\(error.localizedDescription)")
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.latitude = errorArr["lat"] as? [String] ?? [""]
                        errorMsg.longitude = errorArr["long"] as? [String] ?? [""]
                        errorMsg.currency = errorArr["currency"] as? [String] ?? [""]
                        errorMsg.quantity = errorArr["quantity"] as? [String] ?? [""]
                        errorMsg.total = errorArr["total"] as? [String] ?? [""]
                        errorMsg.message = errorArr["message"] as? [String] ?? [""]
                        errorMsg.cartItems = errorArr["cartItems"] as? [String] ?? [""]
                        print(errorMsg)
                        completion(nil, errorMsg)
                    }
                }
                
        }
        
        
    }
    func modelToJSON(cartItems:[onlineCart]) -> JSON{
        var itemsArr:[Dictionary<String,Any>] = []
        for cartIndex in 0...cartItems.count - 1{
             var dict:[String:Any] = [:]
            let item = cartItems[cartIndex]
            var mealdict:[String:Any] = ["meal_id": item.meal!.id! ,"quantity":item.quantity!]

            if item.message != ""{
                mealdict["message"] = item.message ?? ""
               
            }
            dict["order"] = mealdict
            if let options = item.optionsContainer, options.count > 0{
                var optionsArr:Array<Dictionary<String,Any>> = []
                for index in 0...options.count - 1{
                    let optionDict = ["option_id":options[index].id!]
                    if index != options.count - 1{
                        optionsArr.append(optionDict)
                    }
                }
               
                dict["option"] = optionsArr
            }
            itemsArr.append(dict)
        }
        print("JSON IS:\(itemsArr)")
       
//        for cartIndex in 0...cartItems.count - 1{
//            let item = cartItems[cartIndex]
//            string =  string + "{ \"order\":{ \"meal_id\":\(item.meal?.id ?? 0),\"quantity\":\(item.quantity ?? 0)"
//
//            if item.message != ""{
//                string = string + ",\"message\":\(item.message ?? "")"
//            }
//            string = string + "}"
//
//            if let options = item.optionsContainer, options.count > 0{
//                string = string + ",\"option\":["
//                for index in 0...options.count - 1{
//                    string = string + "{\"option_id:\(options[index].id!)}"
//                    if index != options.count - 1{
//                        string = string + ","
//                    }
//                }
//                string = string + "]"
//            }
//
//            string = string + "}"
//            if cartIndex != cartItems.count - 1{
//                string = string + ","
//            }
//        }
        return JSON(itemsArr)
    }
   //MARK: post Favorite Get
    func PostfavorieGet(item_type: String, completion: @escaping(_ error: Error?, _ favorits: [Favorites]?)->Void) {
        let url = ConfigURLs.postFavoriteGet
        let device_token = Helper.getDeviceToken() ?? ""
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameter = [
            "item_type": item_type
        ]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value )
                print(json)
                do {
                    let favorites = try
                        JSONDecoder().decode(FavoritesModelJSON.self, from: response.data!)
                    if favorites.status == true, let favoriteList = favorites.data?.favorite {
                        print(favoriteList)
                        completion(nil, favoriteList)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    //MARK:- Get mail Template
    func GetmailTemplate(type: String, completion: @escaping(_ error: Error?, _ result:[Tempalte]? )->Void) {
        let url = ConfigURLs.getmailTemplate
        let parameters = [
            "type": type
        ]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value )
                print(json)
                do {
                    let template = try
                        JSONDecoder().decode(MailTemplateModelJSON.self, from: response.data!)
                    if template.status == true, let mailTempale = template.data {
                        print(mailTempale)
                        completion(nil, mailTempale)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
                
        }
        
    }
    //MARK:- post Create Reservation
    func postCreateReservation(restaurant_id: Int, number_of_persons: Int, date: String, time: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postCreateReservation
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        let parameters = [
            "restaurant_id": restaurant_id,
            "number_of_persons": number_of_persons,
            "date": date,
            "time": time
            ] as [String : Any]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.restaurant_id = errorArr["restaurant_id"] as? [String] ?? [""]
                        errorMsg.number_of_persons = errorArr["number_of_persons"] as? [String] ?? [""]
                        errorMsg.date  = errorArr["date"] as? [String] ?? [""]
                        errorMsg.time = errorArr["time"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
                
        }
    }
    //MARK:- Get Reservations
    func postReservationsget(cancelation: Int, completion: @escaping( _ error: Error?, _ list: [reservationList]?)->Void) {
        let url = ConfigURLs.postgetReservations
        let parameters = [
            "cancelation": cancelation
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                print(json)
                do {
                    let list = try
                        JSONDecoder().decode(ReservationListModelJSON.self, from: response.data!)
                    if list.status == true, let reservation_list = list.data?.reservation {
                        print(reservation_list)
                        completion(nil, reservation_list)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
                
        }
    }
    //MARK: post User Get Order
    func postUserGetOrder(status: [String] ,completion: @escaping(_ error: Error?, _ list: [orderList]?)->Void) {
        let url = ConfigURLs.postUserGetOrder
        let parameters = [
            "status": status
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let list = try
                        JSONDecoder().decode(UserListModelJSON.self, from: response.data!)
                    if list.status == true, let UserList = list.data?.orders {
                        print(UserList)
                        completion(nil, UserList)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
        
    }
    //MARK: User Order Detail
    func postUserOrderDetail(id: Int, status: String, completion: @escaping(_ error: Error?, _ details: [DriverOrder]?)->Void) {
        let url = ConfigURLs.postUserOrderDetail
        let token = Helper.getApiToken() ?? ""
        let parameters = [
            "id": id,
            "status": status
            ] as [String : Any]
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                               print(json)
                do {
                    let details = try
                        JSONDecoder().decode(DriverOrderDetalilsModelJSON.self, from: response.data!)
                    if details.status == true, let order_details = details.data?.orders {
                        print(order_details)
                        completion(nil, order_details)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    //MARK:- Reservation Details
    func postReservationDetails(id: Int, completion: @escaping(_ error: Error?,_ details: DetailsDataClass?)->Void) {
        let url = ConfigURLs.postReservationDetails
        let parameters = [
            "id": Int()
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let details = try
                        JSONDecoder().decode(ReservationDetailstModelJSON.self, from: response.data!)
                    if details.status == true, let reservationDetails = details.data {
                        print(reservationDetails)
                        completion(nil, reservationDetails)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
        
    }
    //MARK:- Cancel Reservation
    func postCancelReservation(id: Int, completion: @escaping(_ error: Error?, _ reservation: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postCancelReservation
        let parameters = [
            "id": id
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = "done"
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.id = errorArr["id"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
        }
    }
    //MARK:- Remove Favorite
    func postRemoveFavorite(item_id: Int, item_type: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postRemoveFavorite
        let parameters = [
            "item_id": item_id,
            "item_type": item_type
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.item_id = errorArr["item_id"] as? [String] ?? [""]
                        errorMsg.item_type = errorArr["item_type"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
        }
    }
    //MARK: Create Favorite
    func postCreateFavorite(item_id: Int, item_type: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postCreateFavorite
        let parameters = [
            "item_id": item_id,
            "item_type": item_type
            ] as [String : Any]
        let deviceToken = Helper.getApiToken() ?? ""
        let headers = [
            "deviceToken": deviceToken
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.item_id = errorArr["item_id"] as? [String] ?? [""]
                        errorMsg.item_type = errorArr["item_type"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
        }
    }
    //MARK:- Driver Change Order Status
    func postDriverChangeOrderStatus(id: Int, completion: @escaping( _ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDriverChangeOrderStatus
        let parameters = [
            "id": id
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.id = errorArr["id"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
                
        }
    }
    //MARK:- get User Profile
    func getProfile(completion: @escaping (_ error: Error?, _ result: User?)->Void) {
        let url = ConfigURLs.getProfile
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                do {
                    let result = try
                        JSONDecoder().decode(GetProfileModelModelJSON.self, from: response.data!)
                    if result.status == true, let profileResult = result.data?.user {
                        print(profileResult)
                        completion(nil, profileResult)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    
    
    //MARK:- post Meal Search
    func postMealSearch(word: String, completion: @escaping( _ error: Error?, _ result: [CollectionDataClass]?)->Void) {
        let url = ConfigURLs.postMealSearch
        let parameters = [
            "word": word
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
//                let json = JSON(response.result.value as Any)
//                               print(json)
                do {
                    let result = try
                        JSONDecoder().decode(MealSearchModelJSON.self, from: response.data!)
                    if result.status == true, let mealsResult = result.data?.searchResult {
                        print(mealsResult)
                        completion(nil, mealsResult)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //Mark: Search In Restaurants
    func postSearchRestauran(word: String, completion: @escaping( _ error: Error?, _ result: [SearchResult]?)->Void) {
        let url = ConfigURLs.postRestaurantSearch
        let parameters = [
            "word": word
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                do {
                    let result = try
                        JSONDecoder().decode(RestaurantSearchModelModelJSON.self, from: response.data!)
                    if result.status == true, let ResultResult = result.data?.searchResult {
                        print(ResultResult)
                        completion(nil, ResultResult)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
        
        
    }
    //MARK: User Edit Profile
    func postUserEditProfile(phone: String, name_ar: String, email: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postEditProfile
        let parameters = [
            "phone": phone,
            "name_ar": name_ar,
            "email": email
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.phone = errorArr["phone"] as? [String] ?? [""]
                        errorMsg.name = errorArr["name"] as? [String] ?? [""]
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
                
        }
    }
    //MARK:- post Driver Edit Profile
    func postDriverEditProfile(phone: String, name_ar: String, email: String, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postEditDriverProfile
        let parameters = [
            "phone": phone,
            "name_ar": name_ar,
            "email": email
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.phone = errorArr["phone"] as? [String] ?? [""]
                        errorMsg.name = errorArr["name"] as? [String] ?? [""]
                        errorMsg.email = errorArr["email"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                        
                    }
                }
        }
    }
    //MARK: get Driver Profile
    func getDriverProfile(completion: @escaping (_ error: Error?, _ result: User?)->Void) {
        let url = ConfigURLs.getProfile
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                do {
                    let result = try
                        JSONDecoder().decode(GetProfileModelModelJSON.self, from: response.data!)
                    if result.status == true, let profileResult = result.data?.user {
                        print(profileResult)
                        completion(nil, profileResult)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    //MARK:- Meal Details
    func postMealDetails(meal_id: Int, Completion: @escaping(_ error: Error?, _ result: CollectionDataClass?)->Void) {
        let url = ConfigURLs.postMealDetails
        let parameters = [
            "meal_id": meal_id
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value)
                print(json)
                do {
                    let mealDetails = try JSONDecoder().decode(MealDetailsModelJSON.self, from: response.data!)
                    print(mealDetails)
                    if mealDetails.status == true, let details = mealDetails.data {
                        print(details)
                        Completion(nil, details)
                    }
                } catch {
                    print(error.localizedDescription)
                    Completion(error, nil)
                    
                }
        }
    }
    //MARK:- get Addresses
    func getAddresses(completion: @escaping(_ error: Error?, _ addressList: [Address]?)->Void) {
        let url = ConfigURLs.getAddresses
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let addresses = try JSONDecoder().decode(AddressesListModelJSON.self, from: response.data!)
                    if addresses.status == true, let listOfAddress = addresses.data?.address {
                        print(listOfAddress)
                        completion(nil, listOfAddress)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- Add Address
    func postAddAddress(lat: Double, long: Double, address: String, floor: Int, country_id: Int, city_id: Int, area_id: Int, building: Int, apartment: Int, completion: @escaping(_ error: Error?, _ result: SuccessError_Model? )->Void) {
        let url = ConfigURLs.postAddAddress
        let parameters = [
            "lat": lat,
            "long": long,
            "address": address,
            "floor": floor,
            "country_id": country_id,
            "city_id": city_id,
            "area_id": area_id,
            "building": building,
            "apartment": apartment
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.latitude = errorArr["lat"] as? [String] ?? [""]
                        errorMsg.longitude = errorArr["long"] as? [String] ?? [""]
                        errorMsg.address = errorArr["address"] as? [String] ?? [""]
                        errorMsg.floor = errorArr["floor"] as? [String] ?? [""]
                        errorMsg.country_id = errorArr["country_id"] as? [String] ?? [""]
                        errorMsg.city_id = errorArr["city_id"] as? [String] ?? [""]
                        errorMsg.area_id = errorArr["area_id"] as? [String] ?? [""]
                        errorMsg.building = errorArr["building"] as? [String] ?? [""]
                        errorMsg.apartment = errorArr["apartment"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Get Cities
    func postGetCities(table: String, condition: String, id: Int, completion: @escaping( _ error: Error?, _ result: [Country]?)->Void) {
        let url = ConfigURLs.postGetCountries
        let parameters = [
            "table": table,
            "condition": condition,
            "id": id
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let countries = try JSONDecoder().decode(GetCountriesModelJSON.self, from: response.data!)
                    if countries.status == true, let result = countries.data?.countries {
                        print(result)
                        completion(nil, result)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    // MARK:- Get Cities And Aries
    func postGetCountries(table: String,  completion: @escaping( _ error: Error?, _ result: [Country]?)->Void) {
        let url = ConfigURLs.postGetCities
        let parameters = [
            "table": table,
            "condition": "null"
            ,
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                let json = JSON(response.result.value as Any)
                print(json)
                do {
                    let countries = try JSONDecoder().decode(GetCountriesModelJSON.self, from: response.data!)
                    if countries.status == true, let result = countries.data?.countries {
                        print(result)
                        completion(nil, result)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                }
        }
    }
    //MARK:- Delete Address
    func postDeleteAddress(id: Int, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDeleteAddress
        let parameters = [
            "id": id
        ]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.id = errorArr["id"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
                
        }
    }
    //MARK:-  Get Setting
    func getSetting(completion: @escaping(_ error: Error?, _ result: [Setting]?)->Void){
        let url = ConfigURLs.getSetting
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                do {
                    let setting = try JSONDecoder().decode(SettingModelJSON.self, from: response.data!)
                    if setting.status == true, let result = setting.data?.settings {
                        print(result)
                        completion(nil, result)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
        
    }
    //MARK:- Get Cart Items
    func getCartItems(completion: @escaping(_ error: Error?, _ result: [onlineCart]?)->Void) {
        let url = ConfigURLs.getCartItems
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                do {
                    let items = try JSONDecoder().decode(OnlineCartModelJSON.self, from: response.data!)
                    if items.status == true, let result = items.data?.cart {
                        print(result)
                        completion(nil, result)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(error, nil)
                    
                }
        }
    }
    //MARK:- Add To Cart
    func postAddToCart(meal_id: Int, quantity: Int, message: String, options: [Int], completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postAddToCart
        let parameters = [
            "meal_id": meal_id,
            "quantity": quantity,
            "message": message,
            "options": options
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.meal_id = errorArr["meal_id"] as? [String] ?? [""]
                        errorMsg.quantity = errorArr["quantity"] as? [String] ?? [""]
                        errorMsg.message = errorArr["message"] as? [String] ?? [""]
                        errorMsg.options = errorArr["options"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
    }
    //MARK:- Delete Cart
    func postDeleteCart(condition: String, id: Int, completion: @escaping(_ error: Error?, _ result: SuccessError_Model?)->Void) {
        let url = ConfigURLs.postDeleteCart
        let parameters = [
             "id": id,
            "condition": condition
            ] as [String : Any]
        let token = Helper.getApiToken() ?? ""
        let headers = [
            "token": token
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                switch response.result {
                case .failure(let error):
                    completion(error, nil)
                case .success(let value):
                    let json = JSON(value)
                    if json["status"] == true {
                        let successMsg = SuccessError_Model()
                        successMsg.successMessage = json["message"].string ?? ""
                        completion(nil, successMsg)
                    } else {
                        let errorMsg = SuccessError_Model()
                        guard let errorArr = json["errors"].dictionaryObject else {return}
                        errorMsg.condition = errorArr["condition"] as? [String] ?? [""]
                        errorMsg.id = errorArr["id"] as? [String] ?? [""]
                        completion(nil, errorMsg)
                    }
                }
        }
        
    }
}
