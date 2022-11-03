//
//  StakeholderGroupView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI

struct StakeholderGroupView: View {
    
    let group: StakeholderGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(group.title).font(.title2)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(group.stakeholders, id: \.key) {
                    StakeholderView(stakeholder: $0)
                }
            }
        }
    }

}

struct StakeholderGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StakeholderGroupView(
            group: StakeholderGroup(
                title: "Customers",
                stakeholders: [
                    Stakeholder(
                        key: "bb1",
                        name: "Bernd Brügge",
                        imageUrl: URL(string: "https://placekitten.com/48/48")!
                    ),
                    Stakeholder(
                        key: "bb2",
                        name: "Bernd Brügge",
                        imageUrl: URL(string: "https://placekitten.com/48/48")!
                    )
                ]
            )
        )
    }
}
