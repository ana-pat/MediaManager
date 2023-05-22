//
//  FetchData.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 09/03/23.
//

import Foundation
import UIKit
import GoogleSignIn

struct MediaItem: Equatable{
    
    static func ==(lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String = ""
    var url: String = ""
    var size: String = ""
    var width: String = ""
    var height: String = ""
    var filename: String = ""
    var creationDate: String = ""
    var month: String = ""
    var type: String = ""
}

class FetchData{

    var mediaList: [MediaItem] = []
    var group = DispatchGroup()
    
    func dateFormatter(_ strDate: String, _ format: String) -> String{
        let dateFormatter = DateFormatter()
                
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: strDate)
                
        dateFormatter.dateFormat = format
        let desiredDate = dateFormatter.string(from: date!)
        return desiredDate
    }
   
    func getPhotos(_ user: GIDGoogleUser){
        let url: String = "https://photoslibrary.googleapis.com/v1/mediaItems"
        self.group.enter()
        self.getMediaList(user: user, url: url, nextPageToken: "")
        self.group.wait()
    }
    
    func getMediaList(user: GIDGoogleUser, url: String, nextPageToken: String){
        
        let accessToken = user.accessToken.tokenString
        let requiredURL = url + "?pageToken" + nextPageToken + "&pageSize=100"
        var request = URLRequest(url: URL(string: requiredURL)!)
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ [self]
            data, response, error in
            
            if let json = try? JSONSerialization.jsonObject(with: data!) as? [String : Any] {
                        
                let mediaItem : [Any] = json["mediaItems"] as! [Any]
                           
                for item in mediaItem{
                                
                    let  mediaObj : [String: Any] = item as! [String : Any]  //Media Dictionary
                                
                    let metadata = mediaObj["mediaMetadata"] as! [String : Any] //MetaData Dictionary which is a part of the Media Dictionary
                    //creating a MediaItem to populate it with the details
                    var media : MediaItem = MediaItem()
                    media.id = mediaObj["id"] as! String
                    media.url = mediaObj["baseUrl"] as! String
                    media.filename = mediaObj["filename"] as! String
                    media.type = mediaObj["mimeType"] as! String
                    media.width = metadata["width"] as! String
                    media.height = metadata["height"] as! String
                    media.creationDate = self.dateFormatter(metadata["creationTime"] as! String, "dd/MM/YYYY")
                    media.month = self.dateFormatter(metadata["creationTime"] as! String, "MMMM yyyy")
            
                    if mediaList.contains(media){
                        continue
                    }else{
                        mediaList.append(media)
                    }
                }
                if let nextToken = json["nextPageToken"] {
                    self.getMediaList(user: user, url: url, nextPageToken: nextToken as! String)
                }else{
                    FetchFromGoogleAPI.shared.mediaList = self.mediaList
                    self.group.leave()
                }
            }else{
                    print("Can't Fetch data medaList url")
            }
        }
        task.resume()
    }
 
}
