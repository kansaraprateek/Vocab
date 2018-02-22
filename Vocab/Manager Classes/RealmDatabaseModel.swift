//
//  RealmDatabaseModel.swift
//  Vocab
//
//  Created by Prateek Kansara on 20/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation

class Language: Object {
    
    dynamic var id : Int = 0
    dynamic var srclanguageType : String = ""
    dynamic var translanguageType : String = ""
    dynamic var srcLanguage : String = ""
    dynamic var engTranslate : String = ""
    dynamic var count : Int = 0
    
    override static func primaryKey() -> String{
        return "id"
    }
}

class DataManager: NSObject{
    
    static let shared = DataManager()
    
    var counter : Int{
        get{
            return UserDefaults.standard.integer(forKey: DefaultKeys.counterKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: DefaultKeys.counterKey)
        }
    }
    
    public func loadDataToRealm(data :[[String:Any]], columns : [String]) {
        
        let srclanguagetype = columns[0]
        let transLanguageType = columns[1]
        let realm = try! Realm()
        
        let LanguageDataToRemove = realm.objects(Language.self).filter(NSPredicate(format: "srclanguageType = %@ AND translanguageType = %@", srclanguagetype, transLanguageType))
        
        try! realm.write {
            realm.delete(LanguageDataToRemove)
        }
        
        for i in 1..<data.count{
            
           
            try! realm.write {
                
                let languageObject = Language()
                languageObject.id = counter
                languageObject.srclanguageType = srclanguagetype
                languageObject.translanguageType = transLanguageType
                let languageDict = data[i]
                languageObject.srcLanguage = languageDict[columns[0]]! as! String
                languageObject.engTranslate = languageDict[columns[1]]! as! String
                if let count = languageDict[columns[2]]! as? Int{
                    languageObject.count = count
                }
                realm.add(languageObject, update: true)
                self.counter += 1
            }
        }

        print(realm.objects(Language.self))
    }
    
    public func UpdateDataFromRealmToFile() {
        
        let realm = try! Realm()
        let languageResults = realm.objects(Language.self)
        
        var languageCSV : String = ""
        
        for language in languageResults{
            languageCSV += language.srcLanguage + ";" + language.engTranslate + ";" + "\(language.count)"
            languageCSV += "\n"
        }
        
        
    }
}
