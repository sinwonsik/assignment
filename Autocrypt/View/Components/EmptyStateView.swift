//
//  EmptyStateView.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/24/24.
//

import SwiftUI

struct EmptyStateView: View {
    var message: String
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    private var contentView:some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass").font(.system(size: 50))
            Text("결과 없음")
                .font(.system(size: 24))
            Text("\(message)에 대한 결과가 없습니다.")
                .font(.system(size: 16))
                    .foregroundColor(.gray)
            Spacer()
        }
    }
}

