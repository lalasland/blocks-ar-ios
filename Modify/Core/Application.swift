//
//  Application.swift
//  Modify
//
//  Created by Alex Shevlyakov on 31/08/2017.
//  Copyright © 2017 Envent. All rights reserved.
//

import Foundation
import ARKit
import CoreLocation
import PromiseKit

public final class Application {
    
    enum LocationAccuracyState {
        case poor
        case good
    }
    
    private static let _shared = Application()
    public static var shared: Application {
        return _shared
    }
    
    var state: Application.LocationAccuracyState = .poor {
        willSet(newState) {
            guard newState != state else { return }
            switch newState {
            case .poor: NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ApplicationLocationAccuracyDidChange"), object: nil, userInfo: ["current": Application.LocationAccuracyState.poor]))
            case .good: NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ApplicationLocationAccuracyDidChange"), object: nil, userInfo: ["current": Application.LocationAccuracyState.good]))
            }
        }
    }
    
    var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    var locationHorizontalAccuracy: CLLocationAccuracy = -1 { didSet { adjustifyLocationAccuracyState() } }
    var locationVerticalAccuracy:   CLLocationAccuracy = -1 { didSet { adjustifyLocationAccuracyState() } }
    
    private func adjustifyLocationAccuracyState() {
        state = (0...10 ~= locationHorizontalAccuracy && 0...5 ~= locationVerticalAccuracy) ? .good : .poor
    }
    
    static let socket = Socket(socketUrl: Api.socketURL, token: Account.shared.accessToken)
    
    enum ConnectionStatus {
        case connected
        case error(Error)
        case disconnected
    }
    
    enum ConnectionError: Error {
        case loginNeeded
    }
    
    var connectionStatus = ConnectionStatus.disconnected

    private init() {}
}

extension Application {
    
    func connect() {
        establishSocketConnection()
        .then {
            self.connectionStatus = .connected
        }.catch { error in
            self.connectionStatus = .error(error)
            if case ConnectionError.loginNeeded = error {
                Account.shared.login().then { self.connect() }
            }
        }
    }

    private func establishSocketConnection() -> Promise<Void> {
        guard let token = Account.shared.info.token, token != "" else {
//            throw ConnectionError.loginNeeded
            return Promise<Void>()
        }
        let socket = Application.socket
        socket.token = token
        return socket.connect()
    }
    
    func disconnect() {
        Application.socket.disconnect()
    }
    
}
