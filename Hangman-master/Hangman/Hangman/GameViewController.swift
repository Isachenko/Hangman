//
//  GameViewController.swift
//  Hangman
//
//  Created by Andrey Isachenko on 24/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, UIPopoverPresentationControllerDelegate, WordPickerViewControllerDelegate, PlayerPanelViewDelegate {
    
    var wordChosen: Bool = false
    var currentGameModel = CurrentGameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        humanPanelView.delegate = self
        aiPanelView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (!wordChosen) {
            chooseWord()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showWordsList() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wordPicker") as? WordPickerViewController {
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
            viewController.setWords(words: ["hello", "my", "friend", "mother", "twitter", "cognition", "gravity", "november", "table", "coloboration"])
        }
    }
    
    func wordChosen(word: String) {
        currentGameModel.reset()
        currentGameModel.setWords(forHuman: "Veryhardword", forAI: word)
        updateViews()
        showNames()
        wordChosen = true
    }
    
    @IBOutlet weak var humanPanelView: PlayerPanelView!
    @IBOutlet weak var aiPanelView: PlayerPanelView!
    func updateWordsViews() {
        humanPanelView.word = currentGameModel.human.wordHiden
        aiPanelView.word = currentGameModel.ai.wordHiden
    }
    func showNames() {
        humanPanelView.name = "Human intelligence"
        aiPanelView.name = "Artificial intelligence"
    }
    
    @IBAction func addClicked(_ sender: AnyObject) {
    }
    
    func letterClicked(letter: Character) {
        currentGameModel.humanTryLetter(letter: letter)
        updateCurGameStateView()
        currentGameModel.aiTryLetter()
        updateViews()
    }
    
    func updateViews() {
        updateWordsViews()
        updateLifeView()
        updateCurGameStateView()
    }
    
    func updateLifeView() {
        humanPanelView.lifeView.max = currentGameModel.human.maxLife
        humanPanelView.lifeView.cur = currentGameModel.human.curlife
        
        aiPanelView.lifeView.max = currentGameModel.ai.maxLife
        aiPanelView.lifeView.cur = currentGameModel.ai.curlife
    }

    @IBOutlet weak var gameStateView: UILabel!
    func updateCurGameStateView() {
        gameStateView.text = currentGameModel.gameState.rawValue
    }
    
    @IBAction func restartClicked(_ sender: UIButton) {
        wordChosen = false
        chooseWord()
    }
    
    func chooseWord() {
        currentGameModel.gameState = .wordChosing
        showWordsList()
    }
}
