//
//  ImageCache.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import Foundation

protocol ImageCaching: Sendable {
    func imageData(for url: URL) async -> Data?
}

class DiskImageCache: ImageCaching {
    static let shared = DiskImageCache()

    private static let maximumDiskImageCount = 50

    private let fileManager: FileManager
    private let session: URLSession
    private let directory: URL
    private let memoryCache: NSCache<NSString, NSData>

    init(
        fileManager: FileManager = .default,
        session: URLSession = .shared
    ) {
        self.fileManager = fileManager
        self.session = session
        memoryCache = NSCache<NSString, NSData>()
        memoryCache.countLimit = Self.maximumDiskImageCount
        directory = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("ProfileImages", isDirectory: true)
    }

    func imageData(for url: URL) async -> Data? {
        let cacheKey = url.absoluteString as NSString
        let fileURL = cachedFileURL(for: url)

        if let memoryData = memoryCache.object(forKey: cacheKey) {
            updateAccessDate(for: fileURL)
            return Data(referencing: memoryData)
        }

        if let cachedData = try? Data(contentsOf: fileURL) {
            memoryCache.setObject(cachedData as NSData, forKey: cacheKey)
            updateAccessDate(for: fileURL)
            return cachedData
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                return nil
            }

            try fileManager.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
            try data.write(to: fileURL, options: .atomic)
            memoryCache.setObject(data as NSData, forKey: cacheKey)
            removeOldestDiskImagesIfNeeded()
            return data
        } catch {
            return nil
        }
    }

    private func updateAccessDate(for fileURL: URL) {
        try? fileManager.setAttributes(
            [.modificationDate: Date()],
            ofItemAtPath: fileURL.path
        )
    }

    private func removeOldestDiskImagesIfNeeded() {
        guard let files = try? fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return
        }

        let imageFiles = files.filter { $0.pathExtension == "image" }
        guard imageFiles.count > Self.maximumDiskImageCount else {
            return
        }

        let sortedFiles = imageFiles.sorted { first, second in
            let firstDate = (try? first.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            let secondDate = (try? second.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return firstDate < secondDate
        }

        let filesToRemove = sortedFiles.prefix(imageFiles.count - Self.maximumDiskImageCount)
        for fileURL in filesToRemove {
            try? fileManager.removeItem(at: fileURL)
        }
    }

    private func cachedFileURL(for url: URL) -> URL {
        let key = Data(url.absoluteString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return directory.appendingPathComponent(key).appendingPathExtension("image")
    }
}
