//
//  CharCounterCell.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import UIKit

class CharCounterCell: UICollectionViewCell {
    lazy var valueLabel = makeValueLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(valueLabel)
        backgroundColor = .white
        valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharCounterCell {
    func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }
}


