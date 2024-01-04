//
//  ViewController.swift
//  PhotosTableViewAssignment
//
//  Created by Mac on 04/01/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var post : [Post] = []
    
 
   
    
    @IBOutlet weak var postTableView: UITableView!
    
   // @IBOutlet weak var postTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerWithXib()
        intilizeWithTableView()
        fetchData()
       
    }
    
    func registerWithXib (){
        let uinib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.postTableView.register(uinib, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    func intilizeWithTableView(){
        postTableView.delegate = self
        postTableView.dataSource = self
    }

    func fetchData()
    {
            let postUrl = URL(string: "https://jsonplaceholder.typicode.com/photos")
            var postRequest = URLRequest(url: postUrl!)
            postRequest.httpMethod = "Get"
        
        let postUrlSesson = URLSession(configuration: .default)
        let postDataTask = postUrlSesson.dataTask(with: postRequest) { postData, postResponse, postError in
            
            let postUrlResponse = try! JSONSerialization.jsonObject(with: postData!) as! [[String : Any]]
            
            for eachResponse in postUrlResponse{
                let postDictonary = eachResponse as! [String : Any]
                let postAlbumId = postDictonary["albumId"] as! Int
                let postid = postDictonary["id"] as! Int
                let postTitle = postDictonary["title"] as! String
                let postUrl = postDictonary["url"] as! String
                let Object = Post(albumId: postAlbumId, id: postid, title: postTitle, url: postUrl)
                self.post.append(Object)
                }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        postDataTask.resume()
    }
}
extension ViewController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150.0
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customTableViewCell = self.postTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        customTableViewCell.albumIdLabel.text = String(post[indexPath.row].albumId)
        customTableViewCell.idLabel.text = String(post[indexPath.row].id)
        customTableViewCell.titleLabel.text = post[indexPath.row].title
        
        customTableViewCell.imageViewLabel.kf.setImage(with:URL(string:post[indexPath.row].url))
        return customTableViewCell
        
    }
    
    
}

