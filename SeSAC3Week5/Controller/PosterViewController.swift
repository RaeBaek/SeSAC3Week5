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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        LottoManager.shared.callLotto { bonus, no3 in
        //            print("클로저로 꺼내온 값: \(bonus), \(no3)")
        //        }
        
        configureCollectionView()
        configureCollectionViewLayout()
        
        callRecommendation(id: 157336) { data in
            self.list = data
            self.posterCollectionView.reloadData()
        }
        
        callRecommendation(id: 299534) { data in
            self.secondList = data
            self.posterCollectionView.reloadData()
        }
        
        callRecommendation(id: 518963) { data in
            self.thirdList = data
            self.posterCollectionView.reloadData()
        }
        
        callRecommendation(id: 293413) { data in
            self.fourthList = data
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
            return list.results.count
        } else if section == 1 {
            return secondList.results.count
        } else if section == 2 {
            return thirdList.results.count
        } else if section == 3 {
            return fourthList.results.count
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(list.results[indexPath.row].posterPath ?? "")"
            let url = URL(string: imageURL)
            cell.posterImageView.kf.setImage(with: url)
        } else if indexPath.section == 1 {
            let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(secondList.results[indexPath.row].posterPath ?? "")"
            let url = URL(string: imageURL)
            cell.posterImageView.kf.setImage(with: url)
        } else if indexPath.section == 2 {
            let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(thirdList.results[indexPath.row].posterPath ?? "")"
            let url = URL(string: imageURL)
            cell.posterImageView.kf.setImage(with: url)
        } else if indexPath.section == 3 {
            let imageURL = "https://www.themoviedb.org/t/p/w220_and_h330_face\(fourthList.results[indexPath.row].posterPath ?? "")"
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


