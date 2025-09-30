

import Foundation

struct ExclusiveRangeConstraint {
    let lower: Int
    let upper: Int

    //引数がこの不等式満たすん？
    func contains(_ x: Int) -> Bool {
        return (lower < x && x < upper)
    }
}

 class FomulaGenerate {

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

    func genefomula() -> ([ExclusiveRangeConstraint], Int) {
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
                print("生成完了")
                print("\(constraints[0].lower),\(constraints[0].upper)")
                print("\(constraints[1].lower),\(constraints[1].upper)")
                print("\(constraints[2].lower),\(constraints[2].upper)")
                print("\(constraints[3].lower),\(constraints[3].upper)")
                print("解は＝\(s)")
                return (constraints, s)//不等式の配列、最終的な解
            }
        }
    }
}

