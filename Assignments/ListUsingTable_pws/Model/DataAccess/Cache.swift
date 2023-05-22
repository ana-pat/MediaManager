//
//  Caching.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 06/03/23.
//

import Foundation
import UIKit
import Photos

class Cache{
    
    static var shared = Cache()
    
    private init(){
        
    }
    
    let memoryCache = NSCache<NSString, UIImage> ()
    
    let thumbnail_size: CGSize = CGSize(width: 160, height: 160)
    
    
    func setToMemoryCache(id: String, img: UIImage){
            self.memoryCache.setObject(img, forKey: id as NSString)
    }
    
    func setToDiskCache(id: String, img: UIImage){
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(id)
        
        if let data = img.pngData() {
            try? data.write(to: destURL)
        }
    }
    
    func getFromMemoryCache(key: String) -> UIImage?{
        if let image = self.memoryCache.object(forKey: key as NSString){
            return image
        }else{
            return nil
        }
    }
    
    func getFromDiskCache(key: String) -> UIImage?{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        if let url = documentsURL?.appendingPathComponent(key){
            if let img = UIImage(contentsOfFile: url.relativePath){
                return img
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}
