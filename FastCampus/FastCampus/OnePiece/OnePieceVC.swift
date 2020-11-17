//
//  OnePieceVC.swift
//  iOS_Study
//
//  Created by 송황호 on 2020/11/17.
//

import UIKit

class OnePieceVC: UIViewController{

    @IBOutlet weak var onePieceCollectionView: UICollectionView!
    
    var bountyInformations : [boundyInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setinformation()
        onePieceCollectionView.dataSource = self
        onePieceCollectionView.delegate = self
    }

    // 보내기 전에
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let vc = segue.destination as? DetailVC
            vc?.modalPresentationStyle = .fullScreen
            if let index = sender as? Int{
                vc?.image = bountyInformations[index].image
                vc?.name = bountyInformations[index].name
                vc?.bounty = bountyInformations[index].Bounty
            }
        }
    }
    
    
    func setinformation(){
        
        let data1 = boundyInfo(image: "homeIcCoffee", name: "커피", Bounty: 30000)
        let data2 = boundyInfo(image: "homeIcGreenpowder", name: "녹차 파우더", Bounty: 23000)
        let data3 = boundyInfo(image: "homeIcHssyrup", name: "헤이즐럿 시럽", Bounty: 312000)
        let data4 = boundyInfo(image: "homeIcMcpowder", name: "뭔 파우던데", Bounty: 23000)
        let data5 = boundyInfo(image: "homeIcMilk", name: "우유", Bounty: 420000)
        
        bountyInformations = [data1, data2, data3,data4,data5]
    }
}


extension OnePieceVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bountyInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onePieceCollectionView.dequeueReusableCell(withReuseIdentifier: OnPoecCVCell.idenetifier, for: indexPath) as? OnPoecCVCell else{ return UICollectionViewCell() }
        
        cell.setdata(image: bountyInformations[indexPath.row].image, name: bountyInformations[indexPath.row].name, bounty: bountyInformations[indexPath.row].Bounty)
        
        return cell
    }
}

extension OnePieceVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("현재 위치는?\(indexPath.row)")
        
        performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
}

extension OnePieceVC : UICollectionViewDelegateFlowLayout{
    
}



// MARK: CollectionView Cell 관련
class OnPoecCVCell : UICollectionViewCell{
    static let idenetifier = "OnPoecCVCell"
    
    @IBOutlet weak var bountyImg: UIImageView!
    @IBOutlet weak var nameTx: UILabel!
    @IBOutlet weak var bountyTx: UILabel!
    
    
    func setdata(image: String, name:String, bounty: Int){
        self.bountyImg.image = UIImage(named: image)
        self.nameTx.text = name
        self.bountyTx.text = "\(bounty)"
    }
    
}


// Information
struct boundyInfo{
    let image : String
    let name : String
    let Bounty : Int
    
    init(image: String, name: String, Bounty : Int) {
        self.image = image
        self.name = name
        self.Bounty = Bounty
    }
}
