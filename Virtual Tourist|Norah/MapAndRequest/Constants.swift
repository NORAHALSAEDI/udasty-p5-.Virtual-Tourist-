//
//  Constants.swift
//  VirtalTourist3
//
//  Created by نورة . on 16/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import Foundation
import UIKit

struct info {

    static let APIKey = "d26c1731665540e60a0ca9f7f362b6ca"
    static let SearchBBoxHalfWidth = 1.0
    static let SearchBBoxHalfHeight = 1.0
}

struct Keys {
    static let APIKey = "api_key"
    static let Method = "method"
    static let Extras = "extras"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    static let BoundingBox = "bbox"
    static let PerPage = "per_page"
    static let Page = "page"
    static let Lat = "lat"
    static let Lon = "lon"
}

struct Values {
    static let ResponseFormat = "json"
    static let DisableJSONCallback = "1"
    static let MediumURL = "url_m"
}

struct Methods {
    static let SearchMethod = "flickr.photos.search"
}

struct ResponseKeys {
    static let Photos = "photos"
    static let Photo = "photo"
}

