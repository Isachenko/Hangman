//
//  HistoryViewController.swift
//  Hangman
//
//  Created by Andrey Isachenko on 04/04/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    @IBOutlet weak var aiScoreLabel: UILabel!
    var playerName = UserDefaults.standard.value(forKey: "playername") as! String
    var playerScore = UserDefaults.standard.integer(forKey: "playerscore")
    var aiScore = UserDefaults.standard.integer(forKey: "aiscore")

    override func viewDidLoad() {
        super.viewDidLoad()
        playerNameLabel.text = playerName + " score"
        playerScoreLabel.text = String(playerScore * 100)
        aiScoreLabel.text = String(aiScore * 100)
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
