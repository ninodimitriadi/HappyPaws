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
                    .fill(.mainYellow)
                    .frame(width: 50)
                    .opacity(0.3)
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.mainYellow)
            }
            Text(value)
                .font(.title3)
                .foregroundColor(.black)
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}
