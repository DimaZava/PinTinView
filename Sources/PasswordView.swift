//
//  PasswordView.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 13.07.2021.
//

import Combine
import SwiftUI

public struct PasswordView: View {
    
    // MARK: Constants
    private let mode: Mode
    private let backgroundColor: Color = .white
    private let stackViewAnimation: Animation =
        .interpolatingSpring(mass: 1, stiffness: 400, damping: 24, initialVelocity: 1)
    private let spacing: CGFloat = 8
    private let loadCircleSide: CGFloat = 28
    private let circleSide: CGFloat = 20
    private let keyboardDelay: Double = 0.8
    private let autocheckDelay: Double = 0.5
    
    // MARK: Properites
    public var codeSelected: (String) -> Void = { _ in }
    public var ifNeedsToAutoCheck = true
    @State public var isLoading: Bool
    
    @State private var ifNeedsToHighlightError: Bool
    @State private var invalidAttempts: Int
    @ObservedObject private var codeContainer: CodeContainer
    @State private var autocheckTimer: Timer?
    
    
    // MARK: Lifecycle
    public init(mode: Mode, isLoading: Bool = false) {
        self.mode = mode
        self._isLoading = .init(initialValue: isLoading)
        self._ifNeedsToHighlightError = .init(initialValue: false)
        self._invalidAttempts = .init(initialValue: 0)
        self.codeContainer = .init(mode: mode)
    }
    
    public var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            HStack(spacing: spacing) {
                if isLoading {
                    ActivityIndicator(isAnimating: $isLoading, style: .large, color: .black)
                        .background(backgroundColor)
                } else {
                    ForEach(0..<mode.codeLength) { index in
                        ZStack {
                            Circle()
                                .fill(Color(.lightGray))
                            Circle()
                                .select(codeContainer.validated[safe: index] != nil,
                                        isError: ifNeedsToHighlightError,
                                        animation: stackViewAnimation)
                        }
                        .frame(width: circleSide, height: circleSide)
                        .transition(.offset(x: offset(for: index), y: 0))
                        .modifier(ShakeEffect(shakes: invalidAttempts * 2))
                        .animation(invalidAttempts != 0 ? .linear : stackViewAnimation)
                    }
                }
                
                TextField("", text: $codeContainer.code.onChange { output in
                    codeContainer.filter(newValue: output)
                    if ifNeedsToAutoCheck {
                        autocheckTimer?.invalidate()
                        autocheckTimer = Timer.scheduledTimer(withTimeInterval: autocheckDelay, repeats: false) { _ in
                            commitCodeEntering()
                        }
                    }
                }, onCommit: {
                    commitCodeEntering()
                })
                .keyboardType(.numberPad)
                .introspectTextField { textField in
                    textField.alpha = 0
                    if isLoading {
                        guard textField.isFirstResponder else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardDelay) {
                            textField.resignFirstResponder()
                        }
                    } else {
                        guard !textField.isFirstResponder else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            textField.becomeFirstResponder()
                        }
                    }
                }
                .frame(width: 0, height: 0, alignment: .center)
            }
        }
    }
    
    // MARK: Actions
    func commitCodeEntering() {
        guard codeContainer.isCodeFull else { return }
        
        switch mode {
        case .checkPassword(let checkableDTO):
            if codeContainer.code == checkableDTO.codeToCheck {
                codeSelected(codeContainer.code)
                isLoading = true
            } else {
                invalidAttempts += 1
                
                ifNeedsToHighlightError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    ifNeedsToHighlightError = false
                }
            }
        case .writePassword:
            codeSelected(codeContainer.code)
            isLoading = true
        }
    }
}

// MARK: - Private Extension
private extension PasswordView {
    
    /// Calculates initial or final offset for circles animation while expanding or collapsing
    /// - Parameter circleIndex: Circle index
    /// - Returns: Offset for animation
    func offset(for circleIndex: Int) -> CGFloat {
        let offsetIndex = CGFloat(mode.codeLength) / 2.0 - CGFloat(circleIndex) - 1.0
        return (offsetIndex + 0.5) * circleSide + (offsetIndex + 0.5) * spacing // 0.5 for half of middle spacing
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(mode: .writePassword(.init()))
    }
}
