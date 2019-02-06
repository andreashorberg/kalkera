//
//  KLockButton.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-25.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

class KLockButton: UIControl {
    var originalSize: CGFloat = 48
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    let maxScale: CGFloat = 1.25
    var animator: UIViewPropertyAnimator?
    let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))

    public enum KLockButtonState {
        case locked
        case locking
        case unlocked
        case unlocking
    }

    var lockState: KLockButtonState = .unlocked {
        didSet {
            switch lockState {
            case .locked:
                NotificationCenter.default.post(name: .KLockButtonLocked, object: self)
                self.backgroundColor = self.configuration.lockedBackgroundColor
                self.imageView.image = UIImage(named: self.configuration.lockedImage)
            case .locking:
                NotificationCenter.default.post(name: .KLockButtonLocking, object: self)
            case .unlocked:
                NotificationCenter.default.post(name: .KLockButtonUnlocked, object: self)
                self.backgroundColor = self.configuration.unlockedBackgroundColor
                self.imageView.image = UIImage(named: self.configuration.unlockedImage)
            case .unlocking:
                NotificationCenter.default.post(name: .KLockButtonUnlocking, object: self)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var configuration = KTheme.shared.kLockButtonConfiguration

    func setup() {
        setupConstraints()
        layer.masksToBounds = true
        layer.cornerRadius = originalSize / 2
        backgroundColor = configuration.unlockedBackgroundColor
        setupImageView()
    }

    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthAnchor.constraint(equalToConstant: originalSize)
        heightConstraint = heightAnchor.constraint(equalTo: widthAnchor)
        guard let widthConstraint = widthConstraint, let heightConstraint = heightConstraint else {
            KCrashReporter.report(description: "Couldn't set constraints", code: .unexpectedNil, throw: true)
            return
        }
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }

    func setLargeConstraints() {
        guard let widthConstraint = widthConstraint else {
            KCrashReporter.report(description: "Couldn't get width constraint", code: .unexpectedNil, throw: true)
            return
        }
        widthConstraint.constant = originalSize * maxScale
        layer.cornerRadius = (originalSize * maxScale) / 2
    }

    func setOriginalConstraints() {
        guard let widthConstraint = widthConstraint else {
            KCrashReporter.report(description: "Couldn't get width constraint", code: .unexpectedNil, throw: true)
            return
        }
        widthConstraint.constant = originalSize
        layer.cornerRadius = originalSize / 2
    }

    func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.image = UIImage(named: configuration.unlockedImage)

    }

    struct KLockButtonConfiguration {
        let unlockedBackgroundColor: UIColor
        let lockedBackgroundColor: UIColor
        let unlockedImage: String
        let lockedImage: String
        let textColor: UIColor
        let font: UIFont
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        scaleUp()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        scaleDown()
        resetState()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        scaleDown()
        resetState()
    }

    func resetState() {
        if lockState == .unlocking {
            lockState = .locked
        } else if lockState == .locking {
            lockState = .unlocked
        }
    }

    func scaleUp() {
        guard
            frame.size.width < originalSize * maxScale
            else { return }
        self.setLargeConstraints()
        if self.lockState == .unlocked {
            self.lockState = .locking
        } else if self.lockState == .locked {
            self.lockState = .unlocking
        }
        animator = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.25, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        })
        animator?.addCompletion({ _ in
            if self.lockState == .locking {
                self.lockState = .locked
            } else if self.lockState == .unlocking {
                self.lockState = .unlocked
            }
        })
        animator?.startAnimation()
    }

    func scaleDown(withoutFinishing: Bool = true) {
        animator?.stopAnimation(withoutFinishing)
        setOriginalConstraints()
        animator = UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.25, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        })
        animator?.startAnimation()
    }
}
