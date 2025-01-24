//
//  SmallRoundViewWithText.swift
//  HappyPaws
//
//  Created by nino on 1/23/25.
//

import SwiftUICore


struct SmallRoundViewWithText: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.mainYellow.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.mainYellow)
            }
            
            Text(text)
                .font(.caption)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .frame(width: 100) 
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
