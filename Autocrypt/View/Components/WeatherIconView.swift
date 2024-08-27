//
//  WeatherIconView.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/25/24.
//

import SwiftUI

struct WeatherIconView: View {
    let iconName: String?

    var body: some View {
        if let iconName = iconName {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        } else {
            Image(systemName: "questionmark")
                .frame(width: 40, height: 40)
        }
    }
}
