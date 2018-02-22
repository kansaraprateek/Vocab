//
//  VocabDirectoryManager.swift
//  Vocab
//
//  Created by Prateek Kansara on 21/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation

class VocabDirectoryManager: NSObject {

    static let shared = VocabDirectoryManager()
    
    var selectedLanguage : String = ""
    
    var globalFileManager : FileManager! {
        if !FileManager.default.fileExists(atPath: globalDestinationDocPath as String) {
            do{
                try FileManager.default.createDirectory(atPath: globalDestinationDocPath as String, withIntermediateDirectories: false, attributes: nil)
            }
            catch{
                print("failed to create common doc folder")
            }
        }
        return FileManager.default
    }
    
    var globalPaths : NSArray! {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray!
    }
    
    var globalDocumentDirectoryPath : NSString! {
        return globalPaths.object(at: 0) as! NSString
    }
    
    var globalDestinationDocPath : NSString! {
        return globalDocumentDirectoryPath.appendingPathComponent("/\(DirectoryConstant.documentFileFolder)") as NSString!
    }
    
    func getLanguageList() -> ([URL]?, [String]?){
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: URL(string : globalDestinationDocPath as String)!, includingPropertiesForKeys: nil, options: [])
            
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let csvFiles = directoryContents.filter{ $0.pathExtension == "csv" }
            print("CSV urls:",csvFiles)
            let csvFileNames = csvFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("CSV list:", csvFileNames)
            
            return (csvFiles, csvFileNames)
        } catch {
            print(error.localizedDescription)
        }
        return (nil, nil)
    }
    
    func copyBundleToDocs(fileName : String)
    {
        let bundlePath = Bundle.main.path(forResource: fileName, ofType: "csv")
        print(bundlePath!, "\n") //prints the correct path
        _ = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        
        let fullDestPath = URL(fileURLWithPath: globalDestinationDocPath.appendingPathComponent("\(fileName).csv"))
        let fullDestPathString = fullDestPath.path
        print(fileManager.fileExists(atPath: bundlePath!)) // prints true
        do
        {
            try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
            print("DB Copied")
        }
        catch
        {
            print("\n")
            print(error)
        }
    }
    
    func readFromFile(filename : String) {
        
        let filepath = URL(fileURLWithPath: globalDestinationDocPath.appendingPathComponent("\(filename).csv"))
        do{
            let languageData = try String(contentsOf: filepath, encoding: .utf8)
            CSVFileManager.shared.convertCSV(file: languageData)
        }catch{
            print("Unable to read file")
        }
    }
    
}
