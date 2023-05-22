//
//  displayGrid.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 28/02/23.
//

import Foundation
import UIKit

class DisplayGrid: UICollectionViewCell{
    
    @IBOutlet weak var gridCell: UIImageView!
    
    func configureGooglePhoto(url: String, id: String){
        
        if let memCache = Cache.shared.getFromMemoryCache(key: id){
            gridCell.image = memCache
            print("From memory Cache")
        }else if let diskCache = Cache.shared.getFromDiskCache(key: id){
            gridCell.image = diskCache
            print("From Disk Cache")
            Cache.shared.setToMemoryCache(id: id, img: diskCache)
        }else{
            getImageFromURL(url: url, id: id)
            print("From Camera Roll")
        }
        gridCell.layer.cornerRadius = 5
    }
    
    func getImageFromURL(url: String, id: String){
     
        let updatedURL = url + "=w60-h60"

        let dataTask = URLSession.shared.dataTask(with: URL(string: updatedURL)!) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    let img = UIImage(data: data)!
                    self?.gridCell.image = img
                    
                    Cache.shared.setToMemoryCache(id: id, img: img)
                    Cache.shared.setToDiskCache(id: id, img: img)
                }
            }
        }
        dataTask.resume()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gridCell.image = nil
    }
}
