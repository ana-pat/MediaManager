//
//  GridViewController.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 28/02/23.
//

import UIKit
import AVKit
import Foundation
import Photos

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    //MARK: FilterButton
    var filterMenuItems: [UIAction] {
        return [
            UIAction(title:"All", handler: { (_) in
                print("All selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "all")
                FetchFromGoogleAPI.shared.filterFlag = "all"
                self.collectionView.reloadData()
            }),
            UIAction(title:"Photos", handler: { (_) in
                print("Photos selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "photos")
                FetchFromGoogleAPI.shared.filterFlag = "photos"
                self.collectionView.reloadData()
            }),
            UIAction(title:"Videos", handler: { (_) in
                print("Videos selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "videos")
                FetchFromGoogleAPI.shared.filterFlag = "videos"
                self.collectionView.reloadData()
            })
        ]
    }
    
    var filterMenu: UIMenu{
        return UIMenu(title: "Filter", image: nil, identifier: nil, options: .displayInline, children: filterMenuItems)
    }
    
    func configureFilterButton(){
        filterButton.menu = filterMenu
        filterButton.showsMenuAsPrimaryAction = true
    }
    
    //MARK: SortButton
    var sortMenuItems: [UIAction] {
        return [
            UIAction(title:"Name A-Z", handler: { (_) in
                print("Sorting names in asc selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "nameAsc")
                FetchFromGoogleAPI.shared.sortFlag = "nameAsc"
                self.collectionView.reloadData()
            }),
            UIAction(title:"Name Z-A", handler: { (_) in
                print("Sorting names in desc selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "nameDesc")
                FetchFromGoogleAPI.shared.sortFlag = "nameDesc"
                self.collectionView.reloadData()
            }),
            UIAction(title:"Date", handler: { (_) in
                print("Sorting Date selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "Date")
                FetchFromGoogleAPI.shared.sortFlag = "Date"
                self.collectionView.reloadData()
            })
        ]
    }
    var sortMenu: UIMenu{
        return UIMenu(title: "Sort", image: nil, identifier: nil, options: .displayInline, children: sortMenuItems)
    }
    
    func configureSortButton(){
        sortButton.menu = sortMenu
        sortButton.showsMenuAsPrimaryAction = true
    }
    
    //MARK: Number Of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FetchFromGoogleAPI.shared.monthMediaList.count
    }
    
    //MARK: Number Of Items in each Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = FetchFromGoogleAPI.shared.months[section]
        return FetchFromGoogleAPI.shared.monthMediaList[key]?.count ?? 0
    }
    
    //MARK: Presenting Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridID", for: indexPath) as! DisplayGrid
        
        let month = FetchFromGoogleAPI.shared.months[indexPath.section]
        let media = FetchFromGoogleAPI.shared.monthMediaList[month]![indexPath.row]
        cell.configureGooglePhoto(url: media.url, id: media.id)
            
        return cell
    }

    //MARK: Display Media
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let month = FetchFromGoogleAPI.shared.months[indexPath.section]
        let media = FetchFromGoogleAPI.shared.monthMediaList[month]![indexPath.row]
        
        if media.type == "image/jpeg" || media.type == "image/png"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "displayImage") as? DisplayImage
            vc?.setImage(url: media.url, id: media.id, height: media.height, width: media.width)
            navigationController?.pushViewController(vc!, animated: true)
        }else{
            let data = FetchFromGoogleAPI.shared.getVideo(url: media.url, width: media.width, height: media.height)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destURL = documentsURL!.appendingPathComponent("\(media.id).mov")
            
            try? data.write(to: destURL)
            
            let player = AVPlayer(url: destURL)
            let playervc = AVPlayerViewController()
            playervc.player = player
            self.present(playervc, animated: true) {
                playervc.player!.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width)/4
        return CGSize(width: size, height: size)
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gridHeaderID", for: indexPath) as? GridHeader{
            sectionHeader.gridTitle.text = FetchFromGoogleAPI.shared.months[indexPath.section]

            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureSortButton()
        configureFilterButton()
    }
}

