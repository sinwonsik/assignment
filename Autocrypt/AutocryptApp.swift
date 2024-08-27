//
//  AutocryptApp.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import SwiftUI

@main
struct AutocryptApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                clearCache()
            }
        }
    }

    private func clearCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
}
