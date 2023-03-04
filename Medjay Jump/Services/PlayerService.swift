//
//  PlayerService.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum PlayerConstants {
    static let WIDTH: CGFloat = 150
    static let HEIGHT: CGFloat = 150
    static let INSET: CGFloat = 20
}

protocol PlayerServiceDelegate: UICollisionBehaviorDelegate {
    var view: UIView! { get }
    var animator: UIDynamicAnimator? { get }
}

final class PlayerService {

    private let delegate: PlayerServiceDelegate
    
    var player: UIImageView!
        
    init(delegate: PlayerServiceDelegate) {
        self.delegate = delegate
    }
    
    func setup() {
        player = makePlayer()
        delegate.view.addSubview(player)
        
        let behavior = makeBehavior(for: player)
        let gravity = makeGravity(for: player)
        let collision = makeCollision(for: player)
        
        delegate.animator?.addBehavior(behavior)
        delegate.animator?.addBehavior(gravity)
        delegate.animator?.addBehavior(collision)
    }
    
    func destroy() {
        player.removeFromSuperview()
        player = nil
    }
    
    func jump() {
        let push = UIPushBehavior(items: [player], mode: .instantaneous)
        push.pushDirection = CGVector(dx: 0, dy: -1)
        push.magnitude = (PlayerConstants.HEIGHT + PlayerConstants.WIDTH) / 2 * 0.075
        delegate.animator?.addBehavior(push)
    }
    
    private func makePlayer() -> UIImageView {
        let image = UIImage(named: "PlayerIcon")
        let rect = CGRect(x: PlayerConstants.INSET, y: (delegate.view.frame.height - PlayerConstants.HEIGHT) / 2, width: PlayerConstants.WIDTH, height: PlayerConstants.HEIGHT)
        let imageView = UIImageView(frame: rect)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        return imageView
    }
    
    private func makeBehavior(for imageView: UIImageView) -> UIDynamicBehavior {
        let behavior = UIDynamicItemBehavior(items: [imageView])
        behavior.elasticity = 0.5
        return behavior
    }
    
    private func makeGravity(for imageView: UIImageView) -> UIGravityBehavior {
        let gravity = UIGravityBehavior(items: [imageView])
        gravity.magnitude = 1
        return gravity
    }
    
    private func makeCollision(for imageView: UIImageView) -> UICollisionBehavior {
        let collision = UICollisionBehavior(items: [imageView])
        collision.collisionDelegate = delegate
        collision.collisionMode = .boundaries
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }
}
