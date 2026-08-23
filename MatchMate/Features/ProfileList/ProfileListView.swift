//
//  ProfileListView.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

struct ProfileListView: View {

    @StateObject private var viewModel:
        ProfileListViewModel

    init(repository: ProfileRepository) {

        _viewModel = StateObject(
            wrappedValue:
                ProfileListViewModel(
                    repository: repository
                )
        )
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 16) {

                    ForEach(viewModel.profiles) { profile in

                        ProfileCardView(
                            profile: profile,

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
            .task {
                await viewModel.loadProfiles()
            }
        }
    }
}
