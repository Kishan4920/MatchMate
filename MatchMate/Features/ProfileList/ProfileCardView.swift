//
//  ProfileCardView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileCardView: View {

    let profile: Profile

    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {

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
                    Image(systemName: "person.crop.circle")
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

                HStack(spacing: 10) {

                    Button("Decline") {
                        onDecline()
                    }
                    .buttonStyle(.bordered)

                    Button("Accept") {
                        onAccept()
                    }
                    .buttonStyle(.borderedProminent)
                }

                statusView
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(.background)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
        .shadow(
            radius: 5,
            y: 2
        )
    }

    @ViewBuilder
    private var statusView: some View {

        switch profile.status {

        case .pending:
            EmptyView()

        case .accepted:
            Label(
                "Accepted",
                systemImage: "checkmark.circle.fill"
            )
            .foregroundStyle(.green)

        case .declined:
            Label(
                "Declined",
                systemImage: "xmark.circle.fill"
            )
            .foregroundStyle(.red)
        }
    }
}
