//
//  MovieDetailViewController.swift
//  RxReduceDemo
//
//  Created by Thibault Wittemberg on 18-06-07.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class MovieDetailViewController: UIViewController, StoryboardBased {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var originalNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let intentSubject = PublishSubject<MovieDetailIntent>()
    let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.intentSubject.onNext(.viewWillAppear)
    }

    lazy var emitIntents = { [weak self] in
        return self?.intentSubject.asObservable() ?? .never()
    }

    lazy var render = { [weak self] (movieDetailState: MovieDetailState) in
        switch movieDetailState {
        case .idle:
            self?.activityIndicator.stopAnimating()
            self?.nameLabel.text = ""
            self?.overviewTextView.text = ""
            self?.voteAverageLabel.text = ""
            self?.popularityLabel.text = ""
            self?.originalNameLabel.text = ""
            self?.releaseDateLabel.text = ""
            self?.posterImageView.image = nil
        case .loading:
            self?.activityIndicator.startAnimating()
            self?.nameLabel.text = ""
            self?.overviewTextView.text = ""
            self?.voteAverageLabel.text = ""
            self?.popularityLabel.text = ""
            self?.originalNameLabel.text = ""
            self?.releaseDateLabel.text = ""
            self?.posterImageView.image = nil
        case .loaded(let movie):
            Alamofire.request(movie.posterURL).responseImage { [weak self] (response) in
                guard response.request?.url == movie.posterURL else { return }
                guard let data = response.data else { return }
                
                self?.posterImageView.image = UIImage(data: data)
                self?.activityIndicator.stopAnimating()
            }
            self?.nameLabel.text = movie.title
            self?.overviewTextView.text = movie.overview
            self?.voteAverageLabel.text = movie.voteAverage
            self?.popularityLabel.text = movie.popularity
            self?.originalNameLabel.text = movie.originalTitle
            self?.releaseDateLabel.text = movie.releaseDate
        case .failed:
            self?.activityIndicator.stopAnimating()
            self?.nameLabel.text = "Failed loading"
            self?.overviewTextView.text = "-"
            self?.voteAverageLabel.text = "-"
            self?.popularityLabel.text = "-"
            self?.originalNameLabel.text = "-"
            self?.releaseDateLabel.text = "-"
            self?.posterImageView.image = UIImage(named: "failure")!
        }
    }
}
