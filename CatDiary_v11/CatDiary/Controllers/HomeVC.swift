//
//  ViewController.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import UIKit

class HomeVC: UIViewController {
    
    // 좋아요(즐겨찾기) 기능 구현하기위한 변수 선언
    var isFavorite: Bool = false
    
    // 🍎컬렉션 뷰 아울렛 연결
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 🍎네트워크 매니저 (싱글톤)
    var netWorkManager = NetworkManager.shared
    // 🍎(Cat 데이터를 다루기 위해) 빈배열로 시작
    var getCatList: [CatGetModel] = []
    
    var newGetCatList: [CatGetModel] = []
    
    
    // 🍎 Cat 데이터를 다루기 위해 빈배열로 시작
    var getCatFavoriteList: [FavoriteCatModel] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupCollectionView()
    }
    
    // MARK: - 초기데이터생성
    func setupData() {
        // 🍎 네트워크 통신으로 이미지를 가져와서 모델 데이터에 저장
        netWorkManager.fetchData { result in
            self.getCatList = result
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - 컬렉션뷰 셋팅
    func setupCollectionView() {
        // 🍎 대리자 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        // 콜렉션뷰의 콜렉션뷰 레이아웃 설정
        collectionView.collectionViewLayout = createCompositionalLayout()
        // 🍎 Xib 컬렉션뷰 쎌 레지스터 등록
        let catImgCVC = UINib(nibName: "CatImgCVC", bundle: nil)
        collectionView.register(catImgCVC, forCellWithReuseIdentifier: "CatImgCVC")
        // 콜렉션뷰 Width, Height를 유연하게 설정
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
}

// MARK: - UICollectionViewDataSource
// 데이터와 관련된 것들
extension HomeVC: UICollectionViewDataSource {
    // 각 세션에 들어가는 아이템 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 네트워크 통신으로 받아온 데이터 배열의 count
        return getCatList.count
    }
    // 각 콜렉션 쎌에 대한 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImgCVC", for: indexPath) as! CatImgCVC
        // 쎌에 네트워크 통신으로 받은 이미지주소 넘겨주기
        print(#function)
        cell.setData(getCatList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 좋아요 버튼을 눌르면 즐겨찾기 탭바인 Favorite탭바 VC 의 콜렉션뷰 쎌에 이미지 띄우기
        let _ = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImgCVC", for: indexPath) as! CatImgCVC
        // 하트 버튼이 didSelect 됬다면
        // 🍎얼럿 띄우기 "즐겨찾기를 하시겠습니까?
        let sheet = UIAlertController(title: "즐겨찾기", message: "즐겨찾기를 하시겠습니까?", preferredStyle: .actionSheet)
        // yes 눌르면
        sheet.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { [self] favoriteVC in
            
            if let imgId = self.getCatList[indexPath.item].id {
                
                self.netWorkManager.addToFavorite(imageId: imgId, completionHandler: { [weak self] () in
                    guard let self = self else { return }
                    print(#fileID, #function, #line, "- ⭐️")
                    //                    self.netWorkManager.fetchFavorites { catGetModelArray in
                    //                        let favoritesVC = FavoriteVC()
                    //                        favoritesVC.getCatFavoriteArray = catGetModelArray
                    //                        DispatchQueue.main.async {
                    //                            favoritesVC.collectionView.reloadData()
                    //                        }
                    //                    }
                })
                
            }
            
            
            
        }))
        // No 눌르면
        sheet.addAction(UIAlertAction(title: "No!", style: .cancel, handler: { _ in print("No 클릭") }))
        // 얼럿창 띄우기
        present(sheet, animated: true)
        
    }
    
    
}


// MARK: - UICollectionViewDelegate
// 이벤트와 관련된 것
extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // 좋아요 버튼을 눌르면 즐겨찾기 탭바인 Favorite탭바 VC 의 콜렉션뷰 쎌에 이미지 띄우기
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImgCVC", for: indexPath) as! CatImgCVC
        // 하트 버튼이 didSelect 됬다면
        
        
    }
}

// MARK: - 컬렉션뷰 컴포지셔널 레이아웃 관련
extension HomeVC {
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
            
            // 섹션 헤더 설정
            
            return section
        }
        return layout
    }
    
}


