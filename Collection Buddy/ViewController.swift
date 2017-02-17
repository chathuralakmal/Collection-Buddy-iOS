//
//  ViewController.swift
//  Collection Buddy
//
//  Created by Chathura Lakmal on 2/16/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ViewController: UIViewController {
    
    var registeredUser:Bool = false

    @IBOutlet var btnLoginRegister: UIButton!
    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //registeredUser = UserDefaults.standard.bool(forKey: "registeredUser")
        registeredUser = true
        
        if(registeredUser){
            self.btnLoginRegister.setTitle("Login", for: UIControlState.normal)
        }else{
            self.btnLoginRegister.setTitle("Register", for: UIControlState.normal)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        HUD.show(.progress)
        if(registeredUser){
            FIRAuth.auth()?.signIn(withEmail: emailAddress.text!, password: password.text!, completion: { (user, error) in
                if(error == nil){
                    HUD.flash(.progress, delay: 1.0)
                    UserDefaults.standard.set(user?.email, forKey: "userEmail")
                    print("Login Success");
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! MainViewController
                            self.present(newViewController, animated: true, completion: nil)
                }else{
                    HUD.flash(.error, delay: 1.0)
                    print("Login Error");
                }
            })
        }else{
            FIRAuth.auth()?.createUser(withEmail: emailAddress.text!, password: password.text!, completion: { (user, error) in
                
                if((error) != nil){
                    HUD.flash(.error, delay: 1.0)
                    print(error.debugDescription);
                    print("Registration Error");
                }else{
                    HUD.flash(.success, delay: 1.0)
                    print(user!.email!);
                    UserDefaults.standard.set(true, forKey: "registeredUser")
                    self.btnLoginRegister.setTitle("Login", for: UIControlState.normal)
                    self.registeredUser = true;
                    self.emailAddress.text = "";
                    self.password.text = "";
                }
            })
            
          
        }
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! MainViewController
//        self.present(newViewController, animated: true, completion: nil)
        
        
        
    }
}

