//
//  CachedRemoteImage.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import SwiftUI
import UIKit

struct CachedRemoteImage<Placeholder: View>: View {
    private let url: URL?
    private let cache: ImageCaching
    private let contentMode: ContentMode
    private let placeholder: () -> Placeholder

    @State private var image: UIImage?

    init(
        url: URL?,
        cache: ImageCaching = DiskImageCache.shared,
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.cache = cache
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            guard let url else { return }
            guard let data = await cache.imageData(for: url),
                  let loadedImage = UIImage(data: data) else {
                return
            }
            image = loadedImage
        }
    }
}
