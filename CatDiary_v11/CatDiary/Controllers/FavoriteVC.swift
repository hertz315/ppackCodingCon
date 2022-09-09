//
//  FavoriteVC.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import UIKit


class FavoriteVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 🍎네트워크 매니저 (싱글톤)
    var netWorkManager = NetworkManager.shared
    
    // 🍎 얼럿을 통해 즐겨찾기 이미지를 받을 곳
    var getCatFavoriteArray: [FavoriteCatModel] = []
    
    // MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        print(getCatFavoriteArray,"🍎")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func setupCollectionView() {
        // 델리게이트 위임 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        // 콜렉션뷰의 콜렉션뷰 레이아웃 설정
        collectionView.collectionViewLayout = createCompositionalLayout()
        // 콜렉션뷰 Width, Height를 유연하게 설정
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 🍎 Xib 컬렉션뷰 쎌 레지스터 등록
        let catFavorieCVC = UINib(nibName: "CatFavoriteCVC", bundle: nil)
        collectionView.register(catFavorieCVC, forCellWithReuseIdentifier: "CatFavoriteCVC")
    }

}

// MARK: - UICollectionViewDataSource
// 데이터와 관련된 것들
extension FavoriteVC: UICollectionViewDataSource {
    // 각 세션에 들어가는 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 네트워크 통신으로 받아온 데이터 배열의 count
        return getCatFavoriteArray.count
    }
    // 각 콜렉션 쎌에 대한 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImgCVC", for: indexPath) as! CatFavoriteCVC
        // 쎌에 네트워크 통신으로 받은 이미지주소 넘겨주기
        
        // 만약 쎌의 id 와 네트워크 통신을 통해 넘겨받은 id 가 같다면
        print(#function)
        
        return cell
    }
    
    
    
}

// MARK: - UICollectionViewDelegate
// 이벤트와 관련된 것
extension FavoriteVC: UICollectionViewDelegate {
    
}

// MARK: - 컬렉션뷰 컴포지셔널 레이아웃 관련
extension FavoriteVC {
    // 컴포지셔널레이아웃 설정
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        // 컴포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout {
            // 만들게 되면 튜플 (키: 값, 키: 값)의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            // 🍎 아이템이 모여 그룹을 만들고 그룹이 모여 섹션을 만든다
            // 아이템에 대한 사이즈
            // absolute는 고정값, estimated는 추측, fraction 퍼센트
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            // 위에서 만든 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // 아이템 간의 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // 그룹 사이즈
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
            // 그룹 사이즈로 그룹 만들기
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            // 그룹으로 섹션만들기
            let section = NSCollectionLayoutSection(group: group)
            // 섹션 스크롤 가능하게 만들기
            // 섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
    
}
