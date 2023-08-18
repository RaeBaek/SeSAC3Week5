//
//  LottoManager.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/08/17.
//

import UIKit
import Alamofire

class LottoManager {
    
    static let shared = LottoManager()
    
    func callLotto(completionHandler: @escaping (Int, Int) -> Void) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1080"
        
        // 통신 / 응답
        AF.request(url, method: .get).validate()
            .responseDecodable(of: Lotto.self) { response in
                guard let value = response.value else { return }
                print("responseDecodable:", value)
                print(value.bnusNo, value.drwtNo1)
                
                completionHandler(value.bnusNo, value.drwtNo3)
            }
    }
    
}
