//
//  CatFavoriteCVC.swift
//  CatDiary
//
//  Created by Hertz on 9/5/22.
//

import UIKit



class CatFavoriteCVC: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var id : String? {
        didSet {
            print(#fileID, #function, #line, "- id: \(self.id)")
        }
    }
    
    // 이미지 URL 스트링을 전달하면 스트링을 UIImage로 바꾸는 속성감시자
    var imageUrlString: String? {
        didSet {
            // 쎌의 UI설정
            loadImg()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 얼럿창을 통해 yes를 눌르면 즐겨찾기 네트워크통신을 통해 이미지의 id 와 url를 받을 주소
//    func setData(_ cellData: Image){
//        self.imageUrlString = cellData.imageUrl
//        self.id = cellData.id
//    }
    
    // 이미지 주소를 다운받고
    private func loadImg() {
        guard let urlString = self.imageUrlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            // ⭐️⭐️오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImage.image = UIImage(data: data)
                
            }
        }
    }
}
