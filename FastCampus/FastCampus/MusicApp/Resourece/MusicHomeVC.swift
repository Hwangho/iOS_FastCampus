//
//  MusicHomeVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/19.
//

import UIKit

class MusicHomeVC: UIViewController {
    
    @IBOutlet weak var MusicCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicCollectionView.dataSource = self
        MusicCollectionView.delegate = self
    }
    
}

extension MusicHomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MusicCollectionView.dequeueReusableCell(withReuseIdentifier: MUsicHomeCVCell.identifier, for: indexPath) as? MUsicHomeCVCell else {return UICollectionViewCell()}
        
        return cell
    }
}

extension MusicHomeVC : UICollectionViewDelegate{
    
}

extension MusicHomeVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing : CGFloat = 20
        let margin : CGFloat = 20
        let width : CGFloat = (MusicCollectionView.bounds.width - spacing - margin*2)/2
        let height  = width + 60
        
        return CGSize(width: width, height: height)
    }
}

// MARK: CollectionView Cell 관련 코드
class MUsicHomeCVCell : UICollectionViewCell{
    static let identifier  = "MUsicHomeCVCell"
    
    @IBOutlet weak var musicImg: UIImageView!
    @IBOutlet weak var titleTx: UILabel!
    @IBOutlet weak var subTitleTx: UILabel!
    
}

// MARK: Struct 구조체
struct Album{
    let title : String
    let tracks : [Track]
    
    var tumbnail: UIImage?{
        return tracks.first?.artwork
    }
    var artist : String?{
        return tracks.first?.artist
    }
    init(title: String, tracks: [Track] ) {
        self.title = title
        self.tracks = tracks
    }
}

struct Track{
    let title : String
    let artist : String
    let albumName : String
    let artwork : UIImage
    
    init(title:String, artist: String, albumName: String, artwork : UIImage){
        self.title = title
        self.artist = artist
        self.albumName = albumName
        self.artwork = artwork
    }
}
