/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import AVKit
import Combine
import UIKit

protocol CustomPlayerControlsViewDelegate: AnyObject {
  func controlsViewDidRequestStartPictureInPicture(_ controlsView: CustomPlayerControlsView)

  func controlsViewDidRequestStopPictureInPicture(_ controlsView: CustomPlayerControlsView)

  func controlsViewDidRequestControlsDismissal(_ controlsView: CustomPlayerControlsView)

  func controlsViewDidRequestPlayerDismissal(_ controlsView: CustomPlayerControlsView)
    
  func controlsViewDidRequestPlayerOut(_ controlsView: CustomPlayerControlsView)
}

class CustomPlayerControlsView: UIView {
  
  weak var delegate: CustomPlayerControlsViewDelegate?

  private weak var player: AVPlayer?
  private weak var pipController: AVPictureInPictureController?

  private lazy var spacerView = UIView()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()
    private var closePlayerButton: CustomPlayerCircularButtonView?

  private lazy var progressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
  }()

  private var progressTimer: Timer?
  private var canStopPictureInPictureCancellable: Cancellable?

  init(player: AVPlayer?, pipController: AVPictureInPictureController?) {
    self.player = player
    self.pipController = pipController

    super.init(frame: .zero)

    setupViewLayout()

    let progressTimer = Timer(
      timeInterval: 0.5,
      repeats: true
    ) { [weak self] _ in
      guard
        let player = player,
        let item = player.currentItem
      else {
        return
      }

      let progress = CMTimeGetSeconds(player.currentTime()) / CMTimeGetSeconds(item.duration)

      self?.progressView.progress = Float(progress)
    }
    self.progressTimer = progressTimer

    RunLoop.main.add(progressTimer, forMode: .default)

    let menuGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(menuGestureHandler))

    menuGestureRecognizer.allowedPressTypes = [UIPress.PressType.menu].map {
      $0.rawValue as NSNumber
    }
    addGestureRecognizer(menuGestureRecognizer)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    progressTimer?.invalidate()
    progressTimer = nil
    canStopPictureInPictureCancellable = nil
  }

  private func setupViewLayout() {
    #if os(tvOS)
    let canStopPiP = pipController?.canStopPictureInPicture ?? false
    #else
    let canStopPiP = false
    #endif

    spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    updatePiPButtons(canStopPiP: canStopPiP)

    #if os(tvOS)
    canStopPictureInPictureCancellable = pipController?.publisher(
      for: \.canStopPictureInPicture)
      .sink { [weak self] in
        self?.updatePiPButtons(canStopPiP: $0)
      }
    #endif

    addSubview(progressView)
    NSLayoutConstraint.activate([
      progressView.heightAnchor.constraint(equalToConstant: 10),
      progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
      progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    addSubview(buttonStackView)
    NSLayoutConstraint.activate([
      buttonStackView.heightAnchor.constraint(equalToConstant: 90),
      buttonStackView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -40),
      buttonStackView.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: 3 / 4),
      buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
    ])
  }

  private func updatePiPButtons(canStopPiP: Bool) {
    let buttonSideLength: CGFloat = 50

    var buttons: [UIButton] = []

    let startButton = CustomPlayerCircularButtonView(symbolName: "pip.enter", height: buttonSideLength)
    startButton.addTarget(self, action: #selector(startButtonPressed), for: [.primaryActionTriggered, .touchUpInside])
    buttons.append(startButton)

    if canStopPiP {
      let stopButton = CustomPlayerCircularButtonView(symbolName: "pip.exit", height: buttonSideLength)
      stopButton.addTarget(self, action: #selector(stopButtonPressed), for: [.primaryActionTriggered, .touchUpInside])
      buttons.append(stopButton)
    }

    #if os(iOS)
    closePlayerButton = CustomPlayerCircularButtonView(symbolName: "xmark", height: buttonSideLength)
      guard let closePlayerButton = closePlayerButton else {  return }

    closePlayerButton.addTarget(self, action: #selector(closePlayerPressed), for: .touchUpInside)
    buttons.append(closePlayerButton)
    #endif

    let existingButtons = buttonStackView.arrangedSubviews
    for view in existingButtons {
      view.removeFromSuperview()
    }
    buttonStackView.addArrangedSubview(spacerView)
    for button in buttons {
      buttonStackView.addArrangedSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: buttonSideLength),
        button.heightAnchor.constraint(equalToConstant: buttonSideLength)
      ])
    }
  }

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if let nextButton = context.nextFocusedView as? CustomPlayerCircularButtonView {
      nextButton.backgroundColor = .white
      nextButton.tintColor = .darkGray
    }

    if let previousButton = context.previouslyFocusedView as? CustomPlayerCircularButtonView {
      previousButton.backgroundColor = .darkGray
      previousButton.tintColor = .white
    }
  }

  @objc private func startButtonPressed() {
    delegate?.controlsViewDidRequestStartPictureInPicture(self)
  }

  @objc private func stopButtonPressed() {
    delegate?.controlsViewDidRequestStopPictureInPicture(self)
  }

  @objc private func closePlayerPressed() {
      closePlayerButton?.isSelected.toggle()
      if closePlayerButton!.isSelected {
          delegate?.controlsViewDidRequestPlayerDismissal(self)
         // AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
      } else {
          delegate?.controlsViewDidRequestPlayerOut(self)
         // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
      }
      
    
  }

  @objc private func menuGestureHandler(recognizer: UITapGestureRecognizer) {
    switch recognizer.state {
    case .ended:
      delegate?.controlsViewDidRequestControlsDismissal(self)
    default:
      break
    }
  }
}
