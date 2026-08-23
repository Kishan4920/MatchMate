//
//  DefaultProfileRepository.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import CoreData

@MainActor
final class DefaultProfileRepository: ProfileRepository {
    private let apiClient: APIClient
    private let context: NSManagedObjectContext
    private var currentPage = 0

    init(apiClient: APIClient, persistenceController: PersistenceController) {
        self.apiClient = apiClient
        self.context = persistenceController.container.viewContext
    }

    func loadCachedProfiles() async throws -> [Profile] {
        let profiles = try fetchProfilesFromDatabase()
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "page", ascending: false)]
        request.fetchLimit = 1
        currentPage = Int(try context.fetch(request).first?.page ?? 0)
        return profiles
    }

    func fetchNextPage() async throws -> [Profile] {
        let page = currentPage + 1
        let response = try await apiClient.fetchProfiles(page: page, results: 10)
        try save(response.results, page: response.info.page)
        currentPage = response.info.page
        return try fetchProfilesFromDatabase()
    }

    func updateStatus(profileID: String, status: ProfileStatus) async throws {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", profileID)

        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.profileNotFound
        }

        entity.status = status.rawValue
        try context.save()
    }

    private func save(_ profiles: [RandomUserDTO], page: Int) throws {
        for (index, remoteProfile) in profiles.enumerated() {
            let id = remoteProfile.login.uuid
            let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            let entity = try context.fetch(request).first ?? ProfileEntity(context: context)

            entity.id = id
            entity.title = remoteProfile.name.title
            entity.firstName = remoteProfile.name.first
            entity.lastName = remoteProfile.name.last
            entity.gender = remoteProfile.gender
            entity.email = remoteProfile.email
            entity.phone = remoteProfile.phone
            entity.age = Int16(remoteProfile.dob.age)
            entity.dateOfBirth = parseDate(remoteProfile.dob.date)
            entity.registeredDate = parseDate(remoteProfile.registered.date)
            entity.city = remoteProfile.location.city
            entity.state = remoteProfile.location.state
            entity.country = remoteProfile.location.country
            entity.nationality = remoteProfile.nationality
            entity.largeImageURL = remoteProfile.picture.large
            entity.mediumImageURL = remoteProfile.picture.medium
            entity.thumbnailImageURL = remoteProfile.picture.thumbnail
            entity.page = Int32(page)
            entity.sortIndex = Int64((page - 1) * 10 + index)
            if entity.status == nil {
                entity.status = ProfileStatus.pending.rawValue
            }
        }
        try context.save()
    }

    private func fetchProfilesFromDatabase() throws -> [Profile] {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
        return try context.fetch(request).compactMap(map)
    }

    private func map(_ entity: ProfileEntity) -> Profile? {
        guard let id = entity.id,
              let firstName = entity.firstName,
              let lastName = entity.lastName,
              let status = entity.status.flatMap(ProfileStatus.init(rawValue:)) else {
            return nil
        }
        return Profile(
            id: id,
            title: entity.title ?? "",
            firstName: firstName,
            lastName: lastName,
            gender: entity.gender ?? "",
            email: entity.email ?? "",
            phone: entity.phone ?? "",
            age: Int(entity.age),
            dateOfBirth: entity.dateOfBirth,
            registeredDate: entity.registeredDate,
            city: entity.city ?? "",
            state: entity.state ?? "",
            country: entity.country ?? "",
            nationality: entity.nationality ?? "",
            largeImageURL: entity.largeImageURL ?? "",
            mediumImageURL: entity.mediumImageURL ?? "",
            thumbnailImageURL: entity.thumbnailImageURL ?? "",
            status: status
        )
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
}

enum RepositoryError: LocalizedError {
    case profileNotFound

    var errorDescription: String? {
        "The selected profile could not be found."
    }
}
