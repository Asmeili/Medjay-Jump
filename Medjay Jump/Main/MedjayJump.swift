//
//  MedjayJump.swift
//  Medjay Jump
//
//  Created by Michael Artes on 03.03.23.
//  Copyright © 2023 Michael Artes. All rights reserved.
//

import Foundation
import UIKit

final class MedjayJump {
    
    // MARK: World View
    
    static func instantiateWorldViewController() -> WorldViewController {
        let bundle = Bundle(for: WorldViewController.self)
        let storyboard = UIStoryboard(name: "WorldView", bundle: bundle)
        let worldViewController = storyboard.instantiateViewController(withIdentifier: "WorldViewController") as! WorldViewController
        return worldViewController
    }
    
}
