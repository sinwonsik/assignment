//
//  LoadingIndicator.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/25/24.
//

import UIKit

/// 앱 전반에서 사용할 로딩 인디케이터
class LoadingIndicator {
    
    static let shared = LoadingIndicator()
    
    
    private var spinner: UIActivityIndicatorView?
    private var loadingView: UIView?
    
    private init() {}
    
    func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        loadingView = UIView(frame: window.bounds)
        loadingView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        spinner = UIActivityIndicatorView(style: .large)
        spinner?.center = loadingView!.center
        spinner?.startAnimating()
        
        loadingView?.addSubview(spinner!)
        window.addSubview(loadingView!)
    }
    
    func hide() {
        spinner?.stopAnimating()
        loadingView?.removeFromSuperview()
        spinner = nil
        loadingView = nil
    }
}
