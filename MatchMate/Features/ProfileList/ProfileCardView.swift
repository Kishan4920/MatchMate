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
            .accessibilityIdentifier(AccessibilityIdentifiers.profileContent)

            // MARK: - Action Area

            actionSection
                .padding(.bottom)
        }
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.background)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.09), radius: 14, y: 6)
    }

    // MARK: - Profile Content

    private var profileContent: some View {

        VStack(alignment: .leading, spacing: 12) {
            CachedRemoteImage(url: URL(string: profile.largeImageURL)) {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
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
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(
                    "\(profile.age) • \(profile.country)"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 2)
            .padding(.bottom, 18)
        }
    }

    // MARK: - Actions

    @ViewBuilder
    private var actionSection: some View {

        ZStack {

            switch profile.status {

            case .pending:

                HStack(spacing: 12) {

                    StatusButton(status: .declined) {
                        onDecline()
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.declineButton)

                    StatusButton(status: .accepted) {
                        onAccept()
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.acceptButton)
                }

            case .accepted:

                StatusTextView(status: .accepted)
                    .accessibilityIdentifier(AccessibilityIdentifiers.status)

            case .declined:

                StatusTextView(status: .declined)
                    .accessibilityIdentifier(AccessibilityIdentifiers.status)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 52)
        .padding(.horizontal)
        .padding(.top, 12)
        .overlay(alignment: .top) {
            Divider()
                .padding(.horizontal)
        }
    }
}
