//
//  FavoriteVC.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import UIKit


class FavoriteVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // πλ€νΈμν¬ λ§€λμ  (μ±κΈν€)
    var netWorkManager = NetworkManager.shared
    
    // π μΌλΏμ ν΅ν΄ μ¦κ²¨μ°ΎκΈ° μ΄λ―Έμ§λ₯Ό λ°μ κ³³
    var getCatFavoriteArray: [FavoriteCatModel] = []
    
    // MARK: - λ·°λλλ‘λ
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        print(getCatFavoriteArray,"π")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func setupCollectionView() {
        // λΈλ¦¬κ²μ΄νΈ μμ μ€μ 
        collectionView.dataSource = self
        collectionView.delegate = self
        // μ½λ μλ·°μ μ½λ μλ·° λ μ΄μμ μ€μ 
        collectionView.collectionViewLayout = createCompositionalLayout()
        // μ½λ μλ·° Width, Heightλ₯Ό μ μ°νκ² μ€μ 
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // π Xib μ»¬λ μλ·° μ λ μ§μ€ν° λ±λ‘
        let catFavorieCVC = UINib(nibName: "CatFavoriteCVC", bundle: nil)
        collectionView.register(catFavorieCVC, forCellWithReuseIdentifier: "CatFavoriteCVC")
    }

}

// MARK: - UICollectionViewDataSource
// λ°μ΄ν°μ κ΄λ ¨λ κ²λ€
extension FavoriteVC: UICollectionViewDataSource {
    // κ° μΈμμ λ€μ΄κ°λ μμ΄ν κ°―μ
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // λ€νΈμν¬ ν΅μ μΌλ‘ λ°μμ¨ λ°μ΄ν° λ°°μ΄μ count
        return getCatFavoriteArray.count
    }
    // κ° μ½λ μ μμ λν μ€μ 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImgCVC", for: indexPath) as! CatFavoriteCVC
        // μμ λ€νΈμν¬ ν΅μ μΌλ‘ λ°μ μ΄λ―Έμ§μ£Όμ λκ²¨μ£ΌκΈ°
        
        // λ§μ½ μμ id μ λ€νΈμν¬ ν΅μ μ ν΅ν΄ λκ²¨λ°μ id κ° κ°λ€λ©΄
        print(#function)
        
        return cell
    }
    
    
    
}

// MARK: - UICollectionViewDelegate
// μ΄λ²€νΈμ κ΄λ ¨λ κ²
extension FavoriteVC: UICollectionViewDelegate {
    
}

// MARK: - μ»¬λ μλ·° μ»΄ν¬μ§μλ λ μ΄μμ κ΄λ ¨
extension FavoriteVC {
    // μ»΄ν¬μ§μλλ μ΄μμ μ€μ 
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        // μ»΄ν¬μ§μλ λ μ΄μμ μμ±
        let layout = UICollectionViewCompositionalLayout {
            // λ§λ€κ² λλ©΄ νν (ν€: κ°, ν€: κ°)μ λ¬ΆμμΌλ‘ λ€μ΄μ΄ λ°ν νλ κ²μ NSCollectionLayoutSection μ½λ μ λ μ΄μμ μΉμμ λ°νν΄μΌν¨
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            // π μμ΄νμ΄ λͺ¨μ¬ κ·Έλ£Ήμ λ§λ€κ³  κ·Έλ£Ήμ΄ λͺ¨μ¬ μΉμμ λ§λ λ€
            // μμ΄νμ λν μ¬μ΄μ¦
            // absoluteλ κ³ μ κ°, estimatedλ μΆμΈ‘, fraction νΌμΌνΈ
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            // μμμ λ§λ  μμ΄ν μ¬μ΄μ¦λ‘ μμ΄ν λ§λ€κΈ°
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // μμ΄ν κ°μ κ°κ²© μ€μ 
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // κ·Έλ£Ή μ¬μ΄μ¦
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
            // κ·Έλ£Ή μ¬μ΄μ¦λ‘ κ·Έλ£Ή λ§λ€κΈ°
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            // κ·Έλ£ΉμΌλ‘ μΉμλ§λ€κΈ°
            let section = NSCollectionLayoutSection(group: group)
            // μΉμ μ€ν¬λ‘€ κ°λ₯νκ² λ§λ€κΈ°
            // μΉμμ λν κ°κ²© μ€μ 
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
    
}
