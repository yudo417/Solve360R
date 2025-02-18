//
//  File.swift
//  SpinSolve360
//
//  Created by 林　一貴 on 2025/02/19.
//

//
//  PuzzleGenerator.swift
//  ARKitView1
//
//  Created by Hayashi on 2025/01/12.
//

import Foundation

struct ExclusiveRangeConstraint {
    let lower: Int
    let upper: Int

    //引数がこの不等式満たすん？
    func contains(_ x: Int) -> Bool {
        return (lower < x && x < upper)
    }
}

final class PuzzleGenerator {

    // (a, b) の候補一覧を全乗せ
    private let allConstraints: [ExclusiveRangeConstraint]

    init() {
        var list: [ExclusiveRangeConstraint] = []
        //範囲をなさない不等式も全部入れておく
        for a in 0...9 {
            for b in (a+1)...10 {
                list.append(ExclusiveRangeConstraint(lower: a, upper: b))
            }
        }
        self.allConstraints = list
    }

    func generateExclusivePuzzle() -> ([ExclusiveRangeConstraint], Int) {
        while true {
            //最終的な解をsとしてランダムでなんかを解にしとく
            let s = Int.random(in: 1...9)
            //sを含む不等式を全てフィルターしとく
            let candidateConstraints = allConstraints.filter { $0.contains(s) }
            //そのうちからランダムで4つ選んで後に審査かける（問題に採用される可能性あり）
            var constraints: [ExclusiveRangeConstraint] = []
            for _ in 1...4 {
                constraints.append(candidateConstraints.randomElement()!)
            }
            //s以外の1~9つっこんで4本の不等式全部を満たすとアウトでsatisfiesAllをtrueに変えてwhileループで再抽選
            var unique = true
            for x in 1...9 where x != s {
                let satisfiesAll = constraints.allSatisfy { $0.contains(x) }
                if satisfiesAll {
                    unique = false
                    break
                }
            }

            if unique {
                return (constraints, s)//不等式の配列、最終的な解
            }
        }
    }
}

