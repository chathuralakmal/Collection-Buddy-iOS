//
//  ViewController.swift
//  Collection Buddy
//
//  Created by Chathura Lakmal on 2/16/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! MainViewController
        self.present(newViewController, animated: true, completion: nil)
    }

}

