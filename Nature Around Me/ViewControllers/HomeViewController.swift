//
//  HomeViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 18/06/2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var PostsListTableView: UITableView!
    var userEmail:String?
    
    var data = [Post]()
    var refreshControl = UIRefreshControl()
    var postClick:Post?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell{
        
        let cell = PostsListTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TableViewCell
        let post = data[indexPath.row]
        let imgsUrl = [post.imageUrl1,post.imageUrl2,post.imageUrl3]
        for img in imgsUrl{
            if img != "" && img != nil{
                let url = URL(string: img!)
                cell.img.kf.setImage(with: url)
                break
            }
        }
        
        Model.instance.currentUser { currentUser in
            self.userEmail = currentUser.email
        }
        cell.name.text = post.title
        cell.location.text = post.location
        
        return cell;
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVc = segue.destination as! PostViewController
        destVc.post = postClick
        
    }
    /* Table view delegate */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postClick = data[indexPath.row]
        self.performSegue(withIdentifier: "toCellView", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostsListTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action:#selector(refresh) , for: .valueChanged)
        
        reloadData()
        Model.instance.notificationPostsList.observe {
            self.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let post = data[indexPath.row]
        if post.userEmail == userEmail{
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let post = data[indexPath.row]
            Model.instance.delete(post: post){
                //TODO: add spinner
            }
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        self.reloadData()
    }
    
    func reloadData(){
        refreshControl.beginRefreshing()
        Model.instance.getAllPosts { posts in
            self.data = posts
            self.PostsListTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
