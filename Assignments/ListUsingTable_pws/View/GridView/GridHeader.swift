//
//  gridHeader.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 06/03/23.
//

import Foundation
import UIKit

class GridHeader: UICollectionReusableView{
    
    
    @IBOutlet weak var gridTitle: UILabel!
    
    func addTitle(_ str: String){
        gridTitle.text = str
        gridTitle.textColor = .gray
        gridTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
}
