//
//  ViewController.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 20/02/23.
//
import Foundation
import UIKit
import AVKit
import Photos

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!

    func numberOfSections(in tableView: UITableView) -> Int {
        return FetchFromGoogleAPI.shared.monthMediaList.count
    }
    
    //MARK: number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = FetchFromGoogleAPI.shared.months[section]
        return FetchFromGoogleAPI.shared.monthMediaList[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomViewCell {
            let month = FetchFromGoogleAPI.shared.months[indexPath.section]
            let media = FetchFromGoogleAPI.shared.monthMediaList[month]![indexPath.row]
            
            cell.configureData([media.filename, media.size, media.creationDate])
            cell.configureGooglePhoto(url: media.url, id: media.id)
            cell.favouriteButton.accessibilityLabel = media.id
            cell.setFavourite()
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FetchFromGoogleAPI.shared.months[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

    override func viewWillAppear(_ animated: Bool) {
        //tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: share and delete swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            self?.deletePopUp()
            completionHandler(true)
        }
        actionDelete.image = UIImage(named: "ic_delete")
        
        actionDelete.backgroundColor = .red
     
        let month = FetchFromGoogleAPI.shared.months[indexPath.section]
        let media = FetchFromGoogleAPI.shared.monthMediaList[month]![indexPath.row]
        
        let data = FetchFromGoogleAPI.shared.getMedia(url: media.url, width: media.width, height: media.height, mediaType: media.type)
        
        let actionShare = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            self?.onClickShare(data: data)
            completionHandler(true)
        }
        actionShare.image = UIImage(named: "ic_share")
        
        actionShare.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [actionDelete, actionShare])
    }
    
    func deletePopUp(){
        print("Delete PopUp appears")
        
        let dialogMessage = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("ok button tapped")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
                
        dialogMessage.addAction(cancelAction)
        dialogMessage.addAction(okAction)
      
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    func onClickShare(data: Data){
       
        let dataShare = [ data ]
        let activityViewController = UIActivityViewController(activityItems: dataShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: filter button
    var filterMenuItems: [UIAction] {
        return [
            UIAction(title:"All", handler: { (_) in
                print("All selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "all")
                FetchFromGoogleAPI.shared.filterFlag = "all"
                self.tableView.reloadData()
            }),
            UIAction(title:"Photos", handler: { (_) in
                print("Photos selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "photos")
                FetchFromGoogleAPI.shared.filterFlag = "photos"
                self.tableView.reloadData()
            }),
            UIAction(title:"Videos", handler: { (_) in
                print("Videos selected")
                FetchFromGoogleAPI.shared.filterItems(filterType: "videos")
                FetchFromGoogleAPI.shared.filterFlag = "videos"
                self.tableView.reloadData()
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
    
    //MARK: sort button
    var sortMenuItems: [UIAction] {
        return [
            UIAction(title:"Name A-Z", handler: { (_) in
                print("Sorting names in asc selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "nameAsc")
                FetchFromGoogleAPI.shared.sortFlag = "nameAsc"
                self.tableView.reloadData()
            }),
            UIAction(title:"Name Z-A", handler: { (_) in
                print("Sorting names in desc selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "nameDesc")
                FetchFromGoogleAPI.shared.sortFlag = "nameDesc"
                self.tableView.reloadData()
            }),
            UIAction(title:"Date", handler: { (_) in
                print("Sorting Date selected")
                FetchFromGoogleAPI.shared.sortItems(sortType: "Date")
                FetchFromGoogleAPI.shared.sortFlag = "Date"
                self.tableView.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.showsVerticalScrollIndicator = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        FetchFromGoogleAPI.shared.groupMonth()
        configureFilterButton()
        configureSortButton()
    }
}



