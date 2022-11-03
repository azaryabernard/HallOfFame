//
//  ProjectContentView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import SwiftUI
import Resolver

struct ProjectContentView: View {
    
    @Injected private var api: Api
    
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    if let image = project.image {
                        Image(uiImage: image)
                            .resizable()
                            .tint(Color(UIColor.label))
                            .scaledToFit()
                            .frame(height: 48)
                    }
                    VStack(spacing: 4) {
                        Text(project.title).font(.largeTitle).fontWeight(.black).multilineTextAlignment(.center)
                        Text(project.key).font(.headline).foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }
                ForEach(stakeholderGroups, id: \.title) {
                    StakeholderGroupView(group: $0)
                }
            }.padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
        }
    }
    
    private var stakeholderGroups: [StakeholderGroup] {
        [
            StakeholderGroup(
                title: "project.stakeholder.customers".localizedWithFormat(project.customers.count),
                stakeholders: mapUsersToStakeholders(project.customers)
            ),
            StakeholderGroup(
                title: "project.stakeholder.projectLead".localizedWithFormat(project.projectLeads.count),
                stakeholders: mapUsersToStakeholders(project.projectLeads)
            ),
            StakeholderGroup(
                title: "project.stakeholder.coaches".localizedWithFormat(project.coaches.count),
                stakeholders: mapUsersToStakeholders(project.coaches)
            ),
            StakeholderGroup(
                title: "project.stakeholder.developers".localizedWithFormat(project.developers.count),
                stakeholders: mapUsersToStakeholders(project.developers)
            )
        ].filter({ !$0.stakeholders.isEmpty })
    }
    
    private func mapUsersToStakeholders(_ users: [User]) -> [Stakeholder] {
        users.map({
            Stakeholder(
                key: $0.username,
                name: $0.displayName,
                imageUrl: api.url(forImageResource: $0.avatar)
            )
        }).sorted(by: { $0.name < $1.name })
    }

}

struct ProjectContentView_Previews: PreviewProvider {

    static var previews: some View {
        let project = Project(
            key: "sz",
            identifier: "ios2122sz",
            title: "AutoPlay",
            image: nil,
            customer: Customer(key: "sz", name: "Süddeutsche Zeitung", longName: nil),
            customers: [],
            projectLeads: [],
            coaches: [],
            developers: []
        )
        
        return ProjectContentView(project: project)
    }

}
