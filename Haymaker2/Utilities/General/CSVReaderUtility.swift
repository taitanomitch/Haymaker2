//
//  CSVReaderUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

class CSVReader {
    
    var AttackCollectionArray: [[String]] = [[]]
    var CardCollectionArray: [[String]] = [[]]
    var WeaponCollectionArray: [[String]] = [[]]
    
    func readCSV(inputFile: String) ->[String] {
        let fileURL = Bundle.main.url(forResource: inputFile, withExtension: "csv")
        do {
            let savedData = try String(contentsOf: fileURL!)
            return savedData.components(separatedBy: ";")
        } catch {
            return ["File \(inputFile) wasn't found"]
        }
    }
    
    func readAttackCollectionCSV() {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.AttackCSVColumnCount
        AttackCollectionArray = readCollectionCSV(CSVName: "AttackCollection", NumberOfColumns: numberOfColumns)
    }
    
    func readCardCollectionCSV() {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.CardCSVColumnCount
        CardCollectionArray = readCollectionCSV(CSVName: "CardCollection", NumberOfColumns: numberOfColumns)
    }
    
    func readWeaponCollectionCSV() {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.WeaponCSVColumnCount
        WeaponCollectionArray = readCollectionCSV(CSVName: "WeaponsCollection", NumberOfColumns: numberOfColumns)
    }
    
    func readCollectionCSV(CSVName: String, NumberOfColumns: Int) -> [[String]] {
        let numberOfColumns = NumberOfColumns
        let fileURL = Bundle.main.url(forResource: CSVName, withExtension: "csv")
        do {
            let savedData = try String(contentsOf: fileURL!)
            let entireCSV = savedData.components(separatedBy: CharacterSet(charactersIn: ";\n"))
            var allArray: [[String]] = [[]]
            var nextArray: [String] = []
            var firstEntry = true
            for i in 0..<entireCSV.count {
                nextArray.append(entireCSV[i])
                if nextArray.count == numberOfColumns {
                    if firstEntry {
                        allArray[0] = nextArray
                        firstEntry = false
                    } else {
                        allArray.append(nextArray)
                    }
                    nextArray = []
                }
            }
            return allArray
        } catch {
            return [["\(CSVName) File wasn't found"]]
        }
    }
    
}

extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
}
