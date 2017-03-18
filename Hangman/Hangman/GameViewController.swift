//
//  GameViewController.swift
//  Hangman
//
//  Created by Andrey Isachenko on 24/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, UIPopoverPresentationControllerDelegate, WordPickerViewControllerDelegate, PlayerPanelViewDelegate {
    
    @IBOutlet var optionItemView: UIView!
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
   
    var wordChosen: Bool = false
    var currentGameModel = CurrentGameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addItemView.layer.cornerRadius = 5
        optionItemView.layer.cornerRadius =  5
        
        visualEffectView.isUserInteractionEnabled=false
        // Do any additional setup after loading the view, typically from a nib.
        humanPanelView.delegate = self
        aiPanelView.delegate = self
        
       // popupAnimationIn()
        
        
        
    }
    
    @IBAction func openMenu(_ sender: Any) {
        self.view.addSubview(optionItemView)
        optionItemView.center = self.view.center
        
        optionItemView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        optionItemView.alpha=0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.optionItemView.alpha = 1
            self.optionItemView.transform = CGAffineTransform.identity
        }
        
        self.visualEffectView.isUserInteractionEnabled = true
        
    }
    func popupAnimationIn(){
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
        
        self.visualEffectView.isUserInteractionEnabled = true
     
        
    }
    
    func closeMenuView()
    {
        UIView.animate(withDuration: 0.3, animations:{
            self.optionItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.optionItemView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            self.optionItemView.removeFromSuperview()
            
        }
        self.visualEffectView.isUserInteractionEnabled = false
    }
    
    func popupAnimationOut(){
        UIView.animate(withDuration: 0.3, animations:{
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            self.addItemView.removeFromSuperview()
            
        }
         self.visualEffectView.isUserInteractionEnabled = false
        
    }
    
    @IBAction func closePopup(_ sender: Any) {
        popupAnimationOut()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if (!wordChosen) {
            chooseWord()
        }
    }
    
   
    @IBAction func test(_ sender: Any) {
        popupAnimationIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonClicked(_ sender: Any) {
       closeMenuView()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showWordsList() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wordPicker") as? WordPickerViewController {
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
            viewController.setWords(words: currentGameModel.getRandomWords(number: 20))
        }
    }
    
    func wordChosen(word: String) {
        currentGameModel.reset()
        let wordForHuman = currentGameModel.getRandomWords(number: 1)[0]
        currentGameModel.setWords(forHuman: wordForHuman, forAI: word)
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
        // player make move
        let humanTryResult = currentGameModel.humanTryLetter(letter: letter)
        if (humanTryResult != .error) {
            if (humanTryResult == .rightLetter) {
                humanPanelView.hightlightLetter(letter: letter, good: true)
            } else {
                humanPanelView.hightlightLetter(letter: letter, good: false)
            }
        }
        updateCurGameStateView()
        updateViews()
        
        // ai make move
        if (currentGameModel.isGameEnd()) {
            currentGameModel.resetAiforNewTurn()
        } else {
            let aiTryTuple = currentGameModel.aiTryLetter()
            if (aiTryTuple.1 != .error) {
                if (aiTryTuple.1 == .rightLetter) {
                    aiPanelView.hightlightLetter(letter: aiTryTuple.0, good: true)
                } else {
                    aiPanelView.hightlightLetter(letter: aiTryTuple.0, good: false)
                }
            }
            
        }
        if (currentGameModel.isGameEnd()) {
            currentGameModel.resetAiforNewTurn()
        }
        
        
        updateCurGameStateView()
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
        closeMenuView()
        chooseWord()
    }
    
    func chooseWord() {
        currentGameModel.gameState = .wordChosing
        aiPanelView.resetHightlights()
        humanPanelView.resetHightlights()
        showWordsList()
    }
}
