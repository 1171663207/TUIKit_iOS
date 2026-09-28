//
//  SettingDetailViewController.swift
//  AppAssembly
//

import Foundation
import UIKit
import TUICore
import AtomicX

#if canImport(TUICallKit_Swift)
import TUICallKit_Swift
#elseif canImport(TUICallKit)
import TUICallKit
#endif

class SettingDetailViewController: UIViewController, UITextViewDelegate {
    enum DetailType{
        case ringInfo
        case entendInfo
    }
    private var detail: DetailType
    
    init(type: DetailType) {
        self.detail = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.font = UIFont(name: "PingFangSC-Regular", size: 16)
        view.textColor = UIColor("333333")
        view.textAlignment = .left
        view.isScrollEnabled = true
        return view
    }()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppAssemblyBundle.image(named: "calling_back"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CallingLocalize("assembly_call_btn_confirm"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        setTextView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: confirmButton)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func constructViewHierarchy() {
        view.addSubview(textView)
    }
    
    private func activateConstraints() {
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100.scale375Height())
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindInteraction() {
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        textView.delegate = self
    }
    
    private func setTextView() {
        switch detail {
        case .ringInfo:
            textView.text = CallingLocalize("assembly_call_settings_set_ring_tip")
        case .entendInfo:
            textView.text = CallingLocalize("assembly_call_settings_set_extend_tip")
        }
    }
    
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonClick() {
        guard let textString = textView.text else { return }
        switch detail {
        case .ringInfo:
            ringSetting(text: textString)
        case .entendInfo:
            entendInfoSetting(text: textString)
        }
    }
        
    private func ringSetting(text: String) {
        if text.isEmpty {
            return
        }
        TUICallKit.createInstance().setCallingBell(filePath: text)
        SettingsConfig.share.ringUrl = text
        view.showAtomicToast(text: "Set Successful: \(SettingsConfig.share.ringUrl)")
    }
    
    private func entendInfoSetting(text: String) {
        if text.isEmpty {
            return
        }
        SettingsConfig.share.userData = text
        view.showAtomicToast(text: "Set Successful: \(text)")
    }
}
