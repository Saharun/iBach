//
//  PlaylistsTableViewController.swift
//  iBach
//
//  Created by Petar Jedek on 07.12.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import UIKit
import Unbox

class PlaylistsTableViewController: UITableViewController {
    
    var playlistData: [Playlist] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        loadData()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            HTTPRequest().sendGetRequest(urlString: "https://botticelliproject.com/air/api/playlists/findall.php?userId=\(UserDefaults.standard.integer(forKey: "user_id"))", completionHandler: {(response, error) in
                if let data: NSArray = response as? NSArray {
                    for playlist in data {
                        do {
                            
                            let playlist: Playlist = try unbox(dictionary: (playlist as! NSDictionary) as! UnboxableDictionary)
                            self.playlistData.append(playlist)
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "playlistCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaylistsTableViewCell else {
            fatalError("Error")
        }
        
        if let imageURL = URL(string: self.playlistData[indexPath.row].coverArtUrl) {
            let color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
            
            cell.imageViewCoverArt.layer.cornerRadius = 10
            cell.imageViewCoverArt.clipsToBounds = true
            cell.imageViewCoverArt.layer.borderWidth = 0.5
            cell.imageViewCoverArt.layer.borderColor = color.cgColor
            
            cell.imageViewCoverArt.af_setImage(withURL: imageURL)
            
            let blur = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = cell.imageViewCoverArt.bounds
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            
            vibrancyView.frame = blurView.contentView.bounds
            vibrancyView.contentView.addSubview(cell.imageViewLogo)
            cell.imageViewLogo.center = vibrancyView.center
            blurView.contentView.addSubview(vibrancyView)
            
            cell.imageViewCoverArt.addSubview(blurView)
        }
        
        cell.labelName.text = self.playlistData[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let playerItem = AVPlayerItem(url: URL(string: self.songData[indexPath.row].fileUrl)!)
         player = AVPlayer(playerItem: playerItem)
         
         do {
         try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
         try AVAudioSession.sharedInstance().setActive(true)
         } catch {
         print(error)
         }
         
         player.play() */
        
        //player.playMusicFromUrl(url: URL(string: self.songData[indexPath.row].fileUrl)!)
        
        
        /*let songInfo = ["title": self.songData[indexPath.row].title,
         "author": self.songData[indexPath.row].author,
         "cover_art": self.songData[indexPath.row].coverArtUrl,
         "year": self.songData[indexPath.row].year,
         "id": self.songData[indexPath.row].id,
         /*"album": self.songData[indexPath.row].album*/] as [String : Any] */
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayMiniPlayer"), object: nil, userInfo: songInfo)
        
        //let songsToPlay = ["id": self.songData[indexPath.row].id, "others": songData] as [String: Any]
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendSongList"), object: nil, userInfo: songsToPlay)
    }
    
}

extension PlaylistsTableViewController: UISearchResultsUpdating  {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}