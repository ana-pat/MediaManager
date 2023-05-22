//
//  CameraRollAccess.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 01/03/23.
//

import Foundation
import Photos
import UIKit

class CameraRollAccess{
 
    var list: [PHAsset]
    var group: [String:[PHAsset]]
    var index: [String]
    
    static var shared = CameraRollAccess()
   
    let thumbnail_size: CGSize = CGSize(width: 160, height: 160)
    
    private init(){
        list = []
        group = [:]
        index = []
    }

    func getPhotosAndVideos(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        imagesAndVideos.enumerateObjects({ (object, count, stop) in
            self.list.append(object)
        })
        print(imagesAndVideos.count)
    }
     
    func checkAuthorizationForPhotoLibraryAndGet(){
            let status = PHPhotoLibrary.authorizationStatus()

            if (status == PHAuthorizationStatus.authorized) {
                // Access has been granted.
                getPhotosAndVideos()
            }else {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in

                    if (newStatus == PHAuthorizationStatus.authorized) {
                            self.getPhotosAndVideos()
                    }else {

                    }
                })
            }
    }
    
    func extractImageFromAsset(_ asset: PHAsset,_ size: CGSize) -> UIImage? { //use size as type
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    func createGroup(){
        for temp in list{
            let dateStr = dateFormatter(temp, "MMMM YYYY")
            
            if group.keys.contains(dateStr){
                self.group[dateStr]!.append(temp)
            }else{
                self.index.append(dateStr)
                self.group[dateStr] = [temp]
            }
        }
    }
    
    func getFromPhotoLibrary(){
        self.checkAuthorizationForPhotoLibraryAndGet()
        self.createGroup()
    }
    func dateFormatter(_ asset: PHAsset, _ str: String) -> String{
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = str
                let strDate = dateFormatter.string(from: asset.creationDate!)
                return strDate
    }
    
    
    func getAttribute(_ asset:PHAsset) -> [String]{

            let resource = PHAssetResource.assetResources(for: asset)
            let filename = resource.first?.originalFilename ?? "unknown"
            let strDate = dateFormatter(asset, "dd/MM/YYYY")
                
            let size = resource.first?.value(forKey: "fileSize") as! CLong
            let sizeOnDisk = Int64(bitPattern: UInt64(size))
            let strSize = ByteCountFormatter.string(fromByteCount: sizeOnDisk, countStyle: .file)
                
            return [filename,strDate,strSize]
            }
    
    func removeSlash(_ str: String) -> String{
        var s : String = ""
        for char in str{
            if char != "/"{
                s += String(char)
            }
        }
        return s
    }
     
}

