//
// Network.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import Foundation

class Network {
    
    static let sharedInstance = Network()
    
    func getPhotosLocation(_ latitude: Double, _ longitude: Double,pageNumber: Int, _ completion: @escaping (_ success: Bool, _ data: [[String: Any]]? ) -> Void) {
        
        //1.Set the parameters
        let params = [Keys.APIKey: info.APIKey
            ,Keys.Method: Methods.SearchMethod,
             Keys.Extras: Values.MediumURL,
             Keys.Format: Values.ResponseFormat,
             Keys.Lat: String(describing: latitude),
             Keys.Lon: String(describing: longitude),
             Keys.Page: "\(pageNumber)",
            Keys.PerPage:"3" ,
            Keys.NoJSONCallback: Values.DisableJSONCallback]
            as [String: Any]
        
        //2. Build the url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        //3. Make the request
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            func showError(_ errorString: String) {
                print(errorString)
                completion(false, nil)
                return
            }
            
            //GUARD was there any errors?
            guard (error == nil) else {
                showError("There was an error with your request.")
                return
            }
            
            //GUARD did we get a statusCode other than 2xx?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode < 300 else {
                showError("Unsuccessful request response retured.")
                return
            }
            
            let parsedData: [String: AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
            } catch {
                showError("Could not parse data")
                return
            }
            
            guard let photos = parsedData[ResponseKeys.Photos] as! [String: Any]?,
                let photo = photos[ResponseKeys.Photo] as! [[String: Any]]? else {
                    showError("Could not extract photos and/or photo dict")
                    return
            }
            
            completion(true, photo)
        }
        //7.start the request
        task.resume()
    }
    
    
    func buildUrl (){
        
    }
    
    
}


