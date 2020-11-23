//
//  MusicHomeVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/19.
//

import UIKit
import AVFoundation

class MusicHomeVC: UIViewController {
    
    let trackManager : TrackManager = TrackManager()
    
    @IBOutlet weak var MusicCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicCollectionView.dataSource = self
        MusicCollectionView.delegate = self

    }
    
}

extension MusicHomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = MusicCollectionView.dequeueReusableCell(withReuseIdentifier: MUsicHomeCVCell.identifier, for: indexPath) as? MUsicHomeCVCell else {return UICollectionViewCell()}
        
        let item  = trackManager.track(at: indexPath.row)
        cell.updateUI(item: item)
        return cell
    }
    
    func  collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item  = trackManager.todayTracks else {
                return UICollectionReusableView()
            }
            
            guard let header = MusicCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MuiscHomeCVHeaderCell.identifier, for: indexPath) as? MuiscHomeCVHeaderCell else {return UICollectionReusableView()}
            
            header.update(with: item)
            header.tapHandler = {item -> Void in
                print("----> Item title : \(item.convertToTrack()?.title)")
                
                let storyboard = UIStoryboard.init(name: "MusicDetail", bundle: nil)
                
                guard let detailVC = storyboard.instantiateViewController(withIdentifier: MusicDetailVC.identifier) as? MusicDetailVC else{return }
                let item = self.trackManager.tracks[indexPath.item]
                detailVC.simplePlayer.replaceCurrentItem(with: item)
                
                self.present(detailVC, animated: true, completion: nil)
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension MusicHomeVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MusicDetail", bundle: nil)
        
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: MusicDetailVC.identifier) as? MusicDetailVC else{return }
        
        let item = trackManager.tracks[indexPath.item]
        detailVC.simplePlayer.replaceCurrentItem(with: item)
        
        present(detailVC, animated: true, completion: nil)
    }
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        musicImg.layer.cornerRadius = 4
        subTitleTx.textColor = UIColor.systemGray2
    }
    
    func updateUI(item : Track?){
        guard let track = item else {return }
        musicImg.image = track.artwork
        titleTx.text = track.title
        subTitleTx.text = track.artist
    }
}

class MuiscHomeCVHeaderCell : UICollectionReusableView{
    static let identifier = "MuiscHomeCVHeaderCell"
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    var item : AVPlayerItem?
    var tapHandler : ((AVPlayerItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImg.layer.cornerRadius = 4
    }
    
    func update(with item : AVPlayerItem){
        self.item = item
        guard let  track = item.convertToTrack() else {return}
        
        self.albumImg.image = track.artwork
        self.discriptionLabel.text = "Today's Pick is \n" + "\(track.artist)'s album - \(track.albumName), Let Listen..."
    }
    
    @IBAction func albumPressBtn(_ sender: Any) {
        guard let todaysItem = item else {return}
            tapHandler?(todaysItem)
        }
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
