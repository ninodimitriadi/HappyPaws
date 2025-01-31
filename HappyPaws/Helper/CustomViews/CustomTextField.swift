//
//  CustomTextField.swift
//  HappyPaws
//
//  Created by nino on 1/16/25.
//


import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField("", text: $text)
                .frame(height: 10)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}
