//
//  AlbumModel.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import RealmSwift

struct AlbumModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
    }
    
    var userId: Int?
    var id: Int?
    var title: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
    
}


public class RealmAlbumModel: Object {
    @objc dynamic var userId = 0
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    let photos = List<RealmPhotoModel>()
    
    override init() {
        super.init()
    }
    
    init(album: AlbumModel, photosList: [PhotoModel]) {
        userId = album.userId ?? 0
        id = album.id ?? 0
        title = album.title
        for photo in photosList {
            let model = RealmPhotoModel()
            model.id = photo.id ?? 0
            model.thumbnailUrl = photo.thumbnailUrl
            model.albumId = photo.albumId ?? 0
            model.url = photo.url
            model.title = photo.title
            photos.append(model)
        }
    }
}
