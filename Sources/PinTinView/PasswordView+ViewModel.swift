//
//  PasswordView+ViewModel.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 19.07.2021.
//

import Foundation

protocol PasswordCheckable {
    var allowedCharacters: CharacterSet { get }
    var codeLength: Int { get }
}

// MARK: - Internal Models
extension PasswordView {
    
    enum Mode {
        
        struct CheckPasswordDTO: PasswordCheckable {
            let allowedCharacters: CharacterSet = .decimalDigits
            let codeLength = 4
            let codeToCheck: String
        }
        
        struct WritePasswordDTO: PasswordCheckable {
            let allowedCharacters: CharacterSet = .decimalDigits
            let codeLength = 4
        }
        
        case checkPassword(CheckPasswordDTO)
        case writePassword(WritePasswordDTO)
        
        var allowedCharacters: CharacterSet {
            switch self {
            case .checkPassword(let checkableDTO):
                return checkableDTO.allowedCharacters
            case .writePassword(let writableDTO):
                return writableDTO.allowedCharacters
            }
        }
        
        var codeLength: Int {
            switch self {
            case .checkPassword(let checkableDTO):
                return checkableDTO.codeLength
            case .writePassword(let writableDTO):
                return writableDTO.codeLength
            }
        }
    }
    
    // MARK: CodeContainer
    class CodeContainer: ObservableObject {
        
        // MARK: - Constants
        private let codeLength: Int
        private let allowedCharacters: CharacterSet
        
        // MARK: - Properties
        @Published var code = ""
        var validated: String {
            filter(newValue: code)
        }
        var isCodeFull: Bool {
            code.count == codeLength
        }
        
        init(mode: Mode) {
            self.allowedCharacters = mode.allowedCharacters
            self.codeLength = mode.codeLength
        }
        
        @discardableResult
        func filter(newValue: String) -> String {
            if code.count > codeLength {
                code = String(code.prefix(codeLength))
                print("Suffixed \(code)")
            }
            
            let filtered = String(newValue
                                    .unicodeScalars
                                    .filter { allowedCharacters.contains($0) }
                                    .map { Character($0) })
            if filtered != newValue {
                code = filtered
            }
            return code
        }
    }
}
