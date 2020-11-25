//
//  TodoListVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/25.
//

import UIKit

class TodoListVC: UIViewController {

    @IBOutlet weak var TodoListCollectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoListCollectionVIew.dataSource = self
        TodoListCollectionVIew.delegate = self
    }
}


extension TodoListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = TodoListCollectionVIew.dequeueReusableCell(withReuseIdentifier: TodoListCVCell.identifier, for: indexPath) as? TodoListCVCell else {return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let headerCell = TodoListCollectionVIew.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoKistCVHeaderCell.identifier, for: indexPath) as! TodoKistCVHeaderCell
        
        return headerCell
    }
}

extension TodoListVC: UICollectionViewDelegateFlowLayout {
    
}

extension TodoListVC: UICollectionViewDelegate {
    
}

// MARK: CollectionViewCell 관련 Class

class TodoListCVCell: UICollectionViewCell {
    static let identifier = "TodoListCVCell"
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        
    }
}

// MARK: CollectionView HeaderCell 관련 Class

class TodoKistCVHeaderCell: UICollectionReusableView {
    static let identifier = "TodoKistCVHeaderCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
