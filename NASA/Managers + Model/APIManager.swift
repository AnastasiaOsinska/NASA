
//  APIManager.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    // MARK: - Properties
    
    static let shared = APIManager()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Get Data From Api
    
    func getDataFromAPI(completion: @escaping (_ spaceModel: SpaceModel?) -> Void){
        let urlString = Constants.apiKey
        let url = URL(string:urlString)
        guard let unwrappedUrl = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let spaceModel = try jsonDecoder.decode(SpaceModel.self, from: unwrappedData)
                completion(spaceModel)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getMarsPhotoFromAPI(completion: @escaping (_ photo: Photos?) -> Void){
        let urlString = Constants.marsApi
        let url = URL(string:urlString)
        guard let unwrappedUrl = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let photos = try jsonDecoder.decode(Photos.self, from: unwrappedData)
                completion(photos)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
//    func loadImage(from url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
//        guard let url = URL(string: url ?? "") else {
//            completion(nil)
//            return
//        }
//        DispatchQueue.global().async {
//            guard let data = try? Data(contentsOf: url) else {
//                completion(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                completion(UIImage(data: data))
//            }
//        }
//    }

}

