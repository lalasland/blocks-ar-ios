//
//  ARViewController+HUD.swift
//  Modify
//
//  Created by Alex Shevlyakov on 31.08.17.
//  Copyright © 2017 Envent. All rights reserved.
//

import Foundation

extension ARViewController: HUDViewControllerDelegate {
    
    func hudAddObjectPressed() {
        addArtifact(named: "rainbow")
    }
    
    func hudPlaceObjectPressed() {
        if case .placing(let object) = placeState {
            let t = object.node.worldTransform
            object.node.removeFromParentNode()
            object.node.transform = t
            saveArtifact(artifactNode: object)
            placeState = .none
        }
    }
    
    func hudPlaceObjectCancelled() {
        if case .placing(let object) = placeState {
            object.node.removeFromParentNode()
            placeState = .none
        }
    }
    
    func hudStopAdjustingNodesPosition() {
        sceneLocationView.locationManager.locationManager?.stopUpdatingLocation()
        sceneLocationView.locationManager.locationManager?.stopUpdatingHeading()
//        sceneLocationView.locationNodes.forEach {
//            $0.continuallyUpdatePositionAndScale = false
//        }
    }
    
    func hudStartAdjustingNodesPosition() {
        sceneLocationView.locationManager.locationManager?.startUpdatingLocation()
        sceneLocationView.locationManager.locationManager?.startUpdatingHeading()
//        sceneLocationView.locationNodes.forEach {
//            $0.continuallyUpdatePositionAndScale = true
//        }
    }
}
