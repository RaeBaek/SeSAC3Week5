//
//  LottoViewModel.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/09/13.
//

import Foundation

class LottoViewModel {
    
    var number1 = Observable(0)
    var number2 = Observable(0)
    var number3 = Observable(0)
    var number4 = Observable(0)
    var number5 = Observable(0)
    var number6 = Observable(0)
    var number7 = Observable(0)
    var lottoMoney = Observable("0")
    
    func format(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        
        guard let result = numberFormat.string(for: number) else { return "오류!"}
        
        return result
    }
    
    func fetchLottoAPI(drwNo: Int) {
        LottoManager.shared.callLotto(drwNo: drwNo) { lotto in
            
            self.number1.value = lotto.drwtNo1
            self.number2.value = lotto.drwtNo2
            self.number3.value = lotto.drwtNo3
            self.number4.value = lotto.drwtNo4
            self.number5.value = lotto.drwtNo5
            self.number6.value = lotto.drwtNo6
            self.number7.value = lotto.bnusNo
            self.lottoMoney.value = self.format(for: lotto.totSellamnt)
            
        }
    }
    
}
