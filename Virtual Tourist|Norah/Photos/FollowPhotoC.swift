//
//  FollowPhotoC.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import Foundation
import Foundation
import UIKit

//MARK: Alert
extension UIViewController{
    func showAlert(message: String, vc: UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
extension PhotoFliViewController{
    //MARK: activityIndicator func
    func activityIndicator(status: Bool){
        DispatchQueue.main.async {
            if status == true {
                self.Activityindicator.startAnimating()
                self.Activityindicator.isHidden = false
            }
            else {
                self.Activityindicator.isHidden = true
                self.Activityindicator.stopAnimating()
                
            }
        }
        
    }
}
