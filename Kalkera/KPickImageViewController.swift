//
//  ViewController.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol KPickImageViewControllerDelegate {
    func finishedPickingImage(_ sender: KPickImageViewController)
}

class KPickImageViewController: KViewController {

    override class var storyboard: UIStoryboard { return UIStoryboard(name: "PickImage", bundle: nil) }
    
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    var viewModel = KPickImageViewModel()
    var delegate: KPickImageViewControllerDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var tools: [UIButton]!
    @IBOutlet weak var toolbar: UIStackView!
    @IBOutlet weak var slices: UIStackView!
    @IBOutlet weak var toolbarLeading: NSLayoutConstraint!
    @IBOutlet weak var slicesBottom: NSLayoutConstraint!
    @IBOutlet weak var lockButton: KLockButton!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var toolbarBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureToolbarAppearance()
        configureTools(enable: false)
        displaySlices(show: false, animated: false)
        configureObservers(add: true)
        resetButton.isEnabled = false

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func configureObservers(add: Bool) {
        if add {
            NotificationCenter.default.addObserver(self, selector: #selector(onDidLockInterface), name: .KLockButtonLocked, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onDidUnlockInterface), name: .KLockButtonUnlocked, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onDidEditImage), name: .KImageEdited, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onDidResetImage), name: .KImageReset, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: .KLockButtonLocked, object: nil)
            NotificationCenter.default.removeObserver(self, name: .KLockButtonUnlocked, object: nil)
            NotificationCenter.default.removeObserver(self, name: .KImageEdited, object: nil)
            NotificationCenter.default.removeObserver(self, name: .KImageReset, object: nil)
        }
    }

    deinit {
        configureObservers(add: false)
    }

    @objc func onDidLockInterface() {
        displayTools(show: false, animated: true)
        viewModel.previousBrightness = UIScreen.main.brightness
        adjustBrightness(brightness: 1)
        dimLockButton(alpha: 0.25)
        adjustImageMargins(reset: false)
    }

    @objc func onDidUnlockInterface() {
        displayTools(show: true, animated: true)
        adjustBrightness(brightness: viewModel.previousBrightness)
        dimLockButton(alpha: 1.0)
        adjustImageMargins(reset: true)
    }

    @objc func onDidEditImage() {
        resetButton.isEnabled = true
    }

    @objc func onDidResetImage() {
        resetButton.isEnabled = false
        displaySlices(show: false, animated: true) { [weak self] _ in
            self?.removeSlices()
        }
    }

    func dimLockButton(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.lockButton.alpha = alpha
        }
    }

    func adjustBrightness(brightness: CGFloat) {
        UIScreen.main.brightness = brightness
    }

    func adjustImageMargins(reset: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.imageViewLeading.constant = reset ? 0 : self.viewModel.margin
            self.imageViewTrailing.constant = reset ? 0 : self.viewModel.margin
            self.imageView.setNeedsLayout()
            self.imageView.layoutIfNeeded()
        }
    }

    func bindViewModel() {
        viewModel.imageChanged = { [weak self] image in
            self?.setImage(image)
            self?.dismiss(animated: true) { [weak self] in
                self?.configureTools(enable: true)
            }
        }

        viewModel.slicesChanged = { [weak self] slices in
            guard !slices.isEmpty else { return }
            UIView.performWithoutAnimation {
                self?.removeSlices()
                self?.addSlices(slices)
                self?.setImage(slices.first)
                self?.view.layoutIfNeeded()
            }
            self?.displaySlices(show: true, animated: true)
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self.viewModel
            picker.mediaTypes = [kUTTypeImage as String]
            self.present(picker, animated: true)
        }
    }

    @IBAction func toggleGrayscaleImage(_ sender: Any) {
        viewModel.convertToGrayScale()
    }

    @IBAction func sliceImage(_ sender: Any) {
        viewModel.sliceImage()
    }

    func removeSlices() {
        slices.subviews.forEach { $0.removeFromSuperview() }
    }

    func addSlices(_ slices: [UIImage]) {
        slices.forEach(addSlice(_:))
    }
    func addSlice(_ slice: UIImage) {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = slice
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(sliceTapped(sender:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        slices.addArrangedSubview(imageView)
    }

    @objc func sliceTapped(sender: UITapGestureRecognizer) {
        setImage((sender.view as? UIImageView)?.image)
    }

    func displayToolbar(show: Bool, animated: Bool) {
        toolbarLeading.constant = show ? 0 : -100
        guard animated else { return }
        UIView.animate(withDuration: 1) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func displaySlices(show: Bool, animated: Bool, completion: ((Bool)->())? = nil) {
        slicesBottom.constant = show ? 0 : -100
        guard animated else {
            completion?(true)
            return
        }
        UIView.transition(with: self.view, duration: 1, options: .curveEaseInOut, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: completion)
    }

    func displayTools(show: Bool, animated: Bool) {
        displaySlices(show: viewModel.isSliced ? show : false, animated: animated)
        displayToolbar(show: show, animated: animated)
    }

    func configureTools(enable: Bool) {
        tools.forEach { tool in
            tool.isEnabled = enable
        }
    }

    func configureToolbarAppearance() {
        toolbarBackground.layer.shadowPath = UIBezierPath(rect: toolbarBackground.bounds).cgPath
        toolbarBackground.layer.shadowOpacity = 0.5
        toolbarBackground.layer.shadowRadius = 5
        toolbarBackground.layer.shadowColor = UIColor.black.cgColor
        toolbarBackground.layer.shadowOffset = .zero
        toolbarBackground.layer.masksToBounds = false

        let gradientBackground = CAGradientLayer()
        gradientBackground.colors = [UIColor(named: "sunshine")!.cgColor, UIColor(named: "lemonade")!.cgColor]
        gradientBackground.locations = [0.0, 1.0]
        gradientBackground.frame = toolbarBackground.bounds
        toolbarBackground.layer.addSublayer(gradientBackground)
    }

    @IBAction func resetAction(_ sender: Any) {
        viewModel.resetImage()
    }

    func setImage(_ image: UIImage?, completion: ((Bool)->())? = nil) {
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: completion)
    }
}
