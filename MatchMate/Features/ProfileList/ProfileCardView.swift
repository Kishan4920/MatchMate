//
//  ProfileCardView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileCardView<Destination: View>: View {

    let profile: Profile
    let destination: Destination

    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Profile / Navigation Area
            NavigationLink {
                destination
            } label: {
                profileContent
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // MARK: - Action Area

            actionSection
        }
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .shadow(radius: 5)
    }

    // MARK: - Profile Content

    private var profileContent: some View {

        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(
                url: URL(
                    string: profile.largeImageURL
                )
            ) { phase in

                switch phase {

                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    ZStack {
                        Color.gray.opacity(0.1)

                        Image(
                            systemName: "person.crop.circle"
                        )
                        .resizable()
                        .scaledToFit()
                        .padding(50)
                    }

                @unknown default:
                    EmptyView()
                }
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 220,
                maxHeight: 220
            )
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

    // MARK: - Actions

    @ViewBuilder
    private var actionSection: some View {

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
}
