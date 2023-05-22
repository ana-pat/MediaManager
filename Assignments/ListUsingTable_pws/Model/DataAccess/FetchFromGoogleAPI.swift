//
//  FetchFromGoogleAPI.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 14/03/23.
//

import Foundation
import UIKit
import GoogleSignIn

class FetchFromGoogleAPI{
    
    static var shared = FetchFromGoogleAPI()
    
    var mediaList : [MediaItem]
    var monthMediaList: [String: [MediaItem]]
    var months: [String]
    
    var sortFlag: String
    var filterFlag: String
    
    private init(){
        mediaList = []
        monthMediaList = [:]
        months = []
        
        sortFlag = "Date"
        filterFlag = "all"
    }
    
    //multiple copies of the photos and videos were made to avoid that we ae using this method
    //MARK: Flush elements in the lists
    func flush(){
        monthMediaList.removeAll()
        months.removeAll()
    }
    
    func getImage(_ url: String) -> UIImage{
       
        let updatedURL = url + "=w160-h160"
        let imageURL = URL(string: updatedURL);
        var image = UIImage()
        
        DispatchQueue.main.async {
            let dataTask = URLSession.shared.dataTask(with: imageURL!) { (data, _, _) in
                if let data = data{
                    image = UIImage(data: data)!
                }
            }
            dataTask.resume()
        }
       return image
    }
    
    func getVideo(url: String, width: String, height: String) -> Data{

        let videoURL = url + "=dv"
        let data = fetchDataFromURL(videoURL)
        
        return data!
    }
    
    func getMedia(url: String, width: String, height: String, mediaType: String) -> Data{
        var mediaURL = ""
        if mediaType == "image/jpeg" || mediaType == "image/png"{
            mediaURL = url + "=w\(width)-h\(height)"
        }else{
            mediaURL = url + "=dv"
        }
        let data = fetchDataFromURL(mediaURL)
        return data!
    }
    func fetchDataFromURL(_ url_string:String) -> Data?{
           var temp_data: Data? = nil
           let url = URL(string: url_string)
           let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
               
               guard let data = data else {
                   print("Data Error !!")
                   return
               }
               temp_data = data
           })
           task.resume()
           while (temp_data == nil){
               // do nothing
           }
           return temp_data
       }
    
    func groupMonth(){
        filterItems(filterType: filterFlag)
    }
    
    func filterItems(filterType: String){
        monthMediaList.removeAll()
        months.removeAll()
        if filterType == "all"{
                    for temp in mediaList {
                        let monthInYear = temp.month
                        if monthMediaList.keys.contains(monthInYear){
                            self.monthMediaList[monthInYear]!.append(temp)
                        }else{
                            self.months.append(monthInYear)
                            self.monthMediaList[monthInYear] = [temp]
                        }
                    }
            sortItems(sortType: sortFlag)
        }else if filterType == "photos"{
            for temp in mediaList {
                let monthInYear = temp.month
                let filter = temp.type
                if filter == "image/jpeg" || filter == "image/png"{
                    if monthMediaList.keys.contains(monthInYear){
                        self.monthMediaList[monthInYear]!.append(temp)
                    }else{
                        self.months.append(monthInYear)
                        self.monthMediaList[monthInYear] = [temp]
                    }
                }
            }
            sortItems(sortType: sortFlag)
        }else if filterType == "videos"{
            for temp in mediaList {
                let monthInYear = temp.month
                let filter = temp.type
                if filter != "image/jpeg" && filter != "image/png"{
                    if monthMediaList.keys.contains(monthInYear){
                        self.monthMediaList[monthInYear]!.append(temp)
                    }else{
                        self.months.append(monthInYear)
                        self.monthMediaList[monthInYear] = [temp]
                    }
                }
            }
            sortItems(sortType: sortFlag)
        }
        
    }
    
    func sortItems(sortType: String){
        
        if sortType == "nameAsc"{
            for key in monthMediaList.keys{
                monthMediaList[key]?.sort(by: sortByNameAsc)
            }
        }else if sortType == "nameDesc"{
            for key in monthMediaList.keys{
                monthMediaList[key]?.sort(by: sortByNameDesc)
            }
        }else{
            for key in monthMediaList.keys{
                monthMediaList[key]?.sort(by: sortByDate)
            }
        }
        
    }

    func sortByNameAsc(lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.filename.lowercased() < rhs.filename.lowercased()
    }
    func sortByNameDesc(lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.filename.lowercased() > rhs.filename.lowercased()
    }
    func sortByDate(lhs: MediaItem, rhs: MediaItem) -> Bool{
        return lhs.creationDate < rhs.creationDate
    }
}
