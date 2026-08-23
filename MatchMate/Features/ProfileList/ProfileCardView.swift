//
//  ProfileCardView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileCardView: View {

    let profile: Profile
    let detailView: AnyView

    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Tappable Profile Area

            NavigationLink {
                detailView
            } label: {

                VStack(alignment: .leading, spacing: 12) {

                    AsyncImage(
                        url: URL(
                            string: profile.largeImageURL
                        )
                    ) { phase in

                        switch phase {

                        case .empty:
                            ProgressView()

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure:
                            Image(
                                systemName: "person.crop.circle"
                            )
                            .resizable()
                            .scaledToFit()
                            .padding(40)

                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipped()

                    VStack(alignment: .leading, spacing: 6) {

                        Text(profile.fullName)
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(
                            "\(profile.age) • \(profile.country)"
                        )
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .buttonStyle(.plain)

            // MARK: - Status / Actions

            switch profile.status {

            case .pending:

                HStack(spacing: 12) {

                    Button {
                        onDecline()
                    } label: {
                        Text("Decline")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        onAccept()
                    } label: {
                        Text("Accept")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)

            case .accepted:

                Label(
                    "Accepted",
                    systemImage: "checkmark.circle.fill"
                )
                .foregroundStyle(.green)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)

            case .declined:

                Label(
                    "Declined",
                    systemImage: "xmark.circle.fill"
                )
                .foregroundStyle(.red)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
            }
        }
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .shadow(radius: 5)
    }
}
