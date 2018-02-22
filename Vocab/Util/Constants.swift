//
//  Constants.swift
//  Vocab
//
//  Created by Prateek Kansara on 20/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation

struct DefaultKeys {
    static let counterKey = "Counter"
}

class DirectoryConstant {
    static let documentFileFolder = "Languages"
}

class VocabColors {
    static let languageButtonBkgColor = UIColor.init(red: 121/255.0, green: 199.0/255.0, blue: 216/255.0, alpha: 1.0)
}

struct languageButtonSize {
    static let Width = 200
    static let Height = 60
    static let difference = 20
}

class storyboadSegue {
    static let languageLesson = "languageLesson"
}

class VocabMessages {
    static let lessonCompleteCongrats = "Congratulations!!"
    static let lessonCompleteMessage = "You have completed the lesson."
    static let lessonEndMessage = "You successfully finished the lesson"
}
