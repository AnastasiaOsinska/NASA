//
//  ImageManager.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/12/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader: UIImageView {
let imageCache = NSCache<AnyObject, AnyObject>()
    
    var imageURL: URL?
    static let shared = ImageLoader()
    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL) {
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageURL = url
        image = nil
        activityIndicator.startAnimating()
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == url {
                        self.image = imageToCache
                    }

                    self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
    
    func loadImage(from url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
           guard let url = URL(string: url ?? "") else {
               completion(nil)
               return
           }
           DispatchQueue.global().async {
               guard let data = try? Data(contentsOf: url) else {
                   completion(nil)
                   return
               }
               DispatchQueue.main.async {
                   completion(UIImage(data: data))
               }
           }
       }
}
