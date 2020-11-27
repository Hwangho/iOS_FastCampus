//
//  TodoListVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/25.
//

import UIKit

class TodoListVC: UIViewController {

    @IBOutlet weak var TodoListCollectionVIew: UICollectionView!
    
    // TODO: TodoViewModel 만들기
    let todoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TodoListCollectionVIew.dataSource = self
        TodoListCollectionVIew.delegate = self
        
        // TODO: 키보드 디텍션
        
        
        // TODO: 데이터 불러오기
        todoListViewModel.loadTasks()
    }
}

extension TodoListVC {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        
    }
}

extension TodoListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
           return todoListViewModel.todayTodos.count
        } else{
            return todoListViewModel.upcompingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = TodoListCollectionVIew.dequeueReusableCell(withReuseIdentifier: TodoListCVCell.identifier, for: indexPath) as? TodoListCVCell else {return UICollectionViewCell() }
        
        var todo: Todo
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.item]
        }else {
            todo = todoListViewModel.upcompingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        
        // TODO: todo 를 이용해서 updateUI
        // TODO: doneButtonHandler 작성
        // TODO: deleteButtonHandler 작성
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TodoKistCVHeaderCell.identifier, for: indexPath) as? TodoKistCVHeaderCell else {
                return UICollectionReusableView()
            }
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension TodoListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

extension TodoListVC: UICollectionViewDelegate {
    
}

// MARK: CollectionViewCell 관련 Class

class TodoListCVCell: UICollectionViewCell {
    static let identifier = "TodoListCVCell"
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView!
    
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo) {
        // TODO: 셀 업데이트 하기
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        deleteButton.isHidden = todo.isDone == false
        showStrikeThrough(todo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset() {
        // TODO: reset로직 구현
        
    }
}

// MARK: CollectionView HeaderCell 관련 Class

class TodoKistCVHeaderCell: UICollectionReusableView {
    static let identifier = "TodoKistCVHeaderCell"
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
