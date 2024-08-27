//
//  KeyboardExtensions.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/27/24.
//

import UIKit

struct KeyboardHelpers {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
