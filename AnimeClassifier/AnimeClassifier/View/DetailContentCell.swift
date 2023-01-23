//
//  VideoDetailCell.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import UIKit
import AVKit
import AVFoundation

class DetailContentCell: UICollectionViewCell {
    //MARK: - Properties
    var anime: Anime? {
        didSet {
            guard let anime = anime else { return }
            self.filenameLabel.text = anime.fileName
            self.episodeLabel.text = "Episode: \(anime.episode)"
            self.timeFrameLabel.text = "Time \(anime.from.toTime()) - \(anime.to.toTime())"
            self.similarityLabel.text = "Similarity: \(anime.similarity.toPercent())"
            //we are calling this function to add the sublayer to the videoview once result is set, if we did this within the property then it would be called once it is initialized instead which is too soon.
            setupVideoLayer()
        }
    }
    private lazy var videoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        //16:9 is the aspect ratio for all HD videos
        let height = (self.frame.width * 9 / 16) - 10
        let width = self.frame.width - 20
        view.setDimensions(height: height, width: width)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let filenameLabel: UILabel = {
        let label = UILabel().makebodyLabel()
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel().makebodyLabel()
        return label
    }()
    
    private let timeFrameLabel: UILabel = {
        let label = UILabel().makebodyLabel()
        return label
    }()
    
    private let similarityLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: "Similarity: ")
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellComponents() {
        addSubview(videoView)
        videoView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeading: 12, paddingTrailing: 12)
        
        addSubview(filenameLabel)
        filenameLabel.anchor(top: videoView.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeading: 8, paddingTrailing: 8)
        
        let infoStack = UIStackView(arrangedSubviews: [episodeLabel, timeFrameLabel])
        infoStack.spacing = 16
        infoStack.distribution = .fillProportionally
        infoStack.axis = .horizontal
        
        addSubview(infoStack)
        infoStack.anchor(top: filenameLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, paddingTop: 12, paddingLeading: 16, paddingTrailing: 16)
        
        addSubview(similarityLabel)
        similarityLabel.centerX(inView: self)
        similarityLabel.anchor(top: infoStack.bottomAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, paddingTop: 16, paddingBottom: 16)
        
    }
    
    
    private func setupVideoLayer() {
        videoView.layer.sublayers?.removeAll()
        guard let anime = anime else { return }
        guard let videoUrl = URL(string: anime.videoUrlString) else { return }
        let avPlayer = AVPlayer(url: videoUrl)
        avPlayer.play()
        avPlayer.isMuted = true
        //The AVPlayerLayer is an object that can render the visual contents of a player object, this object has a property video gravity which allows us to scale and resize the video
        let playerLayer = AVPlayerLayer(player: avPlayer)
        // the player layer now needs a frame
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)

    }
}
