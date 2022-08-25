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
    
    func readAttackCollectionCSV() -> Bool {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.AttackCSVColumnCount
        let fileURL = Bundle.main.url(forResource: "AttackCollection", withExtension: "csv")
        do {
            let savedData = try String(contentsOf: fileURL!)
            let entireCSV = savedData.components(separatedBy: CharacterSet(charactersIn: ";\n"))
            var allAttacksArray: [[String]] = [[]]
            var nextAttackArray: [String] = []
            var firstEntry = true
            for i in 0..<entireCSV.count {
                nextAttackArray.append(entireCSV[i])
                if nextAttackArray.count == numberOfColumns {
                    if firstEntry {
                        allAttacksArray[0] = nextAttackArray
                        firstEntry = false
                    } else {
                        allAttacksArray.append(nextAttackArray)
                    }
                    nextAttackArray = []
                }
            }
            AttackCollectionArray = allAttacksArray
            return true
        } catch {
            AttackCollectionArray = [["AttackCollection File wasn't found"]]
            return false
        }
    }
    
    func readCardCollectionCSV() -> Bool {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.CardCSVColumnCount
        let fileURL = Bundle.main.url(forResource: "CardCollection", withExtension: "csv")
        do {
            let savedData = try String(contentsOf: fileURL!)
            let entireCSV = savedData.components(separatedBy: CharacterSet(charactersIn: ";\n"))
            var allCardsArray: [[String]] = [[]]
            var nextCardArray: [String] = []
            var firstEntry = true
            for i in 0..<entireCSV.count {
                nextCardArray.append(entireCSV[i])
                if nextCardArray.count == numberOfColumns {
                    if firstEntry {
                        allCardsArray[0] = nextCardArray
                        firstEntry = false
                    } else {
                        allCardsArray.append(nextCardArray)
                    }
                    nextCardArray = []
                }
            }
            CardCollectionArray = allCardsArray
            return true
        } catch {
            CardCollectionArray = [["CardCollection File wasn't found"]]
            return false
        }
    }
    
    func readWeaponCollectionCSV() -> Bool {
        let ReaderPositionUtility = CSVReaderPositionsUtility()
        let numberOfColumns = ReaderPositionUtility.WeaponCSVColumnCount
        let fileURL = Bundle.main.url(forResource: "WeaponsCollection", withExtension: "csv")
        do {
            let savedData = try String(contentsOf: fileURL!)
            let entireCSV = savedData.components(separatedBy: CharacterSet(charactersIn: ";\n"))
            var allWeaponsArray: [[String]] = [[]]
            var nextWeaponArray: [String] = []
            var firstEntry = true
            for i in 0..<entireCSV.count {
                nextWeaponArray.append(entireCSV[i])
                if nextWeaponArray.count == numberOfColumns {
                    if firstEntry {
                        allWeaponsArray[0] = nextWeaponArray
                        firstEntry = false
                    } else {
                        allWeaponsArray.append(nextWeaponArray)
                    }
                    nextWeaponArray = []
                }
            }
            WeaponCollectionArray = allWeaponsArray
            return true
        } catch {
            WeaponCollectionArray = [["WeaponsCollection File wasn't found"]]
            return false
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
