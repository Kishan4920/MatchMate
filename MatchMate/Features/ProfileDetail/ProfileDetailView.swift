//
//  ProfileDetailView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileDetailView: View {

    @StateObject private var viewModel: ProfileDetailViewModel

    let onStatusChanged: (ProfileStatus) async -> Bool

    init(
        profile: Profile,
        repository: ProfileRepository,
        onStatusChanged: @escaping (ProfileStatus) async -> Bool
    ) {
        _viewModel = StateObject(
            wrappedValue: ProfileDetailViewModel(
                profile: profile,
                repository: repository
            )
        )

        self.onStatusChanged = onStatusChanged
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                profileImage

                profileInformation

                contactInformation

                locationInformation

                statusAndActions
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("profile-detail")
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { value in
                    if !value {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Image

    private var profileImage: some View {

        AsyncImage(
            url: URL(
                string: viewModel.profile.largeImageURL
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
                .padding(50)

            @unknown default:
                EmptyView()
            }
        }
        .frame(
            width: 220,
            height: 220
        )
        .clipShape(Circle())
    }

    // MARK: - Basic Information

    private var profileInformation: some View {

        VStack(spacing: 8) {

            Text(viewModel.profile.fullName)
                .font(.title)
                .fontWeight(.bold)

            Text(
                "\(viewModel.profile.age) • " +
                viewModel.profile.country
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(
                viewModel.profile.gender.capitalized
            )
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Contact

    private var contactInformation: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Contact")
                .font(.headline)

            Label(
                viewModel.profile.email,
                systemImage: "envelope"
            )

            Label(
                viewModel.profile.phone,
                systemImage: "phone"
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Location

    private var locationInformation: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Location")
                .font(.headline)

            Text(
                "\(viewModel.profile.city), " +
                "\(viewModel.profile.state), " +
                "\(viewModel.profile.country)"
            )

            Text(
                "Nationality: " +
                viewModel.profile.nationality
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Status / Actions

    @ViewBuilder
    private var statusAndActions: some View {

        Group {
            switch viewModel.profile.status {

            case .pending:

                actionButtons

            case .accepted:

                StatusTextView(status: .accepted)
                    .accessibilityIdentifier("status")

            case .declined:

                StatusTextView(status: .declined)
                    .accessibilityIdentifier("status")
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {

        HStack(spacing: 12) {

            StatusButton(status: .declined) {
                Task {

                    let success =
                        await viewModel.updateStatus(
                            .declined
                        )

                    if success {
                        await onStatusChanged(.declined)
                    }
                }
            }
            .accessibilityIdentifier("detail-decline-button")

            StatusButton(status: .accepted) {
                Task {

                    let success =
                        await viewModel.updateStatus(
                            .accepted
                        )

                    if success {
                        await onStatusChanged(.accepted)
                    }
                }
            }
            .accessibilityIdentifier("detail-accept-button")
        }
    }
}
