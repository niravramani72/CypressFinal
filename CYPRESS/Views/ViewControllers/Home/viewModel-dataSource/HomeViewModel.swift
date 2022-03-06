//
//  HomeViewModel.swift
//  CYPRESS
//
//  Created by Nirav Ramani on 05/03/22.
//

import Foundation
import Alamofire
import RealmSwift
class HomeViewModel {
    
    //MARK: - Variables
    private let apiManager = APIManager()
    
    struct Struct_Albums {
        var album: AlbumModel?
        var photos: [PhotoModel] = []
    }
    
    private var albums : [Struct_Albums] = []
    private var realmAlbums : [RealmAlbumModel] = []
    private var tmpRealmAlbumsForInfinite : [RealmAlbumModel] = []
    
    private var realm: Realm!
    var apiDelegate : ProtocolHomeViewModel?
    let dispatchGroup = DispatchGroup()
    
    //MARK: - Class methods
    init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            print(error)
        }
        /// 2 time reversed() is just use to convert realm result type to array type
        self.realmAlbums = realm.objects(RealmAlbumModel.self).reversed().reversed()
        self.tmpRealmAlbumsForInfinite = self.realmAlbums
    }
    
    func addDataToRealm() {
        self.apiDelegate?.apiDataFetched(isReloadRequired: false)
        do {
            if let lastAlbum = albums.last {
                let obj = realm.objects(RealmAlbumModel.self).filter("id == \(lastAlbum.album?.id ?? -1)")
                if obj.isEmpty {
                    // realm has not same data so adding data into it
                    try realm.write {
                        for album in albums {
                            if let albumData = album.album {
                                let model = RealmAlbumModel(album: albumData, photosList: album.photos)
                                realm.add(model)
                            }
                        }
                    }
                    self.realmAlbums = realm.objects(RealmAlbumModel.self).reversed().reversed()
                    self.tmpRealmAlbumsForInfinite = self.realmAlbums
                    self.apiDelegate?.apiDataFetched(isReloadRequired: true)
                }else{
                    print("Realm already contains this data.")
                }
            }
        }catch{
            print(error)
        }
    }
    
    //MARK: - API methods
    func getAlbumsData() {
        apiManager.call(type: .albums, queryParam: [:]) { (result: Swift.Result<[AlbumModel], AlertMessage>) in
            switch result {
            case .success(let data):
                for album in data {
                    if let id = album.id {
                        self.getPhotosData(albumId: id)
                    }
                    self.albums.append(Struct_Albums(album: album, photos: []))
                }
                self.dispatchGroup.notify(queue: .main) {
                    self.addDataToRealm()
                }
            case .failure(let alertMessage):
                print(alertMessage.body)
            }
        }
        
    }
 
    func getPhotosData(albumId: Int) {
        let param: ApiParam = [
            "albumId": albumId
        ]
        dispatchGroup.enter()
        apiManager.call(type: .photos, queryParam: param) { (result: Swift.Result<[PhotoModel], AlertMessage>) in
            switch result {
            case .success(let data):
                let index = self.albums.firstIndex { album in  album.album?.id == albumId }
                if let index = index {
                    self.albums[index].photos = data
                }
            case .failure(let alertMessage):
                print(alertMessage.body)
            }
            self.dispatchGroup.leave()
        }
    }
}
//MARK: - Getters and Setters
extension HomeViewModel {
   
    func getTotalNumberOfAlbums() -> Int {
        return realmAlbums.count
    }
    
    func getAlbumId(at section: Int) -> Int {
        return realmAlbums[section].id
    }
    
    func getAlbumTitle(at section: Int) -> String {
        return realmAlbums[section].title ?? ""
    }
    
    func getPhotoCount(at section: Int) -> Int {
        return realmAlbums[section].photos.count
    }
    
    func getPhotoId(at section: Int, index: Int) -> Int {
        return realmAlbums[section].photos[index].id
    }
    
    func getPhotoURL(at section: Int, index: Int) -> String? {
        return realmAlbums[section].photos[index].thumbnailUrl
    }
    
    func getTempAlbums() -> [RealmAlbumModel] {
        return tmpRealmAlbumsForInfinite
    }
    
    // methods for infinite logic
    func infiniteGetTotalNumberOfAlbums() -> Int {
        return getTotalNumberOfAlbums() * 2
    }
    
    func infiniteGetPhotoCount(at section: Int) -> Int {
        return getPhotoCount(at: infiniteGetAlbumIndex(for: section)) * 2
    }
    
    func infiniteGetAlbumIndex(for section: Int) -> Int {
        var index = section
        if index > getTotalNumberOfAlbums() - 1 {
            index -= getTotalNumberOfAlbums()
        }
        return index % getTotalNumberOfAlbums()
    }
    
    func infiniteGetPhotoIndex(for section: Int, index: Int) -> Int {
        var photoIndex = index
        if photoIndex > getPhotoCount(at: section) - 1 {
            photoIndex -= getPhotoCount(at: section)
        }
        return photoIndex % getPhotoCount(at: section)
    }
}
