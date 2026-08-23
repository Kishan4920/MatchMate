//
//  ProfileEntity+CoreDataProperties.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias ProfileEntityCoreDataPropertiesSet = NSSet

extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var age: Int16
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var largeImageURL: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mediumImageURL: String?
    @NSManaged public var nationality: String?
    @NSManaged public var phone: String?
    @NSManaged public var registeredDate: Date?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var state: String?
    @NSManaged public var status: String?
    @NSManaged public var thumbnailImageURL: String?
    @NSManaged public var title: String?

}

extension ProfileEntity : Identifiable {

}
