//
//  CatImgCVC.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//


import UIKit

class CatImgCVC: UICollectionViewCell {
    
    // 좋아요(즐겨찾기) 기능 구현하기위한 변수 선언
    var isFavorite: Bool = false
    
    // 네트워크 통신을 통해 데이터 받을 배열 생성
    var networkManager = NetworkManager.shared
    
    // 네트워크 통신을 통해 즐겨찾기를 담을 빈배열 생성
    var postCatList: [Image] = []
    
    // MARK: - Property
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    
    var id : String? {
        didSet {
            print(#fileID, #function, #line, "- id: \(self.id)")
        }
    }
    
    // 이미지 URL 스트링값을 전달
    var imageUrlString: String? {
        didSet {
            // 쎌의 UI설정
            loadImg()
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 🍎 쎌의 이미지 UI설정
        self.mainImg.layer.cornerRadius = 12
        self.mainImg.layer.borderWidth = 1
        self.mainImg.layer.borderColor = UIColor.gray.cgColor
    }
    
    // indexPath로 하트 버튼을 눌르면 불러올 함수
    func setData(_ cellData: CatGetModel){
        self.imageUrlString = cellData.url
        self.id = cellData.id
    }
    
    
    // 하트 버튼을 눌르면 즐겨찾기 목록에 추가되는 기능 구현해야한다
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        // 프로퍼티 id 언래핑
        guard let id = id else { return }
        print("heartButtonTapped : id : \(id)")
        
        // 하트버튼을 눌르면 컬러 체인지
        if isFavorite {
            isFavorite = false
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            // api 즐겨찾기 터트리기
        } else {
            isFavorite = true
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            // 좋아요 버튼을 눌르면 즐겨찾기 탭바인 Favorite탭바 VC 의 콜렉션뷰 쎌에 이미지 띄우기
        }
    }
    
    // 좋아요 버튼을 눌르면 즐겨찾기VC CollectionViewCell 에 이미지 띄우기
    @objc func button() {
        print("하트 버튼이 눌렸음")
        let vc = CatFavoriteCVC()
        mainImg = vc.mainImage
    }
    
    // 이미지 주소를 다운받고
    private func loadImg() {
        guard let urlString = self.imageUrlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            // ⭐️⭐️오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImg.image = UIImage(data: data)
                
            }
        }
    }
}
