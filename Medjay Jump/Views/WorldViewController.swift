//
//  WorldViewController.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import UIKit

class WorldViewController: UIViewController, PlayerServiceDelegate {
    
    @IBOutlet private weak var scoreLabel: UILabel!
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    var animator: UIDynamicAnimator?
    var gameService: GameService!
    var playerService: PlayerService!
    var wallService: WallService!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        animator = UIDynamicAnimator(referenceView: view)
        
        gameService = GameService()
        gameService.setup()
        
        playerService = PlayerService(delegate: self)
        playerService.setup()
        
        wallService = WallService(delegate: self, gameService: gameService)
        wallService.setup()
        
        setupTapGestureRecognizer()
    }
    
    private func destroy() {
        if animator != nil {
            animator = nil
        }
        
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        wallService.destroy()
        wallService = nil
        
        playerService.destroy()
        playerService = nil
        
        gameService.destroy()
        gameService = nil
    }
    
    private func setupTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTap() {
        playerService.jump()
    }
    
    func displayDeathMessage(with score: Int) {
        self.score = 0

        let alert = UIAlertController(title: "Oof!", message: "You have died with a score of \(score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.destroy()
            alert.dismiss(animated: true) {
                self.setup()
            }
        })
        present(alert, animated: true)
    }
}
