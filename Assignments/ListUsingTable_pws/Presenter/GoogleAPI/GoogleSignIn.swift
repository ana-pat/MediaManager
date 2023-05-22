//
//  GoogleSignIn.swift
//  ListUsingTable_pws
//
//  Created by Ananya Pathak on 07/03/23.
//

import Foundation
import UIKit
import GoogleSignIn


var count = 0

class GoogleSignIn: UIViewController{

    @IBOutlet weak var GoogleSignIn: GIDSignInButton!
    @IBOutlet weak var GoogleSignOut: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var viewMedia: UIButton!
    
    let fetchData = FetchData()
   
    @IBAction func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: nil, additionalScopes:["https://www.googleapis.com/auth/photoslibrary.readonly"]) { signInResult, error in

            if error == nil{
                print("\n\nSigned In\n\n")
                self.updateView()
            }else{
                return
            }
        }
    }
   
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        FetchFromGoogleAPI.shared.flush()
       // Favourite.shared.flushFavs()
        self.updateView()
        print("\nnSigned out\n\n")
    }
    
    @IBAction func viewMedia(_ sender: Any) {
        
        print("View media button clicked")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.navigationController?.pushViewController(vc!, animated: true)
        count += 1
        if count > 1{
            FetchFromGoogleAPI.shared.flush()
        }
    }
    
    func updateView(){
        if let user = GIDSignIn.sharedInstance.currentUser{
            displayLabel.text = "\(user.profile!.name) is Signed In"
            getPhoto(user)
            GoogleSignIn.isHidden = true
            GoogleSignOut.isHidden = false
            viewMedia.isHidden = false
        }else{
            displayLabel.text = "Please Sign In"
            
            GoogleSignIn.isHidden = false
            GoogleSignOut.isHidden = true
            viewMedia.isHidden = true
        }
    }
  
    func getPhoto(_ user: GIDGoogleUser){
        user.refreshTokensIfNeeded{ user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            self.fetchData.getPhotos(user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.numberOfLines = 0
        displayLabel.textAlignment = .center
        updateView()
    }
    
}
