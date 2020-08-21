//
//  EarthPhoto.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/18/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Image: Codable {
    var identifier : String?
    var caption : String?
    var image : String?
    var version : String?
    var date : String?
}
