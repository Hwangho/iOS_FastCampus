//
//  TrackManager.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/19.
//

import UIKit
import AVFoundation

class TrackManager {
    // TODO: 프로퍼티 정리하기 - Tracks, albums
    var tracks : [AVPlayerItem] = []
    var albums : [Album] = []
    var todayTracks :  AVPlayerItem?
    
    // TODO: 생성자 정의하기
    init(){
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.todayTracks = self.tracks.randomElement()
    }
    
    // TODO: 트랙 로드하기
    func loadTracks() -> [AVPlayerItem] {
        // 파일들 읽어서 AV아이템 만들기
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        
//        var items : [AVPlayerItem] = []
//        for url in urls{
//            let item = AVPlayerItem(url: url)
//            items.append(item)
//        }
        
        let items = urls.map{ url -> AVPlayerItem in
            let item = AVPlayerItem(url: url)
            return item
        }
        
        return items
    }
    
    // TODO: 인덱스에 맞는 트랙 로드하기
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index]
        let track = playerItem.convertToTrack()
        return track
    }
    
    // TODO: 앨범 로딩메소드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap { $0.convertToTrack() }
        let albumDics = Dictionary(grouping: trackList, by: { (track) in track.albumName })
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        return albums
    }
    // TODO: 오늘의 트랙 랜덤으로 선책
    func loadOtherTodaysTrack() {
        self.todayTracks = self.tracks.randomElement()
    }
}



