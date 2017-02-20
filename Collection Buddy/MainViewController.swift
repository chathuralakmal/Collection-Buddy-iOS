//
//  MainViewController.swift
//  Collection Buddy
//
//  Created by Chathura Lakmal on 2/16/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Firebase
import FirebaseDatabase


class MainViewController: UIViewController {

    @IBOutlet var btnCoin: UIButton!
    @IBOutlet var myValue: UILabel!
    @IBOutlet var totalValue: UILabel!
    @IBOutlet var userName: UILabel!
    
    var coinSound:AVAudioPlayer?
 
    var ref: FIRDatabaseReference!
    var user: FIRUser!
    var valueUpdated : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCoin.layer.cornerRadius = 20;
        btnCoin.clipsToBounds = true;
        
        user = (FIRAuth.auth()?.currentUser)!;
        
        ref = FIRDatabase.database().reference()
        
        self.loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressCoinBtn(_ sender: Any) {
        var myValue : String = "0"
        valueUpdated = false
        ref.child("collection").child(user.uid).child("value").observe(.value, with: { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("Initial Value Not Found")
                if(!self.valueUpdated){
                    self.addCoin(newValue: 10)
                    self.valueUpdated = true;
                }
            } else {
                print(snapshot.value ?? "Not Sure")
                myValue = snapshot.value as! String
                let newValue:Int = Int(myValue)!+10;
                if(!self.valueUpdated){
                    self.addCoin(newValue: newValue)
                    self.valueUpdated = true;
                }
            }
        })
        self.playSound()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func playSound() {
        let url = Bundle.main.url(forResource: "Cha-ching-sound", withExtension: "mp3")!
        
        do {
            coinSound = try AVAudioPlayer(contentsOf: url)
            guard let player = coinSound else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func addCoin(newValue : Int){
        let insertItem : [String : String] = ["name" : user.email!,
                                                 "value" : String(newValue)]
        ref.child("collection").child(user.uid).setValue(insertItem)
        self.loadData()
    }
    
    
    func loadData(){
        self.userName.text = "User : \(user.email!)";
        
        /** Caluclating My Contribution **/
        ref.child("collection").child(user.uid).observe(.childAdded, with: { (snapshot) in
            self.myValue.text = "My Contribution : \(snapshot.value(forKey: "value") ?? "0")/="
        })
        
        /** Calculating Total Contribution **/
        var totalValue : Int = 0
        ref.child("collection").observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! FIRDataSnapshot
                let userDict = userSnap.value as! [String:AnyObject] //child data
                let sValue = userDict["value"] as! String
                totalValue = totalValue+Int(sValue)!
            }
            self.totalValue.text = "Total : \(totalValue)/="
        })
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        UserDefaults.standard.set(nil, forKey: "userEmail")
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginView") as! ViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
}
