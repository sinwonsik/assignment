//
//  CustomRoundedRectangle.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/25/24.
//

import SwiftUI

struct CustomRoundedRectangle: View {
    var title: String
    var value: String
    var unit: String? = nil
    var backgroundColor: Color
    
    init(title: String, value: String, unit: String? = nil, backgroundColor: Color = Color(red: 78/255, green: 117/255, blue: 175/255)) {
        self.title = title
        self.value = value
        self.unit = unit
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            if let unit = unit {
                Text(unit)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(20)
        
    }
}
