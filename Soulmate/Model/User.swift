//
//  User.swift
//  Soulmate
//
//  Created by Will Lam on 22/2/2021.
//

import RealmSwift

class User: Object {
    @objc dynamic var userID: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    @objc dynamic var userNormalRange: UserHealthNormalRange? = UserHealthNormalRange()
    @objc dynamic var userStressIndexRecord: StressIndexRecord? = nil
}
