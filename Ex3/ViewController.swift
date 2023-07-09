//
//  ViewController.swift
//  Ex3
//
//  Created by Кох Александр Станиславович on 09.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private let squareView: UIView = {
        let animateView = UIView()
        animateView.backgroundColor = .blue
        animateView.layer.cornerRadius = 10
        return animateView
    }()
    
    private let squareViewSide: CGFloat = 100
    private let slider = UISlider()
    private var propertyAnimator = UIViewPropertyAnimator()
    private var squareViewLeadingConstraint: NSLayoutConstraint? = nil
    private var squareViewTrailingConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.addSubview(squareView)
        view.addSubview(slider)
        
        configureSlider()
        configureAnimator()
        setupConstraints()
    }
    
    private func configureSlider() {
        slider.addTarget(self, action: #selector(changeValueSlider), for: .valueChanged)
        slider.addTarget(self, action: #selector(endMoveSlider), for: .touchUpInside)
    }
    
    private func configureAnimator() {
        propertyAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
            self.squareView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.squareView.transform = self.squareView.transform.scaledBy(x: 1.5, y: 1.5)
            
            self.squareViewLeadingConstraint?.isActive = false
            self.squareViewTrailingConstraint?.isActive = true
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        squareViewTrailingConstraint = squareView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -1.5 * squareViewSide / 6)
        squareViewLeadingConstraint = squareView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        squareViewLeadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 200),
            squareView.widthAnchor.constraint(equalToConstant: squareViewSide),
            squareView.heightAnchor.constraint(equalToConstant: squareViewSide),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: squareViewSide / 2),
            slider.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    @objc
    private func changeValueSlider(_ sender: UISlider) {
        propertyAnimator.pausesOnCompletion = true
        propertyAnimator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc
    private func endMoveSlider(_ sender: UISlider) {
        sender.setValue(sender.maximumValue, animated: true)
        propertyAnimator.continueAnimation(withTimingParameters: .none, durationFactor: 0)
    }
}
