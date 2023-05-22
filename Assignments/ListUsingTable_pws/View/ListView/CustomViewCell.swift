//
//  CustomViewCell.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 22/02/23.
//

import Foundation
import UIKit



class CustomViewCell: UITableViewCell{
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    
    @IBAction func buttonClicked(_ sender: UIButton) {

        if Favourite.shared.checkInFav(id: favouriteButton.accessibilityLabel!){
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            Favourite.shared.removeFavourite(id: self.favouriteButton.accessibilityLabel!)
            print("unmarked as favourite")
        }else{
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            Favourite.shared.addToFavourite(id: self.favouriteButton.accessibilityLabel!)
            print("Marked as favourite")
        }
    }
    
    func setFavourite(){
        if Favourite.shared.checkInFav(id: favouriteButton.accessibilityLabel!){
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print("Unmarked as favourite")
        }else{
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            print("Marked as favourite")
        }
    }
    
    func configureImage(_ img: UIImage){
        thumbnail.image = img
    }
    
    func configureData(_ arr: [String]){
        name.numberOfLines = 0
        name.text = arr[0]
        //size.text = "Size: \(arr[1])"
        date.text = "Date: \(arr[2])"
    }
    
    func configureGooglePhoto(url: String, id: String){
        
        if let memCache = Cache.shared.getFromMemoryCache(key: id){
            thumbnail.image = memCache
            print("From memory Cache")
        }else if let diskCache = Cache.shared.getFromDiskCache(key: id){
            thumbnail.image = diskCache
            print("From Disk Cache")
            Cache.shared.setToMemoryCache(id: id, img: diskCache)
        }else{
            getImageFromURL(url: url, id: id)
            print("From Camera Roll")
        }
    }
    
    func getImageFromURL(url: String, id: String){
        let updatedURL = url + "=w60-h60"

        let dataTask = URLSession.shared.dataTask(with: URL(string: updatedURL)!) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    let img = UIImage(data: data)!
                    self?.thumbnail.image = img
                    
                    Cache.shared.setToMemoryCache(id: id, img: img)
                    Cache.shared.setToDiskCache(id: id, img: img)
                }
            }
        }
        dataTask.resume()
    }
}
