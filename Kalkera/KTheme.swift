//
//  KTheme.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import Foundation

class KTheme {
    static let shared = KTheme()
    private init() { }
    
    let kPrimaryButtonConfiguration = KPrimaryButton.KPrimaryButtonConfiguration(borderWidth: 2.0,
                                                                                 cornerRadius: 10,
                                                                                 backgroundColor: .white,
                                                                                 textColor: .black,
                                                                                 highlightedTextColor: .gray,
                                                                                 borderColor: .blue,
                                                                                 font: .systemFont(ofSize: 24,
                                                                                                   weight: .bold))

    let kLockButtonConfiguration = KLockButton.KLockButtonConfiguration(unlockedBackgroundColor: .red,
                                                                        lockedBackgroundColor: .green,
                                                                        unlockedImage: "pencil-off",
                                                                        lockedImage: "pencil-lock",
                                                                        textColor: .white,
                                                                        font: .systemFont(ofSize: 24,
                                                                                         weight: .bold))
}
