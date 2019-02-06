//
//  KPrimaryButton.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

class KPrimaryButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var configuration = KTheme.shared.kPrimaryButtonConfiguration
    
    func setup() {
        layer.cornerRadius = configuration.cornerRadius
        layer.masksToBounds = true
        layer.borderColor = configuration.borderColor.cgColor
        layer.borderWidth = configuration.borderWidth
        backgroundColor = configuration.backgroundColor
        setTitleColor(configuration.highlightedTextColor, for: .highlighted)
        setTitleColor(configuration.textColor, for: .normal)
        titleLabel?.font = configuration.font
    }
    
    struct KPrimaryButtonConfiguration {
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let backgroundColor: UIColor
        let textColor: UIColor
        let highlightedTextColor: UIColor
        let borderColor: UIColor
        let font: UIFont
    }
}


