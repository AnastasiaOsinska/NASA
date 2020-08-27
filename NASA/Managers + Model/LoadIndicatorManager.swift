//
//  LoadIndicatorManager.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/21/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit

class LoadIndicator : UIViewController {
    
    var spinner : UIView?
    
    static let shared = LoadIndicator()
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = self.view.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        spinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}
