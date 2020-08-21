//
//  Constants.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Constants {
    static let apiKey = "https://api.nasa.gov/planetary/apod?api_key=GwY5NDy8QYbxTsRzsqxFSwPf8AeflhIUB1IcYmIn"
    static let marsApi = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=GwY5NDy8QYbxTsRzsqxFSwPf8AeflhIUB1IcYmIn"
    static let earthApi = "https://epic.gsfc.nasa.gov/api/natural"
    static let defaultImage = "cosmos"
    static let nibName = "MarsPhotoTableViewCell"
    static let xibName = "EarthPictureTableViewCell"
    static let identifier = "MarsPhotoTableViewCellID"
    static let earthId = "EarthPictureTableViewCellID"
    static let earth = "earth"
    static let mars = "mars"
    static let picture = "picture"
    let path = "ImageCache"
    static let tag = 0
    static let numberOfRow = 0
}
