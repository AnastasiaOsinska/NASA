
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
        let url = URL(string: urlString)
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
    
    func getEarthPhotoFromAPI(completion: @escaping (_ image: [Image]?) -> Void){
        let urlString = Constants.earthApi
        let url = URL(string: urlString)
        guard let unwrappedUrl = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let images = try jsonDecoder.decode([Image].self, from: unwrappedData)
                completion(images)
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func buildUrl(stringDate: String?, imageName: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.oldDateFormat
        guard let date = dateFormatter.date(from: stringDate ?? "") else { return "" }
        dateFormatter.dateFormat = Constants.newDateFormat
        let stringDateNew = dateFormatter.string(from: date)
        return "\(Constants.buildUrl)\(stringDateNew)\(Constants.png)\(imageName)\(Constants.dotPng)"
    }
}
