//
//  CodableViewController.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/08/16.
//

import UIKit
import Alamofire

// MARK: - Lotto
struct Lotto: Codable {
    let totSellamnt: Int
    let returnValue, drwNoDate: String
    let firstWinamnt, drwtNo6, drwtNo4, firstPrzwnerCo: Int
    let drwtNo5, bnusNo, firstAccumamnt, drwNo: Int
    let drwtNo2, drwtNo3, drwtNo1: Int
}

// MARK: - Translation
struct Translation: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let service, version: String
    let result: Result
    let type: String

    enum CodingKeys: String, CodingKey {
        case service = "@service"
        case version = "@version"
        case result
        case type = "@type"
    }
}

// MARK: - Result
struct Result: Codable {
    let engineType, tarLangType, translatedText, srcLangType: String
}

// 컴파일 시 오류 타입 알 수 있음
enum ValidationError: Error {
    case emptyString
    case isNotInt
    case isNotDate
}

class CodableViewController: UIViewController {

    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humiLabel: UILabel!
    
    var resultText = "Apple"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherManager.shared.callRequestCodable { data in
            self.tempLabel.text = "\(data.main.temp)"
        } failure: {
            print("show Alert")
        }

        
        WeatherManager.shared.callRequestString { temp, humi in
            self.tempLabel.text = temp
            self.humiLabel.text = humi
        }
        
        WeatherManager.shared.callRequestJSON { json in
            let temp = json["main"]["temp"].doubleValue - 273.15
            let humi = json["main"]["humidity"].doubleValue
            
            self.tempLabel.text = "\(temp)"
            self.humiLabel.text = "\(humi)"
        }
    
    }
    
    func validateUserInputError(text: String) throws -> Bool {
        
        guard !(text.isEmpty) else {
            print("빈 값")
            throw ValidationError.emptyString
        }
    
        // 숫자 여부
        guard Int(text) != nil else {
            print("숫자아님")
            throw ValidationError.isNotInt
        }
        
        // 날짜 형식으로 변환이 되는 지
        guard checkDateFormat(text: text) else {
            print("잘못된 날짜 형식")
            throw ValidationError.isNotDate
        }
        return true
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        
        guard let text = dateTextField.text else { return }
        
        do {
            let result = try validateUserInputError(text: text)
        } catch {
            print("ERROR")
        }
        
//        if validateUserInput(text: text) {
//            print("검색 가능. 네트워크 요청 가능.")
//        } else {
//            print("검색 불가")
//        }
    }
    
    func validateUserInput(text: String) -> Bool {
        
        guard !(text.isEmpty) else {
            print("빈 값")
            return false
        }
    
        // 숫자 여부
        guard Int(text) != nil else {
            print("숫자아님")
            return false
        }
        
        // 날짜 형식으로 변환이 되는 지
        guard checkDateFormat(text: text) else {
            print("잘못된 날짜 형식")
            return false
        }
        return true
    }
    
    
    func checkDateFormat(text: String) -> Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        let result = format.date(from: text)
        
        return result == nil ? false : true
        
    }
    
//    func fetchTranslateData(source: String, target: String, text: String) {
//
//        print("fetchTranslateData", source, target, text)
//
//        let url = "https://openapi.naver.com/v1/papago/n2mt"
//        let header: HTTPHeaders = [
//            "X-Naver-Client-Id": Key.clientID,
//            "X-Naver-Client-Secret": Key.clientSecret
//        ]
//        let parameters: Parameters = [
//            "source": source,
//            "target": target,
//            "text": text
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, headers: header)
//            .validate(statusCode: 200...500)
//            .responseDecodable(of: Translation.self) { response in
////                print(response)
//                guard let value = response.value else { return }
////                print(value)
//                print(value.message.result.translatedText)
//
//                self.resultText = value.message.result.translatedText
//                print("획인:", self.resultText)
//
//                self.fetchTranslate(source: "en", target: "ko", text: self.resultText)
//
//            }
//
//    }
    
//    func fetchTranslate(source: String, target: String, text: String) {
//
//        print("fetchTranslateData", source, target, text)
//
//        let url = "https://openapi.naver.com/v1/papago/n2mt"
//        let header: HTTPHeaders = [
//            "X-Naver-Client-Id": Key.clientID,
//            "X-Naver-Client-Secret": Key.clientSecret
//        ]
//        let parameters: Parameters = [
//            "source": source,
//            "target": target,
//            "text": text
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, headers: header)
//            .validate(statusCode: 200...500)
//            .responseDecodable(of: Translation.self) { response in
////                print(response)
//                guard let value = response.value else { return }
////                print(value)
//                print(value.message.result.translatedText)
//
//                self.resultText = value.message.result.translatedText
//                print("최종 획인:", self.resultText)
//
//            }
//
//    }
    
//    func fetchLottoData() {
//        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1080"
//
//        DispatchQueue.global().async {
//            AF.request(url, method: .get).validate()
//                .responseData { response in
//                    guard let value = response.value else { return }
//                    print("responseData:", value)
//
//                    DispatchQueue.main.async {
//                        // 레이블에 숫자 출력하기
//                    }
//
//                }
//        }
//
//        AF.request(url, method: .get).validate()
//            .responseString { response in
//                guard let value = response.value else { return }
//                print("responseString:", value)
//            }
//
//        AF.request(url, method: .get).validate()
//            .response { response in
//                guard let value = response.value else { return }
//                print("response:", value)
//            }
//
//        AF.request(url, method: .get).validate()
//            .responseDecodable(of: Lotto.self) { response in
//                guard let value = response.value else { return }
//                print("responseDecodable:", value)
//                print(value.bnusNo, value.drwtNo1)
//            }
//
//    }

}
