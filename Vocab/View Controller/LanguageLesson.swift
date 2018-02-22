//
//  LanguageLesson.swift
//  Vocab
//
//  Created by Prateek Kansara on 21/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation
import UIKit

class LanguageLessonController: UIViewController {
    
    
    @IBOutlet var lessonCheckImage : UIImageView!
    
    @IBOutlet var languageCard : UIView!
    
    @IBOutlet var sourceLanguageLabel : UILabel!
    @IBOutlet var transLanguageLabel : UILabel!
    
    @IBOutlet var userInputTextField : UITextField!
    
    @IBOutlet var nextButton : UIButton!
    
    public var selectedSrcLanguage : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelectedLanguageLessons()
        LanguageTextUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private var langaugeData : Results<Language>? = nil
    private var languageCounter : Int = 0
    
    private var correct = 0
    private var wrong = 0
    
    
    /// Method to fetch the language object who's counter is less than 4 and check weather all the cards has been completed or not.
    func updateSelectedLanguageLessons(){
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "srclanguageType = %@", selectedSrcLanguage)
        self.langaugeData = realm.objects(Language.self).filter(predicate).filter("count < 4")
        
        let allLanguage = realm.objects(Language.self).filter(predicate)
        
        if allLanguage.count > self.langaugeData!.count{
            if langaugeData?.count == 0{
                // completed
                self.completedLesson()
            }
        }
    }
    
    
    
    func updateCardData() {
        if languageCounter < self.langaugeData!.count{
            LanguageTextUI()
        }
    }
    
    
    /// Method to update the language card UI.
    func LanguageTextUI ()  {
        if langaugeData!.count > 0{
            let languageObject = self.langaugeData![languageCounter]
            
            let attributedText = NSMutableAttributedString()
            
            let srcLanguageTxt = NSAttributedString.init(string: "\(languageObject.srclanguageType):", attributes: nil)
            let srcLanguage = NSAttributedString.init(string: String(format :"\n%@", languageObject.srcLanguage), attributes: nil)
            
            attributedText.append(srcLanguageTxt)
            attributedText.append(srcLanguage)
            
            self.sourceLanguageLabel.attributedText = attributedText
            self.transLanguageLabel.text = languageObject.translanguageType + ":"
        }
    }
    
    
    /// Method to check if the entered translation is correct or not.
    func checkForLanguageTranslation(){
        let languageObject = self.langaugeData![languageCounter]
        
        var count = 0
        if userInputTextField.text?.lowercased() == languageObject.engTranslate.lowercased(){
            count = 1
            updateLessonCheckImage(isSuccess: true)
            correct += 1
            
        }else{
            count = -1
            updateLessonCheckImage(isSuccess: false)
            self.languageCard.shake()
            wrong += 1
        }
        
        let realm = try! Realm()
        try! realm.write {
            languageObject.count += count
            if languageObject.count < 0{
                languageObject.count = 0
            }
            realm.add(languageObject, update: true)
        }
    }
    
    /// Method to update the image according to correct and wrong translation
    ///
    /// - Parameter isSuccess: Bool to check if the translation was success or not.
    func updateLessonCheckImage(isSuccess : Bool?) {
        
        if isSuccess == nil{
            self.lessonCheckImage.image = nil
            return
        }
        
        if isSuccess!{
            self.lessonCheckImage.image = UIImage(named: "Correct")
        }else{
            self.lessonCheckImage.image = UIImage(named: "Wrong")
        }
        
    }
    
    
    /// Method called when a lesson is successfully finished by the user
    func completedLesson() {
        
        self.userInputTextField.isHidden = true
        self.sourceLanguageLabel.text = VocabMessages.lessonCompleteCongrats
        self.transLanguageLabel.text = VocabMessages.lessonCompleteMessage
        
        self.nextButton.setTitle(userButtonSelection.Again.rawValue, for: .normal)
    }
    
    
    /// Method called when user selects to play the lesson again
    func resetLanguageCounter() {
        self.userInputTextField.isHidden = false
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "srclanguageType = %@", selectedSrcLanguage)
        let lLangaugeData = realm.objects(Language.self).filter(predicate)
        
        try! realm.write {
            for language in lLangaugeData{
                language.count = 0
                realm.add(language, update: true)
            }
        }
    }
    
    
    /// Method called when a lesson is ended
    func lessonEnded() {
        
        self.sourceLanguageLabel.text = VocabMessages.lessonEndMessage
        self.transLanguageLabel.text = "Correct : \(correct) \n Wrong : \(wrong)"
        self.userInputTextField.isHidden = true
        
    }
    
    @IBAction func nextButtonPressed (sender : UIButton) {
        
        if sender.currentTitle == userButtonSelection.Continue.rawValue{
            userInputTextField.isUserInteractionEnabled = false
            checkForLanguageTranslation()
            sender.setTitle(userButtonSelection.Next.rawValue, for: .normal)
            
        }else if  sender.currentTitle == userButtonSelection.Next.rawValue{
            
            userInputTextField.isUserInteractionEnabled = true
            userInputTextField.text = ""
            languageCounter += 1
            
            if languageCounter >= self.langaugeData!.count{
                // end the lesson
                sender.setTitle(userButtonSelection.Again.rawValue, for: .normal)
                lessonEnded()
                return
            }
            
            updateCardData()
            sender.setTitle(userButtonSelection.Continue.rawValue, for: .normal)
            updateLessonCheckImage(isSuccess: nil)
            
            self.languageCard.drop()
        }else{
            languageCounter = 0
            self.userInputTextField.isHidden = false
        }
        updateSelectedLanguageLessons()
    }
}

enum userButtonSelection : String{
    case Next = "NEXT"
    case Continue = "Continue"
    case Again = "Restart"
}

extension LanguageLessonController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        print(textField.text! + string as Any)
        return true
    }
    
}
