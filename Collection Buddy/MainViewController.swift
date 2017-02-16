//
//  MainViewController.swift
//  Collection Buddy
//
//  Created by Chathura Lakmal on 2/16/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    @IBOutlet var btnCoin: UIButton!
    
    var coinSound:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCoin.layer.cornerRadius = 20;
        btnCoin.clipsToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressCoinBtn(_ sender: Any) {
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

}
