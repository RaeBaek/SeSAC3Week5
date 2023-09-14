//
//  LottoViewController.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/09/13.
//

import UIKit

class LottoViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel = LottoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.fetchLottoAPI(drwNo: 1083)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.viewModel.fetchLottoAPI(drwNo: 1084)
        }
        
        bindData()
    }
    
    func bindData() {
        
        viewModel.number1.bind { value in
            self.label1.text = "첫번째 당첨 번호: \(value)"
        }
        
        viewModel.number2.bind { value in
            self.label2.text = "두번째 당첨 번호: \(value)"
        }
        
        viewModel.number3.bind { value in
            self.label3.text = "세번째 당첨 번호: \(value)"
        }
        
        viewModel.number4.bind { value in
            self.label4.text = "네번째 당첨 번호: \(value)"
        }
        
        viewModel.number5.bind { value in
            self.label5.text = "다섯번째 당첨 번호: \(value)"
        }
        
        viewModel.number6.bind { value in
            self.label6.text = "여섯번째 당첨 번호: \(value)"
        }
        
        viewModel.number7.bind { value in
            self.label7.text = "보너스 당첨 번호: \(value)"
        }
        
        viewModel.lottoMoney.bind { money in
            self.dateLabel.text = "총 상금 \(money)원"
        }
    }
    
    
}
