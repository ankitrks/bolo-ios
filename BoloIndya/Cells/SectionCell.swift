//
//  SectionCell.swift
//  BoloIndya
//
//  Created by apple on 8/8/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit

protocol SectionCellDelegate: class {
    func goToHashTag(with hash_tag: HashTag)
    func goToVideos(with hash_tag: HashTag, position: Int)
}


final class SectionCell: UITableViewCell {
    var title = UILabel()
    var front_image = UIImageView()
    var views = UILabel()
    var hash_tag: HashTag = HashTag()
    var userVideoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    weak var delegate: SectionCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        selectionStyle = .none
        
        self.backgroundColor = UIColor.black
        
        addSubview(userVideoView)
        addSubview(title)
        addSubview(front_image)
        addSubview(views)
        
        setOtherViews()
        setTitleAttribute()
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (screenSize.width/3.4), height: ((screenSize.width/3.4)*1.5))
        userVideoView.collectionViewLayout = layout
        userVideoView.frame = CGRect(x: 0, y: 30, width: screenSize.width, height: ((screenSize.width/3.4)*1.5)+20)
        userVideoView.showsHorizontalScrollIndicator = false
        userVideoView.register(DiscoverCell.self, forCellWithReuseIdentifier: "UserVideoCell")
        userVideoView.delegate = self
        userVideoView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVideo(hash_tag: HashTag) {
        self.hash_tag = hash_tag
        title.text = "#" + self.hash_tag.title
    
        title.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToHashTag(_:)))
        title.addGestureRecognizer(tapGesture)
        views.text = self.hash_tag.total_views
        
        views.isUserInteractionEnabled = true
        
        let tapGestureViews = UITapGestureRecognizer(target: self, action: #selector(goToHashTag(_:)))
        views.addGestureRecognizer(tapGestureViews)
        
        userVideoView.reloadData()
    }
    
    func setTitleAttribute() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: views.leftAnchor, constant: -10).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 1
        title.textColor = UIColor.white
        title.text = "#" + self.hash_tag.title
    }
    
    func setOtherViews() {
        front_image.translatesAutoresizingMaskIntoConstraints = false
        front_image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        front_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        front_image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        front_image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        front_image.image = UIImage(named: "forward")
        front_image.contentMode = .scaleAspectFit
        
        views.translatesAutoresizingMaskIntoConstraints = false
        views.rightAnchor.constraint(equalTo: front_image.leftAnchor, constant: -5).isActive = true
        views.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        views.textAlignment = .right
        views.font = UIFont.boldSystemFont(ofSize: 14.0)
        views.heightAnchor.constraint(equalToConstant: 20).isActive = true
        views.textColor = UIColor.white
    }
    
    @objc func goToHashTag(_ sender: UITapGestureRecognizer) {
        delegate?.goToHashTag(with: hash_tag)
    }
}

extension SectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hash_tag.videos.count == 0 ? 5 : self.hash_tag.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVideoCell", for: indexPath) as! DiscoverCell
        if indexPath.row < hash_tag.videos.count {
            cell.configure(with: hash_tag.videos[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToVideos(with: hash_tag, position: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3.4), height: (((collectionView.frame.width/3.4)*1.5)+10))
    }
}
