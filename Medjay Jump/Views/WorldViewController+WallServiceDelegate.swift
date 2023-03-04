//
//  WorldViewController+WallServiceDelegate.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import UIKit

extension WorldViewController: WallServiceDelegate {
    func wallService(_ wallService: WallService, didCreate column: [UIImageView]) {
        guard let player = playerService.player else { return }
        var items = [player]
        column.forEach { items.append($0) }
        
        let collision = UICollisionBehavior(items: items)
        collision.collisionDelegate = self
        collision.collisionMode = .items
        
        for wall in column {
            collision.addBoundary(withIdentifier: "Wall" as NSCopying, for: UIBezierPath(rect: wall.frame))
        }
        
        animator?.addBehavior(collision)
    }
    
    func wallService(_ wallService: WallService, didDestroy column: [UIImageView]) {
        score += 1
    }
}
