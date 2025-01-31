//
//  GenderPicker.swift
//  HappyPaws
//
//  Created by nino on 1/16/25.
//

import SwiftUI
import SwiftUI


struct GenderPicker: View {
    @Binding var selectedGender: Gender
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(languageManager.localizedString(forKey: "gender"))
                .font(.headline)
                .foregroundColor(.black)

            Picker(languageManager.localizedString(forKey: "gender"), selection: $selectedGender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue.capitalized).tag(gender)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
