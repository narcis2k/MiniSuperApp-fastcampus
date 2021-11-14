//
//  CardOnFileViewController.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashBoardPresentableListener: AnyObject {
    func didTappAddPaymentMethod()
}

final class CardOnFileDashBoardViewController: UIViewController, CardOnFileDashBoardPresentable, CardOnFileDashBoardViewControllable {

    weak var listener: CardOnFileDashBoardPresentableListener?
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "카드 및 계좌"
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonDidtapped), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var addMethodButton: AddPaymentMethodButton = {
        let button = AddPaymentMethodButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(addMethodButtonDidTapped), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardOnFileStackView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(seeAllButton)
        

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardOnFileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20),
            cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            
            addMethodButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func seeAllButtonDidtapped() {
        
    }
    
    @objc func addMethodButtonDidTapped() {
        listener?.didTappAddPaymentMethod()
    }
    
    func update(with models: [PaymentMethodViewModel]) {
        cardOnFileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let views = models.map(PaymentMethodView.init)
        views.forEach {
            $0.roundCorners()
            cardOnFileStackView.addArrangedSubview($0)
        }
        
        cardOnFileStackView.addArrangedSubview(addMethodButton)
        
        let heightConstraints = views.map { $0.heightAnchor.constraint(equalToConstant: 60) }
        NSLayoutConstraint.activate(heightConstraints)
    }
}
