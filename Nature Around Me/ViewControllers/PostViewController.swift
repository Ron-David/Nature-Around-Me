//
//  PostViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 13/07/2021.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {

    @IBOutlet weak var postTitle: UILabel!
    var postTitleT:String?
    var post:Post?
    @IBOutlet weak var backImgBtn: UIButton!
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var nextImgBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    var imgsUrl = [String]()
    var imgCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgs = [post?.imageUrl1,post?.imageUrl2,post?.imageUrl3]
        for img in imgs {
            if img != ""{
                imgsUrl.append(img!)
            }
        }
            let imgUrl = URL(string: imgsUrl[0])
            img.kf.setImage(with: imgUrl)
        if imgsUrl.count == 1 {
            backImgBtn.isEnabled = false
            nextImgBtn.isEnabled = false
        }
        postTitle.text = post?.title
        location.text = post?.location
        textField.text = post?.freeText
        textField.isEditable = false
        
        }
    

    @IBAction func leftBtn(_ sender: Any) {
        nextImgBtn.isEnabled = true
        imgCounter -= 1
        let imgUrl = URL(string: imgsUrl[imgCounter])
        img.kf.setImage(with: imgUrl)
        if imgCounter == 0 {
            backImgBtn.isEnabled = false
        }
    }
    @IBAction func rightBtn(_ sender: Any) {
        backImgBtn.isEnabled = true
        imgCounter += 1
        let imgUrl = URL(string: imgsUrl[imgCounter])
        img.kf.setImage(with: imgUrl)
        if (imgCounter + 1) == imgsUrl.count {
            nextImgBtn.isEnabled = false
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
