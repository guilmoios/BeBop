//
//  NetworkManager.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/4/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

struct API {
    struct Endpoints {
        public static let search = "https://news.bandsintown.com/searchArtists?search=%@"
        public static let artist = "https://rest.bandsintown.com/artists/%@?app_id=bebop"
        public static let events = "https://rest.bandsintown.com/artists/%@/events?app_id=bebop"
    }
}

typealias CompletionBlock = (NSError?) -> Void
var completionBlock: CompletionBlock?

class NetworkManager: NSObject {
    open static var shared = NetworkManager()
    
    private let configuration: URLSessionConfiguration?
    private let sessionManager: Alamofire.SessionManager?
    
    override init() {
        configuration = URLSessionConfiguration.background(withIdentifier: "com.mogames.bebop")
        sessionManager = Alamofire.SessionManager(configuration: configuration!)
        
        super.init()
    }
    
    func request(_ url: String, parameters: [String: Any], showLoading: Bool? = true, completionHandler: @escaping (_ response: Any?) -> ()) {

        if showLoading! {
            DispatchQueue.main.async {
                KRProgressHUD.show()
            }
        }
        var tempURL = url
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            tempURL = encodedURL
        }
        print("request: \(tempURL)")
        
        sessionManager?.request(tempURL, method: .get, parameters: parameters, encoding: parameters.count > 0 ? JSONEncoding.default : URLEncoding.default, headers: nil).responseJSON { (response) in
            
            KRProgressHUD.dismiss()
            if let _ = response.error {
                self.handleError()
                completionHandler(nil)
                return
            }
            
            if let result = response.result.value {
                debugPrint(result)
                if let res = result as? [String: Any] {
                    if let err = res["message"] as? String {
                        self.handleError(err)
                        completionHandler(nil)
                        return
                    }
                }
                completionHandler(result)
            }
        }
        
    }
    
    func handleError(_ errorMessage: String = "An error has occured, please try again", action: CompletionBlock? = nil) {
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
            if action != nil {
                action!(nil)
            }
        }))
        
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
}

