//
//  CompactTabBar.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/7/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

class CompactTabBar: UITabBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 40
        return size
    }

}
