//
//  MusicTableViewController.swift
//  iBach
//
//  Created by Petar Jedek on 01.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit
import Unbox
import AlamofireImage
import NotificationCenter

class MusicTableViewController: UIViewController {
    
    var songData: [Song] = []
    var player = MusicPlayer()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadTracks()
    }
    
    
    private func loadTracks() {
        DispatchQueue.main.async {
            HTTPRequest().sendGetRequest(urlString: "https://botticelliproject.com/air/api/song/findall.php", completionHandler: {(response, error) in
                if let data: NSArray = response as? NSArray {
                    for song in data {
                        do {
                            
                            let singleSong: Song = try unbox(dictionary: (song as! NSDictionary) as! UnboxableDictionary)
                            self.songData.append(singleSong)
                            
                        }
                        catch {
                            print("Unable to unbox")
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
}

extension MusicTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "trackCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrackTableViewCell else {
            fatalError("Error")
        }
        
        if let imageURL = URL(string: self.songData[indexPath.row].coverArtUrl) {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            cell.imageViewCoverArt.layer.cornerRadius = 5
            cell.imageViewCoverArt.clipsToBounds = true
            cell.imageViewCoverArt.layer.borderWidth = 0.5
            cell.imageViewCoverArt.layer.borderColor = color.cgColor
            cell.imageViewCoverArt.af_setImage(withURL: imageURL)
        }
        
        cell.labelTrackTitle.text = self.songData[indexPath.row].title
        cell.labelAuthor.text = self.songData[indexPath.row].author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let playerItem = AVPlayerItem(url: URL(string: self.songData[indexPath.row].fileUrl)!)
        player = AVPlayer(playerItem: playerItem)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        player.play() */
        
        player.playMusicFromUrl(url: URL(string: self.songData[indexPath.row].fileUrl)!)
        
        
        let songInfo = ["title": self.songData[indexPath.row].title,
                        "author": self.songData[indexPath.row].author,
                        "cover_art": self.songData[indexPath.row].coverArtUrl,
                        "year": self.songData[indexPath.row].year,
                        "id": self.songData[indexPath.row].id,
                        /*"album": self.songData[indexPath.row].album*/] as [String : Any]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil, userInfo: songInfo)
        
        let songsToPlay = ["id": self.songData[indexPath.row].id, "others": songData] as [String: Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendSongList"), object: nil, userInfo: songsToPlay)
    }
    
}

