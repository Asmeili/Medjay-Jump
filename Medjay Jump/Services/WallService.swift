//
//  WallService.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//


import Foundation
import UIKit

fileprivate enum WallConstants {
    static let WIDTH: CGFloat = 75
    static let SCREEN_PADDING: CGFloat = 50
}

protocol WallServiceDelegate {
    var view: UIView! { get }
    var animator: UIDynamicAnimator? { get }
    
    func wallService(_ wallService: WallService, didCreate column: [UIImageView]) -> Void
    
    func wallService(_ wallService: WallService, didDestroy column: [UIImageView]) -> Void
}

final class WallService {

    private let delegate: WallServiceDelegate
    private let gameService: GameService

    private var walls: [[UIImageView]]
    
    init(delegate: WallServiceDelegate, gameService: GameService) {
        self.delegate = delegate
        self.gameService = gameService
        self.walls = []
    }
    
    func setup() {
        gameService.loop {
            for column in self.walls {
                var wallsOffScreenCount = 0
                for wall in column {
                    if wall.frame.minX < -WallConstants.SCREEN_PADDING {
                        wallsOffScreenCount += 1
                    }
                }
                
                guard wallsOffScreenCount == 2 else { continue }
                guard let index = self.walls.firstIndex(of: column) else { continue }
                for wall in column {
                    wall.removeFromSuperview()
                }
                self.walls.remove(at: index)
                self.delegate.wallService(self, didDestroy: column)
                
                let newColumn = self.makeColumn()
                self.walls.append(newColumn)
            }
        }
        
        let initialColumn = makeColumn()
        walls.append(initialColumn)
    }
    
    func destroy() {
        walls.forEach {
            $0.forEach { $0.removeFromSuperview() }
        }
        walls = []
    }
    
    private func makeColumn() -> [UIImageView] {
        let topWall = makeWall(CGFloat(Int.random(in: 50...300)), at: .top)
        let bottomWall = makeWall(CGFloat(Int.random(in: 50...300)), at: .bottom)
        
        delegate.view.addSubview(topWall)
        delegate.view.addSubview(bottomWall)
        
        let column = [topWall, bottomWall]
        let push = makePush(for: column)
        let collision = makeCollision(for: column)
        
        delegate.animator?.addBehavior(push)
        delegate.animator?.addBehavior(collision)
        
        delegate.wallService(self, didCreate: column)
        return column
    }
    
    private enum WallPosition {
        case top
        case bottom
    }
    
    private func makeWall(_ height: CGFloat, at position: WallPosition) -> UIImageView {
        let imageName = getImageName(for: position)
        let image = UIImage(named: imageName)
        
        let yPosition = getYPosition(for: position, with: height)
        let rect = CGRect(x: delegate.view.frame.width + WallConstants.SCREEN_PADDING, y: yPosition, width: WallConstants.WIDTH, height: height)
        let imageView = UIImageView(frame: rect)
        
        imageView.contentMode = .scaleToFill
        imageView.image = image
        
        return imageView
    }
    
    private func getImageName(for position: WallPosition) -> String {
        switch position {
        case .top:
            return "WallBottomIcon" // return "WallTopIcon"
        case .bottom:
            return "WallBottomIcon"
        }
    }
    
    private func getYPosition(for position: WallPosition, with height: CGFloat) -> CGFloat {
        switch position {
        case .bottom:
            return delegate.view.frame.height - height
        case .top:
            return 0
        }
    }
    
    private func makePush(for imageViews: [UIImageView]) -> UIPushBehavior {
        let push = UIPushBehavior(items: imageViews, mode: .continuous)
        push.pushDirection = CGVector(dx: -1, dy: 0)
        push.magnitude = 5
        return push
    }
    
    private func makeCollision(for imageViews: [UIImageView]) -> UICollisionBehavior {
        let collision = UICollisionBehavior(items: imageViews)
        collision.collisionMode = .items
        for imageView in imageViews {
            collision.addBoundary(withIdentifier: "Wall" as NSCopying, for: UIBezierPath(rect: imageView.frame))
        }
        return collision
    }
}
