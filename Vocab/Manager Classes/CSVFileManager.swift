//
//  CSVFileManager.swift
//  Vocab
//
//  Created by Prateek Kansara on 20/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation


class CSVFileManager : NSObject{

    static let shared = CSVFileManager()

    var  data:[[String:String]] = []
    var  columnTitles:[String] = []
    
    func cleanRows(file:String)->String{
        //use a uniform \n for end of lines.
        var cleanFile = file
        
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func getStringFieldsForRow(row:String, delimiter:String)-> [String]{
        return row.components(separatedBy: delimiter)
    }
    
    func convertCSV(file:String){
        let rows = cleanRows(file: file).components(separatedBy: "\n")
        if rows.count > 0 {
            data = []
            columnTitles = getStringFieldsForRow(row : rows.first!,delimiter:";")
            for row in rows{
                let fields = getStringFieldsForRow(row : row,delimiter: ";")
                if fields.count != columnTitles.count {continue}
                var dataRow = [String:String]()
                for (index,field) in fields.enumerated(){
                    dataRow[columnTitles[index]] = field
                }
                data += [dataRow]
            }
            
            DataManager.shared.loadDataToRealm(data: data, columns: columnTitles)
        } else {
            print("No data in file")
        }
    }
    
    func printData(){
        var tableString = ""
        var rowString = ""
        print("data: \(data)")
        for row in data{
            rowString = ""
            for fieldName in columnTitles{
                guard let field = row[fieldName] else{
                    print("field not found: \(fieldName)")
                    continue
                }
                rowString += field + "\t"
            }
            tableString += rowString + "\n"
        }
    }
    
    //MARK: Data reading and writing functions
    func writeDataToFile(file : String, data : String)-> Bool{

        let data = ""
        print(data)

        var fileName = file + ".csv"
        if let filePath = Bundle.main.path(forResource: file, ofType: "csv"){
            fileName = filePath
        } else {
            fileName = Bundle.main.bundlePath + fileName
        }
        

        do{
            try data.write(toFile: fileName, atomically: true, encoding: .utf8)
            return true
        } catch{
            return false
        }
    }
    
    func readDataFromFile(file:String)-> String!{
        
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
            else {
                return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath)
            convertCSV(file: contents)
            return contents
        } catch {
            print ("File Read Error")
            return nil
        }
    }
    
}
