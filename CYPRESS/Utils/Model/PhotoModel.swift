//
//  PhotoModel.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import RealmSwift
struct PhotoModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case id
        case albumId
        case title
        case thumbnailUrl
    }
    
    var url: String?
    var id: Int?
    var albumId: Int?
    var title: String?
    var thumbnailUrl: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        albumId = try container.decodeIfPresent(Int.self, forKey: .albumId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
    }
    
}

class RealmPhotoModel: Object {
    @objc dynamic var url: String?
    @objc dynamic var id = 0
    @objc dynamic var albumId = 0
    @objc dynamic var title: String?
    @objc dynamic var thumbnailUrl: String?
}
