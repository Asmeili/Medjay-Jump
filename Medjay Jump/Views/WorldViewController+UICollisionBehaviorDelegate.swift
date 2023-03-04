//
//  WorldViewController+UICollisionBehaviorDelegate.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import UIKit

extension WorldViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if (item as? UIImageView) == playerService.player {
            animator = nil
            displayDeathMessage(with: score)
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if (item1 as? UIImageView) == playerService.player || (item2 as? UIImageView) == playerService.player {
            animator = nil
            displayDeathMessage(with: score)
        }
    }
}
