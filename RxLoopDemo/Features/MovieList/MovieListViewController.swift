//
//  MovieListViewController.swift
//  RxReduceDemo
//
//  Created by Thibault Wittemberg on 18-06-04.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Reusable
import Alamofire
import AlamofireImage

final class MovieListViewController: UITableViewController, StoryboardBased {
    private let intentSubject = PublishSubject<MovieListIntent>()
    private var movieViewItems: [MovieListState.ViewItem] = []
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.frame = self.view.frame

        self.view.addSubview(indicator)
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.register(cellType: MovieListViewCell.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.intentSubject.onNext(.viewWillAppear)
    }

    lazy var emitIntents = { [weak self] in
        return self?.intentSubject.asObservable() ?? .never()
    }

    func render (state: MovieListState) {
        switch state {
        case .idle:
            self.movieViewItems.removeAll()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        case .loading:
            self.movieViewItems.removeAll()
            self.activityIndicator.isHidden = false
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            self.activityIndicator.startAnimating()
            self.tableView.reloadData()
        case .loaded(let movieViewItems):
            self.movieViewItems = movieViewItems
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            self.tableView.reloadData()
        case .failed:
            self.activityIndicator.stopAnimating()
            print("Loading has failed")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieViewItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListViewCell = tableView.dequeueReusableCell(for: indexPath)
        let movieViewItem = self.movieViewItems[indexPath.row]
        cell.title.text = movieViewItem.title
        cell.overview.text = movieViewItem.overview
        let posterURL = movieViewItem.posterURL
        Alamofire.request(posterURL).responseImage { (response) in
            guard response.request?.url == posterURL else { return }
            guard let data = response.data else { return }

            cell.poster.image = UIImage(data: data)
        }

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewItem = self.movieViewItems[indexPath.row]
        self.movieSelected(withId: viewItem.id)
    }
}

extension MovieListViewController: Stepper {
    fileprivate func movieSelected (withId id: Int) {
        self.steps.accept(AppStep.movieDetail(id: id))
    }
}
