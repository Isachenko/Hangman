//
//  ViewController.swift
//  Hangman
//
//  Created by Andrey Isachenko on 19/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startGameClicked(_ sender: UIButton) {
        //let gameViewController = GameViewController()
        
        //self.present(gameViewController, animated: true, completion: nil)
        print("start game clicked")
    }
    @IBAction func resetModelClicked(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
    }
    
}

