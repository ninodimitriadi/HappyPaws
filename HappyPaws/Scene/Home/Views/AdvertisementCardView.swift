//
//  AdvertisementCardView.swift
//  HappyPaws
//
//  Created by nino on 1/30/25.
//

import SwiftUI

struct AdvertisementCarouselView: View {
    private let sampleAds = [
        ("Vet Clinic", "Healthy Pets"),
        ("Grooming Salon", "Professional Pet Care"),
        ("Pet Supplies", "Best Discounts on Pet Products"),
        ("Veterinary Services", "Book an Appointment Now")
    ]
    
    @State private var currentPage = 0
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(sampleAds.indices, id: \.self) { index in
                    AdCardView(title: sampleAds[index].0, text: sampleAds[index].1)
                        .frame(width: 350, height: 200)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 220)
            
            HStack {
                ForEach(sampleAds.indices, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.primary : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            withAnimation {
                                currentPage = index
                            }
                        }
                }
            }
            .padding(.top, 10)
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentPage = (currentPage + 1) % sampleAds.count
            }
        }
    }
}

struct AdCardView: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("BebasNeue-Regular", size: 39))
                .foregroundColor(.white)
            
            Text(text)
                .font(.custom("BebasNeue-Regular", size: 20))
                .foregroundColor(.white)
        }
        .padding(.top, 24)
        .padding(.leading, 20)
        .padding(.bottom, 40)
        .frame(width: 370, height: 200, alignment: .leading)
        .background(Color.cardBeige)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertisementCarouselView()
    }
}

//#Preview {
//    AdCardView(title: "take care of your pets", text: "schedule an appointment now")
//}
