//
//  FeedController.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 23/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//
import UIKit
import Foundation
import VK_ios_sdk
import Nuke

class FeedController: UITableViewController, UISearchResultsUpdating {
    
    var feed = [Item]()
    var groups = [Group]()
    var profiles = [Profile]()

    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let search = UISearchController(searchResultsController: nil)
            search.searchResultsUpdater = self
            self.navigationItem.searchController = search
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        loadFeed()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FeedCell  else {
            fatalError("The dequeued cell is not an instance of FeedCell.")
        }
        let feedCell = feed[indexPath.row]
        var url: URL? = nil
        var attachment: Attachment? = nil
        if (feedCell.attachments != nil) {
            attachment = (feedCell.attachments?[0])!
        } else {
            if (feedCell.copy_history != nil) {
                if (feedCell.copy_history?[0].attachments?[0] != nil) {
                    attachment = (feedCell.copy_history?[0].attachments?[0])!
                }
            } else {
                attachment = nil
            }
        }
        if (attachment != nil) {
            let photo = attachment?.photo
            if (photo != nil) {
                var urlString: String = ""
                if (photo?.photo_604 != nil) {
                    urlString = (photo?.photo_604)! as! String
                }
                url = URL(string: (urlString as String))
            } else if (attachment?.link != nil) {
                url = URL(string: (attachment?.link?.photo!.photo_604)! as! String)
            }
        }
        
        cell.likes.text = String(feedCell.likes.count)
        
        var group: Group?
        var profile: Profile?
        
        if (feedCell.attachments != nil) {
            group = groups.first{$0.id == abs(feedCell.source_id)}
        } else {
            if (feedCell.copy_history != nil) {
                group = groups.first{$0.id == abs(feedCell.copy_history![0].owner_id)}
            } else {
                group = groups.first{$0.id == abs(feedCell.source_id)}
            }
        }
        
        if (group == nil) {
            if (feedCell.attachments != nil) {
                profile = profiles.first{$0.id == abs(feedCell.source_id)}
            } else {
                if (feedCell.copy_history != nil) {
                    profile = profiles.first{$0.id == abs(feedCell.copy_history![0].owner_id)}
                } else {
                    profile = profiles.first{$0.id == abs(feedCell.source_id)}
                }
            }
        }
        
        cell.cellText.text = feedCell.text
        cell.setDate(unixDate: feedCell.date)
        
        if (group != nil) {
            cell.cellTitle.text = group?.name
            cell.setAvatar(url: URL(string: group?.photo_100 ?? ""))
        } else {
            cell.cellTitle.text = "\(profile!.first_name) \(profile!.last_name)"
            cell.setAvatar(url: URL(string: profile?.photo_100 ?? ""))
        }
    
        if (url != nil) {
            cell.photo.isHidden = false
            cell.setImage(url: url)
        } else {
            cell.photo.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            feed.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.navTitle = (sender as! FeedCell).cellTitle.text!
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    private func loadFeed() {
        let request = VKRequest(method: "newsfeed.get", andParameters: ["filters":"post"], andHttpMethod: "GET")
        request?.execute(resultBlock: {(response) -> Void in
            let data = response?.responseString.data(using: .utf8)!
            print(response?.responseString)
            let decodedResponse = try! JSONDecoder().decode(Response<Feed>.self, from: data!)
            self.feed = decodedResponse.response.items
            self.groups = decodedResponse.response.groups
            self.profiles = decodedResponse.response.profiles
            self.tableView.reloadData()
        }, errorBlock: {(error) -> Void in
            print(error as Any)
        })
    }
    
    @objc private func addTapped() {}
}
