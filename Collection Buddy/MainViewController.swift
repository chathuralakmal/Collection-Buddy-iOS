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
    
    var coinSound:AVAudioPlayer?
 
    var ref: FIRDatabaseReference!
    var user: FIRUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCoin.layer.cornerRadius = 20;
        btnCoin.clipsToBounds = true;
        
        user = (FIRAuth.auth()?.currentUser)!;
        print(user.displayName ?? "No User");
        
        
        ref = FIRDatabase.database().reference()
        
//        ref.child("collection").childBy(byChild: user.uid).observe(.childAdded, with: { (snapshot) in
//            print(snapshot.value(forKey: "value") ?? "Not Sure")
//        })
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressCoinBtn(_ sender: Any) {
        var myValue : String = ""
        
        ref.child("collection").child(user.uid).child("value").observe(.value, with: { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                print(snapshot.value ?? "Not Sure")
                myValue = snapshot.value as! String
                let newValue:Int = Int(myValue)!+10 ;
                self.addCoin(newValue: newValue)
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
    }
    
}
