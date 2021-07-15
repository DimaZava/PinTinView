//
//  ContentView.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 13.07.2021.
//

import Combine
import Introspect
import SwiftUI

struct ContentView: View {
    
    // MARK: Constants
    private let mode: Mode
    private let backgroundColor: Color = .white
    private let stackViewAnimation: Animation =
        .interpolatingSpring(mass: 1, stiffness: 400, damping: 24, initialVelocity: 1)
        // .linear(duration: 15)
    private let spacing: CGFloat = 8
    private let loadCircleSide: CGFloat = 28
    private let circleSide: CGFloat = 20
    private let keyboardDelay: Double = 0.8
    private let autocheckDelay: Double = 1
    
    // MARK: Properites
    var ifNeedsToAutoCheck = true
    
    @State var isLoading: Bool
    @ObservedObject private var codeContainer: CodeContainer
    private var codeObserver: AnyCancellable?
    private var codeSelected: (String) -> Void = { _ in }
    
    // MARK: Lifecycle
    init(mode: Mode, codeContainer: CodeContainer, isLoading: Bool = false) {
        self.mode = mode
        self._isLoading = .init(initialValue: isLoading)
        self.codeContainer = codeContainer
        codeObserver = codeContainer.$code
            .sink { newValue in
            }
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            HStack(spacing: spacing) {
                if isLoading {
                    ZStack {
                        Circle()
                            .fill(backgroundColor)
                            .frame(width: loadCircleSide, height: loadCircleSide)
                        ProgressView()
                            .frame(width: loadCircleSide, height: loadCircleSide)
                    }
                } else {
                    ForEach(0..<codeContainer.codeLength) { index in
                        ZStack {
                            Circle()
                                .fill(Color(.lightGray))
                            Circle()
                                .select(codeContainer.validated[safe: index] != nil, animation: stackViewAnimation)
                        }
                        .frame(width: circleSide, height: circleSide)
                        .transition(.offset(x: offset(for: index), y: 0))
                        .animation(stackViewAnimation)
                    }
                }
                
                TextField("", text: $codeContainer.code, onCommit: {
                    commitCodeEntering()
                })
                .keyboardType(.numberPad)
                .onReceive(Just(codeContainer.code)) { output in
                    codeContainer.validated(newValue: output)
                    if ifNeedsToAutoCheck {
                        DispatchQueue.main.asyncAfter(deadline: .now() + autocheckDelay) {
                            commitCodeEntering()
                        }
                    }
                }
                .introspectTextField { textField in
                    textField.alpha = 0
                    if isLoading {
                        guard textField.isFirstResponder else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardDelay) {
                            textField.resignFirstResponder()
                        }
                    } else {
                        guard !textField.isFirstResponder else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardDelay) {
                            textField.becomeFirstResponder()
                        }
                    }
                }
                .frame(width: 0, height: 0, alignment: .center)
            }
        }
        .onAppear {
            // Debug
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
            }
        }
    }
    
    // MARK: Actions
    func commitCodeEntering() {
        guard codeContainer.isCodeFull else { return }
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        codeSelected(codeContainer.code)
        isLoading = true
        // }
    }
}

// MARK: - Private Extension
private extension ContentView {
    
    /// Calculates initial or final offset for circles animation while expanding or collapsing
    /// - Parameter circleIndex: Circle index
    /// - Returns: Offset for animation
    func offset(for circleIndex: Int) -> CGFloat {
        let offsetIndex = CGFloat(codeContainer.codeLength) / 2.0 - CGFloat(circleIndex) - 1.0
        return (offsetIndex + 0.5) * circleSide + (offsetIndex + 0.5) * spacing // 0.5 for half of middle spacing
    }
}

// MARK: - Internal Models
extension ContentView {
    
    enum Mode {
        case writePassword
        case checkPassword(originalPassword: Int)
    }
    
    // MARK: CodeContainer
    class CodeContainer: ObservableObject {
        
        // MARK: - Constants
        let codeLength = 4
        
        // MARK: - Properties
        private var allowedCharacters: CharacterSet
        @Published var code = ""
        var validated: String {
            validated(newValue: code)
        }
        var isCodeFull: Bool {
            code.count == codeLength
        }
        
        init(allowedCharacters: CharacterSet = .decimalDigits) {
            self.allowedCharacters = allowedCharacters
        }
        
        @discardableResult
        func validated(newValue: String) -> String {
            if code.count > codeLength {
                code = String(code.prefix(codeLength))
                print("Suffixed \(code)")
            }
            
            let filtered = String(newValue.unicodeScalars
                                    .filter { allowedCharacters.contains($0) }
                                    .map { Character($0) })
            if filtered != newValue {
                code = filtered
            }
            return code
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mode: .writePassword, codeContainer: .init(), isLoading: true)
    }
}
