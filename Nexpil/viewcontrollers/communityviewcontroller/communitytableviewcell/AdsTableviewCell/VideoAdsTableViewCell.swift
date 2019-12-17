//
//  VideoAdsTableViewCell.swift
//  Nexpil
//
//  Created by Guang on 11/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import JPVideoPlayer

class VideoAdsTableViewCell: UITableViewCell, JPVideoPlayerDelegate {

    @IBOutlet weak var videoPlayerView: JPVideoPlayerView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var playerButton: UIButton!
    
    var videoPath = "https://nexpil-videos.s3.us-east-2.amazonaws.com/ambien_360p.mp4"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        previewImageView.image = videoSnapshot(filePathLocal: videoPath)
        previewImageView.layer.cornerRadius = 20
        videoPlayerView.jp_videoPlayerDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playButtonClick(_ sender: Any) {
        previewImageView.isHidden = true
        playerButton.isHidden = true
        videoPlayerView.jp_playVideo(with: URL(string: videoPath)!, bufferingIndicator: nil, controlView: nil, progressView: nil, configuration: nil)
    }
    

    func videoSnapshot(filePathLocal: String) -> UIImage? {

//        let vidURL = URL(fileURLWithPath:filePathLocal as String)
        let vidURL = URL(string: filePathLocal)!
        let asset = AVURLAsset(url: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 5, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    override func videoPlayerManager(_ videoPlayerManager: JPVideoPlayerManager, shouldAutoReplayFor videoURL: URL) -> Bool {
        previewImageView.isHidden = false
        playerButton.isHidden = false
        return false
    }
}
