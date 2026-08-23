//
//  StatusTextView.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import SwiftUI

struct StatusTextView: View {
    let status: ProfileStatus

    var body: some View {
        Label(status.displayTitle, systemImage: status.displaySystemImage)
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(status.displayColor)
            .background(status.displayColor.opacity(0.1), in: Capsule())
    }
}

private extension ProfileStatus {
    var displayTitle: String {
        switch self {
        case .pending:
            return "Pending"
        case .accepted:
            return "Accepted"
        case .declined:
            return "Declined"
        }
    }

    var displaySystemImage: String {
        switch self {
        case .pending:
            return "clock"
        case .accepted:
            return "checkmark.circle.fill"
        case .declined:
            return "xmark.circle.fill"
        }
    }

    var displayColor: Color {
        switch self {
        case .pending:
            return .secondary
        case .accepted:
            return .green
        case .declined:
            return .red
        }
    }
}
