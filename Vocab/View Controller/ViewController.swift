//
//  ViewController.swift
//  Vocab
//
//  Created by Prateek Kansara on 20/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var languageScrollView : UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        VocabDirectoryManager.shared.copyBundleToDocs(fileName: "German")

        languageList()
        
        addLanuageToScroll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var gLanguageURL : [URL]?
    fileprivate var gLanguageName : [String]?
    func languageList() {
        
        let (languageURLs, languageNames) = VocabDirectoryManager.shared.getLanguageList()
        self.gLanguageURL = languageURLs
        self.gLanguageName = languageNames
    }
    
    func addLanuageToScroll() {
        var buttonTag = 0
        for language in self.gLanguageName!{
            
            self.languageScrollView.addSubview(self.languageButton(languageName: language, btutonTag: buttonTag, yHeight: Float((buttonTag * languageButtonSize.Height) + Int(buttonTag*50))))
            buttonTag += 1;
        }   
    }

    func languageButton(languageName : String, btutonTag : Int, yHeight : Float) -> UIButton {
        
        let languageButton = UIButton.init(type: .roundedRect)
        languageButton.addTarget(self, action: #selector(self.languageButtonPressed(sender:)), for: .touchUpInside)
        languageButton.frame = CGRect(x:Int(self.languageScrollView.frame.width/2 - CGFloat(languageButtonSize.Width/2)), y: Int(yHeight), width:languageButtonSize.Width, height:languageButtonSize.Height)
        languageButton.backgroundColor = VocabColors.languageButtonBkgColor
        languageButton.setTitle(languageName, for: .normal)
        languageButton.setTitleColor(.black, for: .normal)
        languageButton.tag = btutonTag
        
        languageButton.layer.cornerRadius = 30
        languageButton.layer.borderWidth = 1
        languageButton.layer.borderColor = UIColor.black.cgColor
        
        return languageButton
    }
    
    private var selectedLanguage : String!
    func languageButtonPressed(sender : UIButton) {
        
        VocabDirectoryManager.shared.readFromFile(filename: sender.currentTitle!)
        selectedLanguage = sender.currentTitle
        performSegue(withIdentifier: storyboadSegue.languageLesson, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let languageView = segue.destination as! LanguageLessonController
        languageView.selectedSrcLanguage = selectedLanguage
    }
}

