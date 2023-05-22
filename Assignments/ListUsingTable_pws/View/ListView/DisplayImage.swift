//
//  displayImage.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 28/02/23.
//

import UIKit

class DisplayImage: UIViewController {
    
    @IBOutlet weak var showImg: UIImageView!
    
    func setImage(url: String, id: String, height: String, width: String){
        let updatedURL = url + "=w" + width + "-h" + height

        let dataTask = URLSession.shared.dataTask(with: URL(string: updatedURL)!) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    let img = UIImage(data: data)!
                    self?.showImg.image = img
                    
                    Cache.shared.setToMemoryCache(id: id, img: img)
                    Cache.shared.setToDiskCache(id: id, img: img)
                }
            }
        }
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
    

   

