//
//  StrongPasswordGenerator.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/27.
//

import KakaFoundation
import SwiftCSV
import HandyJSON
import AppGroupKit
import KakaUIKit

class StrongPasswordGenerator {
    private let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    private let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let arabicNumbers = "0123456789"
    private let specialCharacters = "#?!@$%+&*-"

    var englishWords: [String] = []
    
    
    init() {
        let filePath = Reasource.mediaUrl("english.csv")
        let csvURL = NSURL(fileURLWithPath: filePath) as URL
        
        do{
            let csv = try CSV<Named>(url: csvURL, encoding: .utf8, loadColumns: true)
        
            let modelArray = [EnlishCsvModel].deserialize(from: csv.rows)
            
            self.englishWords = modelArray?.compactMap({ $0?.english }) ?? []

        }catch{
            
        }
        
    }
    
}

extension StrongPasswordGenerator {
    func generatePassword(length: Int, includeNumbers: Bool, includeSpecialChars: Bool) -> NSAttributedString {
        guard length >= 10 && length <= 100 else {
            return NSAttributedString(string: "Abcd9527#@&")
        }
        
        var availableCharacters = lowercaseLetters + uppercaseLetters
        
        if includeNumbers {
            availableCharacters += arabicNumbers
        }
        
        if includeSpecialChars {
            availableCharacters += specialCharacters
        }
        
        var password = ""
        
        password += String(uppercaseLetters.randomElement()!)
        password += String(lowercaseLetters.randomElement()!)
        
        if includeNumbers {
            password += String(arabicNumbers.randomElement()!)
        }
        
        if includeSpecialChars {
            password += String(specialCharacters.randomElement()!)
        }
        
        let remainingLength = length - password.count
        for _ in 0..<remainingLength {
            let randomIndex = availableCharacters.index(availableCharacters.startIndex, offsetBy: Int.random(in: 0..<availableCharacters.count))
            let randomCharacter = availableCharacters[randomIndex]
            password += String(randomCharacter)
        }
        
        password = String(password.shuffled())
        
        let attributedString = NSMutableAttributedString(string: password)
        
        if includeNumbers || includeSpecialChars {
            for (index, character) in password.enumerated() {
                if includeNumbers && arabicNumbers.contains(character) {
                    let range = NSRange(location: index, length: 1)
                    attributedString.addAttribute(.font, value: UIFontBold(18.ckValue()), range: range)
                    attributedString.addAttribute(.foregroundColor, value: appMainColor, range: range)
                } else if includeSpecialChars && specialCharacters.contains(character) {
                    let range = NSRange(location: index, length: 1)
                    attributedString.addAttribute(.font, value: UIFontBold(18.ckValue()), range: range)
                    attributedString.addAttribute(.foregroundColor, value: appMainColor, range: range)
                } else {
                    let range = NSRange(location: index, length: 1)
                    attributedString.addAttribute(.font, value: UIFontLight(18.ckValue()), range: range)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: range)
                }
            }
        }
        
        return attributedString
    }
}

extension StrongPasswordGenerator {
    func generateMemorablePasswordWithWords(length: Int, includeNumbers: Bool, includeSpecialChars: Bool) -> NSAttributedString {
        guard length >= 10 && length <= 100 else {
            return NSAttributedString(string: "")
        }
        
        let attributedString = NSMutableAttributedString()
        var passwordLength = 0
        
        while passwordLength < length {
            if attributedString.length > 0 {
                let randomSpecialChar = "#&@".randomElement()!
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .foregroundColor: appMainColor
                ]
                attributedString.append(NSAttributedString(string: String(randomSpecialChar), attributes: attributes))
                passwordLength += 1
            }
            
            if passwordLength < length {
                let randomWord = englishWords.randomElement() ?? ""
                let capitalizedWord = randomWord.prefix(1).uppercased() + randomWord.dropFirst()
                attributedString.append(NSAttributedString(string: capitalizedWord))
                passwordLength += capitalizedWord.count
                
                if includeNumbers && passwordLength < length {
                    let randomNumber = Int.random(in: 0...9)
                    attributedString.append(NSAttributedString(string: String(randomNumber)))
                    passwordLength += 1
                }
            }
        }
        
        return attributedString
    }
    
}
