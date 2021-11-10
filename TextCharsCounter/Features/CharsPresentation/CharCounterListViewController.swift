//
//  CharCounterListViewController.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import UIKit

class CharCounterListViewController: UIViewController {
    
    lazy private var collectionView = makeCollectionView()
    
    private let cellId = "cellId"
    private let networkClient: NetworkClient

    private var valuesDictionary = [String: Int]() {
        didSet {
            collectionView.reloadData()
        }
    }

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        networkClient.performGetText(localeCode: "uk_UA") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.valuesDictionary = (self.countChars(for: response.data))
            case .failure(let error):
                print(error)
            }
        }
    }
}


// MARK: - UI
private extension CharCounterListViewController {
    func configureUI() {
        view.backgroundColor = .white
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.register(CharCounterCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        layout.minimumLineSpacing = 12
        return cv
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CharCounterListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        valuesDictionary.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CharCounterCell
        else { return UICollectionViewCell() }
        let arr = Array(valuesDictionary.keys)
        cell.valueLabel.text =
            "Value '" +
            arr[indexPath.row].description +
            "'" +
            " \t\t" +
            valuesDictionary[arr[indexPath.row]]!.description +
            " times appeared"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width , height: 60)
    }
}

// MARK: - Private

extension CharCounterListViewController {
    func countChars(for string: String) -> [String: Int] {
        var resultDictionary = [String: Int]()

        for char in string.enumerated() {
            let stringKey = char.element.description
            resultDictionary[stringKey] = (resultDictionary[stringKey] ?? 0) + 1
        }

        return resultDictionary
    }
}
