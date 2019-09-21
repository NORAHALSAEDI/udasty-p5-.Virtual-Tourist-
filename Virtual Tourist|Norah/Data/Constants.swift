//
//  Constants.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//
/*
import Foundation
import UIKit
struct info {
    
    struct flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        static let APIKey = "d26c1731665540e60a0ca9f7f362b6ca"
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct flickrKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
        static let latitude = "lat"
        static let longitude = "lon"
    }
    
    struct flickrValues {
        static let SearchMethod = "flickr.photos.search"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        // static let PerPage = 3
    }
    
    
    struct ResponKayes {
        static let Photos = "photos"
        static let Photo = "Photo"
        
    }
    
    
}






