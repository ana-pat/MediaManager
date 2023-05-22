//
//  Favourite.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 15/03/23.
//

import Foundation
import UIKit
import Photos
import CoreData
import GoogleSignIn

class Favourite{
    
    private init(){
        
    }
    
    static var shared = Favourite()
    
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
       
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        
        return container
    }()
    
    func checkInFav(id: String) -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        let context = persistantContainer.viewContext
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                let dataID = data.value(forKey: "imageID") as! String
                if dataID == id{
                    return true
                }
            }
        }catch{
            print("Operation Failed")
        }
        return false
    }
    
    
    func addToFavourite(id: String){
        let context = persistantContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourites", in: context)
        let newObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newObject.setValue(id, forKey: "imageID")
        do {
          try context.save()
         } catch {
          print("Error saving")
        }
    }
    
    func removeFavourite(id: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        let context = persistantContainer.viewContext
        do{
            let result = try context.fetch(request)
            for data in result{
                context.delete(data as! NSManagedObject)
                print("Removed from favs")
            }
        }catch{
            print("Operation Failed")
        }
    }
    
    func flushFavs(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        let context = persistantContainer.viewContext
        do{
            let result = try context.fetch(request)
            for object in result{
                context.delete(object as! NSManagedObject)
            }
        }catch{
            print("Error")
        }
        // Save the deletions to the persistent store
        do {
          try context.save()
         } catch {
          print("Error saving")
        }
        
    }
    
    
}

