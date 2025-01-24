//
//  StarRatingView.swift
//  HappyPaws
//
//  Created by nino on 1/23/25.
//

import SwiftUICore


struct StarRatingView: View {
    let rating: Double
    let maxStars: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<Int(rating), id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.starYellow)
            }
            if rating.truncatingRemainder(dividingBy: 1) >= 0.5 {
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.starYellow)
            }
            ForEach(0..<maxStars - Int(ceil(rating)), id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        }
    }
}
