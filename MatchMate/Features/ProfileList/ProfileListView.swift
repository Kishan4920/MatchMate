//
//  ProfileListView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileListView: View {

    @StateObject private var viewModel: ProfileListViewModel

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {

        self.repository = repository

        _viewModel = StateObject(
            wrappedValue: ProfileListViewModel(
                repository: repository
            )
        )
    }

    var body: some View {

        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isOffline {
                        Label("Showing saved profiles", systemImage: "wifi.slash")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .accessibilityIdentifier("offline-banner")
                    }

                    ForEach(viewModel.profiles) { profile in
                        ProfileCardView(
                            profile: profile,

                            destination: ProfileDetailView(
                                profile: profile,
                                repository: repository
                            ) { newStatus in
                                await viewModel.updateStatus(
                                    profileID: profile.id,
                                    status: newStatus
                                )
                            },

                            onAccept: {

                                Task {
                                    await viewModel.updateStatus(
                                        profileID: profile.id,
                                        status: .accepted
                                    )
                                }
                            },

                            onDecline: {

                                Task {
                                    await viewModel.updateStatus(
                                        profileID: profile.id,
                                        status: .declined
                                    )
                                }
                            }
                        )
                        .padding(.horizontal)
                        .accessibilityIdentifier("profile-card-\(profile.id)")
                        .onAppear {

                            Task {
                                await viewModel.loadMoreIfNeeded(
                                    currentItem: profile
                                )
                            }
                        }
                    }

                    if viewModel.isLoadingMore {

                        ProgressView()
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("MatchMate")
            .alert("Unable to Load Profiles", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task {
                await viewModel.loadProfiles()
            }
        }
    }
}
