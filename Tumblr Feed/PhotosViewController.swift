//
//  PhotosViewController.swift
//  Tumblr Feed
//
//  Created by Arthur on 2017/2/1.
//  Copyright © 2017年 Kuan-Ting Wu (Arthur Wu). All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var tableView: UITableView!
    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary];
                        
                        self.tableView.reloadData()
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        task.resume()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        let post = posts[indexPath.row]
        let timestamp = post["timestamp"] as? String
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
             cell.poster.setImageWith(imageUrl)
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        return cell
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl)
    {
        
        // ... Create the URLRequest `myRequest` ...
        
        // Configure session so that completion handler is executed on main UI thread
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary];
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.tableView.reloadData()
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        
            
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            task.resume()
    }
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let cell = sender as! UITableViewCell;
        var indexPath = tableView.indexPath(for: cell);
        
        let detailView = segue.destination as! PhotoDetailsViewController;
        
        
        let post = posts[(indexPath?.row)!]
        let timestamp = post["timestamp"] as? String
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                detailView.photoURL = imageUrl;
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }

        
        
        //detailView.photoURL =
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
