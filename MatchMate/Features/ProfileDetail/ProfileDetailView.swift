//
//  ProfileDetailView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//
import SwiftUI

struct ProfileDetailView: View {

    @StateObject private var viewModel: ProfileDetailViewModel

    let onStatusChanged: (ProfileStatus) -> Void
    
    init(
            profile: Profile,
            repository: ProfileRepository,
            onStatusChanged: @escaping (ProfileStatus) -> Void
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

            VStack(spacing: 20) {

                profileImage

                profileInformation

                contactInformation

                locationInformation

                statusSection

                actionButtons
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
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

    private var profileInformation: some View {

        VStack(spacing: 8) {

            Text(viewModel.profile.fullName)
                .font(.title)
                .fontWeight(.bold)

            Text(
                "\(viewModel.profile.age) • \(viewModel.profile.country)"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(viewModel.profile.gender.capitalized)
                .foregroundStyle(.secondary)
        }
    }

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
    }

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
    }

    private var statusSection: some View {

        Group {

            switch viewModel.profile.status {

            case .pending:
                Label(
                    "Pending",
                    systemImage: "clock"
                )

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
        .font(.headline)
    }

    private var actionButtons: some View {

        HStack(spacing: 16) {
            
            Button {
                Task {
                    let success =
                    await viewModel.updateStatus(.declined)
                    
                    if success {
                        onStatusChanged(.declined)
                    }
                }
            } label: {
                Label(
                    "Decline",
                    systemImage: "xmark"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            Button {
                Task {
                    let success =
                    await viewModel.updateStatus(.accepted)
                    
                    if success {
                        onStatusChanged(.accepted)
                    }
                }
            } label: {
                Label(
                    "Accept",
                    systemImage: "checkmark"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
