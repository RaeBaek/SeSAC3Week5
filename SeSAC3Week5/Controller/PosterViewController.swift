//
//  PosterViewController.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/08/16.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

protocol CollectionViewAttributeProtocol {
    func configureCollectionView()
    func configureCollectionViewLayout()
}

class PosterViewController: UIViewController {
    
    @IBOutlet var posterCollectionView: UICollectionView!
    
    var list: Recommendation = Recommendation(page: 0, results: [], totalPages: 0, totalResults: 0)
    var secondList: Recommendation = Recommendation(page: 0, results: [], totalPages: 0, totalResults: 0)
    var thirdList: Recommendation = Recommendation(page: 0, results: [], totalPages: 0, totalResults: 0)
    var fourthList: Recommendation = Recommendation(page: 0, results: [], totalPages: 0, totalResults: 0)
    
    var listList: [Recommendation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        LottoManager.shared.callLotto { bonus, no3 in
        //            print("클로저로 꺼내온 값: \(bonus), \(no3)")
        //        }
        
        configureCollectionView()
        configureCollectionViewLayout()
        dispatchGroupEnterLeave()
        let id = [299534, 157336, 518963, 293413]
        
        let group = DispatchGroup()
        
        for item in id {
            group.enter()
            callRecommendation(id: item) { data in
                //2차원 배열을 활용했으니 cell 부분도 건드릴것
                self.list = data
                self.listList.append(self.list)
                print(self.listList)
                print("냐냐냐")
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("END!!!!")
            print(self.listList[0].results[0].title)
            print(self.listList[1].results[0].title)
            print(self.listList[2].results[0].title)
            print(self.listList[3].results[0].title)
            self.posterCollectionView.reloadData()
        }
        
    }
    
    @IBAction func sendNotification(_ sender: UIButton) {
        
        // 포그라운드에서 알림이 안뜨는게 디폴트!!
        
        //1. 컨텐츠
        //2. 언제?
        // 알림 보내기
        let content = UNMutableNotificationContent()
        content.title = "다마고치에게 물을 주세요."
        content.body = "5초지났다잉"
        content.badge = 100
        
        // 반복을 true로 설정하면 알림의 최소 시간은 60초다!
        // 반대로 반복을 false로 설정하면 최소 시간은 상관없다.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            print(error)
        }
        
    }
    
    
    // dispatchGroupEnterLeave
    func dispatchGroupEnterLeave() {
        let group = DispatchGroup()
        
        group.enter() // +1
        callRecommendation(id: 157336) { data in
            self.list = data
            print("===1===")
            group.leave()
        }
        print("ㅎㅇㅎㅇ")
        
        group.enter()
        callRecommendation(id: 299534) { data in
            self.secondList = data
            print("===2===")
            group.leave()
        }
        
        group.enter()
        callRecommendation(id: 518963) { data in
            self.thirdList = data
            print("===3===")
            group.leave()
        }
        
        group.enter()
        callRecommendation(id: 293413) { data in
            self.fourthList = data
            print("===4===")
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("END!!!")
            self.posterCollectionView.reloadData()
        }
    }
    
    // dispatchGroupNotify
    func dispatchGroupNotify() {
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            self.callRecommendation(id: 157336) { data in
                self.list = data
                print("===1===")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.callRecommendation(id: 299534) { data in
                self.list = data
                print("===2===")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.callRecommendation(id: 518963) { data in
                self.list = data
                print("===3===")
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.callRecommendation(id: 293413) { data in
                self.list = data
                print("===4===")
            }
        }
        
        group.notify(queue: .main) {
            print("END!")
            self.posterCollectionView.reloadData()
        }
    }
    
    // 어벤져스 엔드게임: 299534 / 인터스텔라: 157336 / 독전: 518963 / 내부자들: 293413
    func callRecommendation(id: Int, completionHandler: @escaping (Recommendation) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(Key.tmdbKey)&language=ko-KR"
        
        AF.request(url, method: .get).validate(statusCode: 200...500)
            .responseDecodable(of: Recommendation.self) { response in
                
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                    
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert(title: "테스트 얼럿", message: "테스트입니다.", button: "배경색 변경") {
            print("배경색 변경 버튼을 클릭했습니다.")
            self.posterCollectionView.backgroundColor = .lightGray
            
        }
        print("AAA")
    }
    
}

extension PosterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return self.list.results.count
        } else if section == 1 {
            return self.list.results.count
        } else if section == 2 {
            return self.list.results.count
        } else if section == 3 {
            return self.list.results.count
        } else {
            return 9
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
            if indexPath.section == 0 {
                let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(self.list.results[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageURL)
                cell.posterImageView.kf.setImage(with: url)
            } else if indexPath.section == 1 {
                let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(self.list.results[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageURL)
                cell.posterImageView.kf.setImage(with: url)
            } else if indexPath.section == 2 {
                let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(self.list.results[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageURL)
                cell.posterImageView.kf.setImage(with: url)
            } else if indexPath.section == 3 {
                let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(self.list.results[indexPath.row].posterPath ?? "")"
                let url = URL(string: imageURL)
                cell.posterImageView.kf.setImage(with: url)
            }
        
        
        cell.posterImageView.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderPosterCollectionReusableView.identifier, for: indexPath) as? HeaderPosterCollectionReusableView else { return UICollectionReusableView() }
            
            view.titleLabel.text = "테스트 섹션"
            view.titleLabel.font = UIFont(name: "GmarketSansBold", size: 20)
            
            return view
        } else {
            return UICollectionReusableView()
        }
        
    }
}

// extension Protocol
// 프로토콜 채택
extension PosterViewController: CollectionViewAttributeProtocol {
    
    func configureCollectionView() {
        // Protocol as Type
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
        posterCollectionView.register(UINib(nibName: PosterCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        posterCollectionView.register(UINib(nibName:HeaderPosterCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderPosterCollectionReusableView.identifier)
        
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        //헤더 사이즈
        layout.headerReferenceSize = CGSize(width: 300, height: 50)
        
        posterCollectionView.collectionViewLayout = layout
    }
    
}

//protocol Test {
//    func test()
//}
//
//class A: Test {
//    func test() {
//        <#code#>
//    }
//}
//
//class B: Test {
//    func test() {
//        <#code#>
//    }
//}
//
//class C: A {
//
//}
//
//// 프로토콜은 타입의 기능을 가질 수 있다.
//let example: Test = B()
//
//let value: A = C()


