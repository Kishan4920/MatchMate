//
//  StatusButton.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import SwiftUI

struct StatusButton: View {
    let status: ProfileStatus
    let accessibilityIdentifier: String
    let action: () -> Void

    init(
        status: ProfileStatus,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.status = status
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Label(status.actionTitle, systemImage: status.actionSystemImage)
                .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier(accessibilityIdentifier)
        .buttonStyle(StatusButtonStyle(status: status))
    }
}

private struct StatusButtonStyle: ButtonStyle {
    let status: ProfileStatus

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(status == .accepted ? .white : .red)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(status == .accepted ? Color.green : Color.red.opacity(0.1))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(status == .accepted ? Color.clear : Color.red.opacity(0.3), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private extension ProfileStatus {
    var actionTitle: String {
        switch self {
        case .accepted:
            return "Accept"
        case .declined:
            return "Decline"
        case .pending:
            return "Pending"
        }
    }

    var actionSystemImage: String {
        switch self {
        case .accepted:
            return "checkmark"
        case .declined:
            return "xmark"
        case .pending:
            return "clock"
        }
    }
}
