//
//  SeeFoodApp.swift
//  SeeFood
//
//  Created by Justin Cheung on 12/24/20.
//

import SwiftUI

@main
struct SeeFoodApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SeeFoodView()
        }
    }
}
