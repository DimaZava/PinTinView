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
    
    // MARK: Properites
    @ObservedObject private var codeContainer = CodeContainer()
    private var codeObserver: AnyCancellable?
    
    // MARK: Lifecycle
    init() {
        codeObserver = codeContainer.$code
            .sink { newValue in
                // print(newValue)
            }
    }
    
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 20, height: 20, alignment: .center)
                    Circle()
                        .select(codeContainer.validated[safe: 0] != nil)
                }
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 20, height: 20, alignment: .center)
                    Circle()
                        .select(codeContainer.validated[safe: 1] != nil)
                }
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 20, height: 20, alignment: .center)
                    Circle()
                        .select(codeContainer.validated[safe: 2] != nil)
                }
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 20, height: 20, alignment: .center)
                    Circle()
                        .select(codeContainer.validated[safe: 3] != nil)
                }
            }
            TextField("Hello world", text: $codeContainer.code)
                .keyboardType(.numberPad)
                .onReceive(Just(codeContainer.code), perform: codeContainer.validate)
                .introspectTextField { textField in
                    textField.alpha = 0
                    textField.becomeFirstResponder()
                }
                .frame(width: 0, height: 0, alignment: .center)
        }
    }
}

// MARK: - Private Extension
private extension ContentView {

    class CodeContainer: ObservableObject {
        
        // MARK: - Constants
        private let codeLength = 4
        
        // MARK: - Properties
        @Published var code = ""
        var validated: String {
            validated(newValue: code)
        }
        
        init(code: String = "") {
            self.code = code
        }
        
        @discardableResult
        func validated(newValue: String) -> String {
            if code.count > codeLength {
                code = String(code.prefix(codeLength))
                print("Suffixed \(code)")
            }
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
                code = filtered
            }
            return code
        }
        
        func validate(newValue: String) {
            validated(newValue: newValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
