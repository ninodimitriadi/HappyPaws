//
//  StatItemView.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import SwiftUICore


struct RoundItemView: View {
    let iconName: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .frame(width: 50)
                    .foregroundStyle(.gray)
                    .opacity(0.3)
                Image(iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black)
            }
            Text(value)
                .font(.headline)
                .foregroundColor(.black)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
