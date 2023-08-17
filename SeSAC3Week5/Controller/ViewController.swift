//
//  ViewController.swift
//  SeSAC3Week5
//
//  Created by jack on 2023/08/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var syncButton: UIButton!
    @IBOutlet var asyncButton: UIButton!
    @IBOutlet var groupButton: UIButton!
    
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    @IBOutlet var fourthImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncButton.addTarget(self, action: #selector(syncButtonClicked), for: .touchUpInside)
        asyncButton.addTarget(self, action: #selector(asyncButtonClicked), for: .touchUpInside)
        //        groupButton.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
        
        
    }
    
    @objc func syncButtonClicked() {
        print("sync start")
        downloadImage(imageView: firstImageView, value: "first")
        downloadImage(imageView: secondImageView, value: "second")
        downloadImage(imageView: thirdImageView, value: "third")
        downloadImage(imageView: fourthImageView, value: "fourth")
        print("sync end") // 동기, 순서대로 실행, 끝나는 지점 알 수 있음
        
    }
    
    func downloadImage(imageView: UIImageView, value: String) {
        
        print("===1===\(value)===")
        let data = try! Data(contentsOf: Nasa.photo)
        imageView.image = UIImage(data: data)
        print("===2===\(value)===")
        
    }
    
    @objc func asyncButtonClicked() {
        print("async start")
        asyncDownloadImage(imageView: firstImageView, value: "first")
//        asyncDownloadImage(imageView: secondImageView, value: "second")
//        asyncDownloadImage(imageView: thirdImageView, value: "third")
//        asyncDownloadImage(imageView: fourthImageView, value: "fourth")
        print("async end")
    }
    
    // 일단 다른 알바생에게 작업을 보내고 나머지 실행.
    // 작업이 언제 끝나는 지 정확한 시점을 알기 어렵다.
    // UI는 메인 쓰레드(닭벼슬)에서 해야 한다!
    func asyncDownloadImage(imageView: UIImageView, value: String) {
        
        print("===\(value)===1===", Thread.isMainThread)
        
        DispatchQueue.global().async {
            
            print("===\(value)===2-1===", Thread.isMainThread)
            let data = try! Data(contentsOf: Nasa.photo)
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
                print("===\(value)===2-2===", Thread.isMainThread)
            }
            
            print("===\(value)===2-3===", Thread.isMainThread)
            
        }
        
        print("===\(value)===3===", Thread.isMainThread)
        
    }
    
}

extension ViewController: CollectionViewAttributeProtocol {
    func configureCollectionView() {
        
    }
    
    func configureCollectionViewLayout() {
        
    }
    
    
}
