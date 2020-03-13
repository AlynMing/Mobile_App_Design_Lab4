//
//  ViewController.swift
//  Flashcard
//
//  Created by Hanjing Zhu on 2/15/20.
//  Copyright © 2020 Hanjing Zhu. All rights reserved.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
}
class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    // Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Read saved flashcards
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question:"What's the captial of Brazil", answer: "Brasilia")
        } else{
            updateLabels()
            updateNextPrevButtons()
        }
    }

    
    
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        // Logging to the console
        print("😎 Added new flashcard")
        print("😎 We now have \(flashcards.count) flashcards")
        
        // Update current index
       currentIndex = flashcards.count - 1
        print("😎 Our current index is \(currentIndex)")
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        // Call save flashcards function
        saveAllFlashcardsToDisk()
        
    }
    
    func updateNextPrevButtons(){
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            self.nextButton.isEnabled = false
        } else{
            self.nextButton.isEnabled = true
        }
        // Disable prev button if at the beginning
        if currentIndex == 0{
            self.prevButton.isEnabled = false
        } else{
            self.prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    

    @IBAction func didTapOnPrev(_ sender: Any) {
        // Decrease current index
        currentIndex = currentIndex - 1
        // Update labels
        updateLabels()
        // Update buttons
        updateNextPrevButtons()
    }
    
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current index
        currentIndex = currentIndex + 1
        // Update labels
        updateLabels()
        // Update buttons
        updateNextPrevButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map{ (card) -> [String: String] in
            return ["question":card.question, "answer": card.answer]
        }
         UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("🎉 Flashcards saved to UserDefaults")
}

    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as?[[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
        
    }
    

}
