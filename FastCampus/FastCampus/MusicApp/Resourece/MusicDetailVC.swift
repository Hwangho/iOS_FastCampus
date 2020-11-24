//
//  MusicDetailVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/22.
//

import UIKit
import Foundation
import AVFoundation

class MusicDetailVC: UIViewController {

   static let identifier = "MusicDetailVC"
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var artistText: UILabel!
    @IBOutlet weak var alabumView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var playControlBtn: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    let simplePlayer = SimplePlayer.shared
    var ButtnCilckNum : Bool  = false
    
    var timeObserver : Any?
    var isSeeking : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.alpha = 0
        updatePlayButton()
        updateTime(time: CMTime.zero)
        // TODO: TimeObserver 구현
      //  CMTime(seconds: 1, preferredTimescale: 10)   // 몇초로 분할 시킬 거냐?
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
            
            
        }
    }
    func performalbumImag(){
        switch ButtnCilckNum {
        case true:
            self.scrollView.alpha = 1
            self.alabumView.alpha = 0.4
            
            
        default:
            self.scrollView.alpha = 0
            self.alabumView.alpha = 0
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTintColor()
        updateTrackInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: 뷰나갈때 처리 > 심플플레이어
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
        
    }
    
    @IBAction func albumImgPressBtn(_ sender: Any) {
        if ButtnCilckNum == true {
            ButtnCilckNum = false
        }else{
            ButtnCilckNum = true
        }
        
        performalbumImag()
        UIView.transition(with: albumImage, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        UIView.transition(with: scrollView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
         }
    
    
    
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender: UISlider) {
        // TODO: 시킹 구현
        guard let currentItem = simplePlayer.currentItem else { return }
        let position = Double(sender.value)
        let seconds = currentItem.duration.seconds * position
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        // TODO: 플레이버튼 토글 구현
        if simplePlayer.isPlaying{
            simplePlayer.pause()
        }else {
            simplePlayer.play()
        }
        updatePlayButton()
    }
}

extension MusicDetailVC {
    func updateTrackInfo() {
        // TODO: 트랙 정보 업데이트
        guard let track = simplePlayer.currentItem?.convertToTrack() else {return}
        albumImage.image = track.artwork
        titleText.text = track.title
        artistText.text = track.artist
        
    }
    
    func updateTintColor() {
        playControlBtn.tintColor = DefaultStyle.Colors.tint
        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    func updateTime(time: CMTime) {
        // print(time.seconds)
        // currentTime label, totalduration label, slider
        
        // TODO: 시간정보 업데이트, 심플플레이어 이용해서 수정
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)   // 3.1234 >> 00:03
        totalTimeLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)  // 39.2045  >> 00:39
        
        if isSeeking == false {
            // 노래 들으면서 시킹하면, 자꾸 슬라이더가 업데이트 됨, 따라서 시킹아닐때마 슬라이더 업데이트하자
            // TODO: 슬라이더 정보 업데이트
            timeSlider.value = Float(simplePlayer.currentTime/simplePlayer.totalDurationTime)
            
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func updatePlayButton() {
        // TODO: 플레이버튼 업데이트 UI작업 > 재생/멈춤
        if simplePlayer.isPlaying {
            let configuartion = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuartion)
            playControlBtn.setImage(image, for: .normal)
        }else{
            let configuartion = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuartion)
            playControlBtn.setImage(image, for: .normal)
        }
    }
}
