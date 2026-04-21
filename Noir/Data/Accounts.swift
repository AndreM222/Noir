//
//  Accounts.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/10/26.
//

import Foundation

struct Account: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var subscription: String
    var creationDate: Date
    var color: AvatarColor
    var icon: AvatarIcon

    static func examples() -> [Account] {
        let now = Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now) ?? now
        let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: now) ?? now

        return [
            Account(
                name: "Andre",
                subscription: "Premium",
                creationDate: now,
                color: .ocean,
                icon: .drop
            ),
            Account(
                name: "Jerry",
                subscription: "Pro",
                creationDate: oneMonthAgo,
                color: .neon,
                icon: .moon
            ),
            Account(
                name: "Alicia",
                subscription: "Family Plan",
                creationDate: twoMonthsAgo,
                color: .fire,
                icon: .flame
            )
        ]
    }
}

struct Profile: Identifiable, Hashable {
    let id = UUID()
    let account: UUID
    var name: String
    let service: String
    let userID: String
    var color: AvatarColor
    var icon: AvatarIcon

    static func examples(account: [Account]) -> [Profile] {
        let personalAccountID = account[0].id
        let workAccountID = account[1].id
        let familyAccountID = account[2].id

        return [
            // Personal account profiles
            Profile(
                account: personalAccountID,
                name: "Main Netflix",
                service: "netflix",
                userID: "netflix_1234567890_personal_main",
                color: .ocean,
                icon: .drop
            ),
            Profile(
                account: personalAccountID,
                name: "Kids Netflix",
                service: "netflix",
                userID: "netflix_1234567890_personal_kids",
                color: .neon,
                icon: .moon
            ),
            Profile(
                account: personalAccountID,
                name: "HBO Max",
                service: "hbo",
                userID: "hbo_0987654321_personal",
                color: .zen,
                icon: .bolt
            ),

            // Work account profiles
            Profile(
                account: workAccountID,
                name: "Work Netflix",
                service: "netflix",
                userID: "netflix_1122334455_work",
                color: .ocean,
                icon: .drop
            ),
            Profile(
                account: workAccountID,
                name: "Disney+ Business",
                service: "disney",
                userID: "disney_6677889900_work",
                color: .ocean,
                icon: .drop
            ),

            // Family account profiles
            Profile(
                account: familyAccountID,
                name: "Family Netflix",
                service: "netflix",
                userID: "netflix_5566778899_family",
                color: .ocean,
                icon: .drop
            ),
            Profile(
                account: familyAccountID,
                name: "Dad's HBO",
                service: "hbo",
                userID: "hbo_3344556677_family_dad",
                color: .fire,
                icon: .flame
            ),
            Profile(
                account: familyAccountID,
                name: "Mom's HBO",
                service: "hbo",
                userID: "hbo_3344556677_family_mom",
                color: .cosmic,
                icon: .person
            ),
            Profile(
                account: familyAccountID,
                name: "Prime Video Family",
                service: "primevideo",
                userID: "primevideo_a1b2c3d4e5_family",
                color: .ocean,
                icon: .drop
            )
        ]
    }
}
