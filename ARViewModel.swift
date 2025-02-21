//
//  File.swift
//  SpinSolve360
//
//  Created by 林　一貴 on 2025/02/22.
//

import Foundation

class ARViewModel:NSObject,ObservableObject{
    var coordinator:ARViewContainer.Coordinator?
    @Published var generatedAnswer: Int = 0

    @MainActor func compareNumber(){
        coordinator?.dop()
    }
}
