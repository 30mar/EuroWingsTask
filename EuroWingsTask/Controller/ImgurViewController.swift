//
//  ViewController.swift
//  EuroWingsTask
//
//  Created by Omar Abdelaziz on 1/12/19.
//  Copyright © 2019 Omar Abdelaziz. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

enum Section: String{
    case Hot = "hot"
    case Top = "top"
}

enum viewType:String {
    case Grid = "Grid"
    case List = "List"
    case A7a = "A7a"
}
class ImgurViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var components = URLComponents()
    var section: Section = .Hot
    var showViral = false
    var imagesArray = [ImageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        DownloadImagesLinks()
    }
    func initUrl(){
        components.scheme = "https"
        components.host = "api.imgur.com"
        components.path = "/3/gallery/\(section.rawValue)"
        
        components.queryItems = [URLQueryItem]()
        let queryItem1 = URLQueryItem(name: "showViral", value: "\(showViral)")
        components.queryItems?.append(queryItem1)
    }
    func registerCells(){
        let Gridcell = UINib(nibName: "ImageGridCell", bundle:nil)
        self.collectionView.register(Gridcell, forCellWithReuseIdentifier: "ImageGridCell")
    }
    func DownloadImagesLinks(){
        initUrl()
        print(components.url?.absoluteString)
        var request = URLRequest(url:components.url!)
        request.addValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Request returned a status code other than 2xx!\(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            var parsedResult: [String:AnyObject]?
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(String(describing: data))'")
                return
            }
            
            guard let imagesData = parsedResult?["data"] as? [[String:AnyObject]] else {
                print("imagesData is nil")
                return
            }
            
            for item in imagesData{
                if let id = item["id"] as? String, let title = item["title"] as? String, let imagesLinks = item["images"] as? [[String:AnyObject]],let link = imagesLinks.first?["link"] as? String {
                    var imageLinkForVideos = link.replacingOccurrences(of: ".mp4", with: ".jpg")
                    let item = ImageModel(id: id, title: title, link: imageLinkForVideos)
                    self.imagesArray.append(item)
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
}

extension ImgurViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGridCell", for: indexPath) as! ImageGridCell
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: imagesArray[indexPath.item].link))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width/3
        let size = CGSize(width: width , height: width)
        return size
    }
}

