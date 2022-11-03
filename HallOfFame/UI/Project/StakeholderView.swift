//
//  StakeholderView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI

struct StakeholderView: View {
    
    let stakeholder: Stakeholder
    
    var body: some View {
        HStack {
            AsyncImage(url: stakeholder.imageUrl) {
                switch $0 {
                case let .success(image): image.resizable()
                case .failure: placeholderImageView
                case .empty: placeholderImageView
                @unknown default: EmptyView()
                }
            }.frame(width: 48, height: 48).cornerRadius(8)
            VStack(alignment: .leading, spacing: 2) {
                Text(stakeholder.name).font(.headline)
                Text(stakeholder.key).font(.subheadline).foregroundColor(Color(UIColor.secondaryLabel))
            }
            Spacer()
        }.frame(maxWidth: .infinity)
    }

    private var placeholderImageView: Image {
        Image(uiImage: UIImage(image: "person.fill".symbol, size: CGSize(width: 96, height: 96))!).resizable()
    }
    
}

struct StakeholderView_Previews: PreviewProvider {
    static var previews: some View {
        StakeholderView(
            stakeholder: Stakeholder(
                key: "bb",
                name: "Bernd Brügge",
                imageUrl: URL(string: "https://placekitten.com/48/48")!
            )
        )
    }
}
