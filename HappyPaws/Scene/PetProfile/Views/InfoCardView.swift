//
//  InfoCardView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUICore


struct InfoCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.custom("Poppins-Regular", size: 16))
                .foregroundColor(.gray)
            Text(value)
                .font(Font.custom("Poppins-Bold", size: 17.5))
                .foregroundStyle(.mainYellow)
        }
        .frame(maxWidth: .infinity)
        .padding(17)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(12)
    }
}
