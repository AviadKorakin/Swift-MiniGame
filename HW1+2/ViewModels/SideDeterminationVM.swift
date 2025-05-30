//  SideDeterminationVM.swift
//  HW1+2
//
//  Created by Aviad on 25/05/2025.

import SwiftUI
import Combine

class SideDeterminationVM: ObservableObject {
    @AppStorage("playerName") var playerName = ""
    @Published var tempName = ""
    @Published var currentLatitude: Double?
    @Published private(set) var side = ""
    
    private let midpoint = 34.817549168324334
    private var locManager = LocationManager()

    var hasName: Bool { !playerName.isEmpty }
    var isReady: Bool { hasName && side != "" }
    
    /// Returns the correct earth image asset based on local time (day vs night)
    var earthImageName: String {
     return "EarthImage"
    }

    func saveName() {
        guard !tempName.isEmpty else { return }
        playerName = tempName
    }

    func requestLocation() {
        locManager.delegate = self
        locManager.requestLocation()
    }
}

extension SideDeterminationVM: LocationManagerDelegate {
    func didUpdate(latitude: Double) {
        currentLatitude = latitude
        side = (latitude > midpoint) ? "East" : "West"
        locManager.stopUpdates()
    }
}
