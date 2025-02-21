//
//  File.swift
//  SpinSolve360
//
//  Created by 林　一貴 on 2025/02/22.
//

import Foundation

class ARViewModel:NSObject,ObservableObject{
    var coordinator:ARViewContainer.Coordinator?
    @MainActor func compareNumber(){
        coordinator?.dop()
    }
}
