
//  APIManager.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    private struct Constants {
        static let apiKey = "https://api.nasa.gov/planetary/apod?api_key=GwY5NDy8QYbxTsRzsqxFSwPf8AeflhIUB1IcYmIn"
        static let earthApi = "https://epic.gsfc.nasa.gov/api/natural"
        static let marsApi = "&api_key=GwY5NDy8QYbxTsRzsqxFSwPf8AeflhIUB1IcYmIn"
        static let marsUrlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date="
        static let newEarthDateFormat = "yyyy/MM/dd"
        static let oldEarthDateFormat = "YYYY-MM-dd HH:mm:ss"
        static let marsDateFormat = "YYYY-MM-dd"
        static let buildUrl = "https://epic.gsfc.nasa.gov/archive/natural/"
        static let png = "/png/"
        static let dotPng = ".png"
    }
    
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
    
    func getMarsPhotoFromAPI(with date: Date? = nil, completion: @escaping (_ photo: Photos?) -> Void) {
        var currentDate: Date
        if let date = date {
            currentDate = date
        } else {
            currentDate = Date()
        }
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.marsDateFormat
        let result = formatter.string(from: currentDate)
        let urlString = "\(Constants.marsUrlString)\(result)\(Constants.marsApi)"
        let url = URL(string: urlString)
        guard let unwrappedUrl = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: unwrappedUrl) { [weak self] (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let photos = try jsonDecoder.decode(Photos.self, from: unwrappedData)
                guard !photos.photos.isEmpty else {
                    self?.getMarsPhotoFromAPI(with: currentDate.dayBefore, completion: completion)
                    print(currentDate.dayBefore)
                    return
                }
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
    
    func buildEarthUrl(stringDate: String?, imageName: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.oldEarthDateFormat
        guard let date = dateFormatter.date(from: stringDate ?? "") else { return "" }
        dateFormatter.dateFormat = Constants.newEarthDateFormat
        let stringDateNew = dateFormatter.string(from: date)
        return "\(Constants.buildUrl)\(stringDateNew)\(Constants.png)\(imageName)\(Constants.dotPng)"
    }
}

extension Date {
        func someDaysAgoDate(_ count: Int) -> Date {
            return Calendar.current.date(byAdding: .day, value: -count, to: noon)!
        }
    static var yesterday: Date { return Date().dayBefore }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: Constants.value, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: Constants.hour, minute: Constants.time, second: Constants.time, of: self)!
    }
}
