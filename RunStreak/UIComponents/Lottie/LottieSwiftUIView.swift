//
//  LottieSwiftUIView.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 26.10.25.
//

import DotLottie
import SwiftUI

public struct LottieSwiftUIView: UIViewRepresentable {
  private let name: String
  private let loop: Bool
  private let onStart: () -> Void
  private let onEnded: () -> Void
  private let onPause: () -> Void

  public init(
    name: String,
    loop: Bool = true,
    onStart: @escaping () -> Void = {},
    onEnded: @escaping () -> Void = {},
    onPause: @escaping () -> Void = {}
  ) {
    self.name = name
    self.loop = loop
    self.onStart = onStart
    self.onEnded = onEnded
    self.onPause = onPause
  }

  public func makeUIView(context: Context) -> DotLottieAnimationView {
    let view = DotLottieAnimationView(dotLottieViewModel: .init(fileName: name, bundle: .main, config: .init(autoplay: true, loop: loop)))
    let observer = DotLottieObserver(onEnded: onEnded, onStart: onStart, onPauseAction: onPause)
    view.subscribe(observer: observer)

    return view
  }

  public func updateUIView(_ uiView: DotLottieAnimationView, context: Context) {
    // No dynamic updates needed
  }
}

public class DotLottieObserver: Observer {
  private let onEnded: () -> Void
  private let onStart: () -> Void
  private let onPauseAction: () -> Void

  public init(
    onEnded: @escaping () -> Void = {},
    onStart: @escaping () -> Void = {},
    onPauseAction: @escaping () -> Void = {}
  ) {
    self.onEnded = onEnded
    self.onStart = onStart
    self.onPauseAction = onPauseAction
  }

  public func onComplete() {
    onEnded()
  }

  public func onFrame(frameNo: Float) {
    // New frame rendered
  }

  public func onLoad() {
    // Animation loaded successfully
  }

  public func onLoadError() {
    // Animation failed to load
  }

  public func onLoop(loopCount: UInt32) {
    // Animation completed a loop
  }

  public func onPause() {
    onPauseAction()
  }

  public func onPlay() {
    onStart()
  }

  public func onRender(frameNo: Float) {
    // Frame rendered
  }

  public func onStop() {
    // Animation stopped
  }
}
