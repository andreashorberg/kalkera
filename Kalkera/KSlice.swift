//
//  KSlice.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2019-03-19.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import UIKit

struct KSlice {
    let image: UIImage
    let position: KSlicePosition
}

enum KSlicePosition: Int {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
