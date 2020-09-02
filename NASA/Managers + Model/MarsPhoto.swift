//
//  MarsModel.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/6/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Photos: Codable {
    var photos: [Photo]
}

final class Photo: Codable {
    var img_src : String?
    var earth_date : String?
    var sol : Int?
    var camera : Camera
}

final class Camera: Codable {
    var name : String?
    var full_name : String?
}
