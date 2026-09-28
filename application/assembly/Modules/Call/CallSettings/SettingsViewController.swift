//
//  SettingsViewController.swift
//  AppAssembly
//

import Foundation
import TUICore
import UIKit
import AtomicXCore

#if canImport(TUICallKit_Swift)
import TUICallKit_Swift
#elseif canImport(TUICallKit)
import TUICallKit
#endif

class SettingsViewController: UIViewController, UITextFieldDelegate {
    private var currentTextField: UITextField?
    
    private let scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private let scrollContentView: UIView = {
        return UIView(frame: CGRect.zero)
    }()
    
    private let basicSettingContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor("AAAAAA")
        return view
    }()
    private lazy var basicSettingLabel: UILabel = {
        return createLabel(textSize: 16, text: CallingLocalize("assembly_call_settings_basic"))
    }()
    
    private let ringContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    private lazy var ringLabel: UILabel = {
        return createLabel(textSize: 16, text: CallingLocalize("assembly_call_settings_ring_setting"))
    }()
    private lazy var ringInfoLabel: UILabel = {
        let place: String = SettingsConfig.share.ringUrl.isEmpty ?
            CallingLocalize("assembly_call_settings_not_set") : SettingsConfig.share.ringUrl
        let view = createLabel(textSize: 16, text: place)
        view.textColor = UIColor("AAAAAA")
        view.textAlignment = .right
        return view
    }()
    private lazy var ringAvBtn: UILabel = {
        let view = createLabel(textSize: 16, text: " > ")
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var muteSwitchView: UIView = {
        let customSwitchView = SettingsCustomSwitchView(title: CallingLocalize("assembly_call_settings_mute_mode"),
                                                        isOn: SettingsConfig.share.mute)
        customSwitchView.switchValueChanged = { [weak self] isOn in
            self?.muteSwitchClick(isOn)
        }
        return customSwitchView
    }()
    private lazy var floatingSwitchView: UIView = {
        let customSwitchView = SettingsCustomSwitchView(title: CallingLocalize("assembly_call_settings_enable_floating"),
                                                        isOn: SettingsConfig.share.floatWindow)
        customSwitchView.switchValueChanged = { [weak self] isOn in
            self?.floatingSwitchClick(isOn)
        }
        return customSwitchView
    }()
#if canImport(TUICallKit_Swift)
    private lazy var virtualBackgroundSwitchView: SettingsCustomSwitchView = {
        let customSwitchView = SettingsCustomSwitchView(title: CallingLocalize("assembly_call_settings_enable_virtual_bg"),
                                                        isOn: SettingsConfig.share.enableVirtualBackground)
        customSwitchView.switchValueChanged = { [weak self] isOn in
            self?.virtualBackgroundSwitchClick(isOn)
        }
        return customSwitchView
    }()
    private lazy var incomingBannerSwitchView: SettingsCustomSwitchView = {
        let customSwitchView = SettingsCustomSwitchView(title: CallingLocalize("assembly_call_settings_enable_incoming_banner"),
                                                        isOn: SettingsConfig.share.enableIncomingBanner)
        customSwitchView.switchValueChanged = { [weak self] isOn in
            self?.incomingBannerSwitchClick(isOn)
        }
        return customSwitchView
    }()
#endif
    private let callSettingContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor("AAAAAA")
        return view
    }()
    private lazy var callSettingLabel: UILabel = {
        return createLabel(textSize: 16, text: CallingLocalize("assembly_call_settings_call_params"))
    }()
    private let timeoutContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    private lazy var timeoutLabel: UILabel = {
        return createLabel(textSize: 16, text: CallingLocalize("assembly_call_settings_timeout"))
    }()
    private lazy var timeoutTextField: UITextField = {
        let timeoutTextField = createTextField(text: "30")
        timeoutTextField.keyboardType = .phonePad
        return timeoutTextField
    }()
    
    private let extendedInfoContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    private lazy var extendedInfoLabel: UILabel = {
        return createLabel(textSize: 16, text: CallingLocalize("assembly_call_settings_extended_info"))
    }()
    private lazy var extendedInfo: UILabel = {
        let place = SettingsConfig.share.userData.isEmpty ?
            CallingLocalize("assembly_call_settings_not_set") : SettingsConfig.share.userData
        let view = createLabel(textSize: 16, text: place)
        view.textColor = UIColor("AAAAAA")
        view.textAlignment = .right
        return view
    }()
    private lazy var extendedBtn: UILabel = {
        let view = createLabel(textSize: 16, text: " > ")
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppAssemblyBundle.image(named: "calling_back"), for: .normal)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let current = currentTextField {
            current.resignFirstResponder()
            currentTextField = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    private func updateView() {
        ringInfoLabel.text = SettingsConfig.share.ringUrl.isEmpty ?
        CallingLocalize("assembly_call_settings_not_set") : SettingsConfig.share.ringUrl
        extendedInfo.text = SettingsConfig.share.userData.isEmpty ?
        CallingLocalize("assembly_call_settings_not_set") : SettingsConfig.share.userData
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func constructViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(basicSettingContentView)
        basicSettingContentView.addSubview(basicSettingLabel)
        
        scrollContentView.addSubview(ringContentView)
        ringContentView.addSubview(ringLabel)
        ringContentView.addSubview(ringInfoLabel)
        ringContentView.addSubview(ringAvBtn)
        
        scrollContentView.addSubview(muteSwitchView)
        scrollContentView.addSubview(floatingSwitchView)
        
#if canImport(TUICallKit_Swift)
        scrollContentView.addSubview(virtualBackgroundSwitchView)
        scrollContentView.addSubview(incomingBannerSwitchView)
#endif
        
        scrollContentView.addSubview(callSettingContentView)
        callSettingContentView.addSubview(callSettingLabel)
        
        scrollContentView.addSubview(timeoutContentView)
        timeoutContentView.addSubview(timeoutLabel)
        timeoutContentView.addSubview(timeoutTextField)
        
        scrollContentView.addSubview(extendedInfoContentView)
        extendedInfoContentView.addSubview(extendedInfoLabel)
        extendedInfoContentView.addSubview(extendedInfo)
        extendedInfoContentView.addSubview(extendedBtn)
    }
    
    private func activateConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        basicSettingContentView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(30)
        }
        basicSettingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        ringContentView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(basicSettingLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        ringLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        ringAvBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(30)
        }
        ringInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(ringAvBtn.snp.leading)
            make.leading.equalTo(ringLabel.snp.trailing).offset(20)
        }
        muteSwitchView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(ringContentView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        floatingSwitchView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(muteSwitchView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
#if canImport(TUICallKit_Swift)
        virtualBackgroundSwitchView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(floatingSwitchView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        incomingBannerSwitchView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(virtualBackgroundSwitchView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        callSettingContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(incomingBannerSwitchView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
#elseif canImport(TUICallKit)
        callSettingContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(floatingSwitchView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
#endif
        callSettingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        timeoutContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(callSettingContentView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        timeoutLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        timeoutTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalTo(timeoutLabel.snp.trailing).offset(20)
        }
        
        extendedInfoContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(timeoutContentView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        extendedInfoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        extendedBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(30)
        }
        extendedInfo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(extendedInfoLabel.snp.trailing).offset(20)
            make.trailing.equalTo(extendedBtn.snp.leading)
        }
    }
    
    private func bindInteraction() {
        let ringAvBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(ringAvBtnClick))
        ringAvBtn.addGestureRecognizer(ringAvBtnTapGesture)
        
        let extendedBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(extendClick))
        extendedBtn.addGestureRecognizer(extendedBtnTapGesture)
        
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
    }
    
    @objc private func ringAvBtnClick() {
        let offlinePushVC = SettingDetailViewController(type: .ringInfo)
        offlinePushVC.title = CallingLocalize("assembly_call_settings_set_ring")
        offlinePushVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(offlinePushVC, animated: true)
    }
    
    @objc private func extendClick() {
        let extendVC = SettingDetailViewController(type: .entendInfo)
        extendVC.title = CallingLocalize("assembly_call_settings_set_extend")
        extendVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(extendVC, animated: true)
    }
    private func muteSwitchClick(_ isOn: Bool) {
        SettingsConfig.share.mute = isOn
        TUICallKit.createInstance().enableMuteMode(enable: isOn)
    }
    private func floatingSwitchClick(_ isOn: Bool) {
        SettingsConfig.share.floatWindow = isOn
        TUICallKit.createInstance().enableFloatWindow(enable: isOn)
    }
#if canImport(TUICallKit_Swift)
    private func virtualBackgroundSwitchClick(_ isOn: Bool) {
        SettingsConfig.share.enableVirtualBackground = isOn
        TUICallKit.createInstance().enableVirtualBackground(enable: isOn)
    }
    private func incomingBannerSwitchClick(_ isOn: Bool) {
        SettingsConfig.share.enableIncomingBanner = isOn
        TUICallKit.createInstance().enableIncomingBanner(enable: isOn)
    }
#endif
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    private func timeoutButtonClick(text: String) {
        if text.isEmpty {
            return
        }
        SettingsConfig.share.timeout = Int(text) ?? 30
        self.timeoutTextField.attributedPlaceholder = NSAttributedString(string: String(SettingsConfig.share.timeout))
    }
}

extension SettingsViewController {
    func createTextField(text: String) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: "PingFangSC-Regular", size: 16)
        textField.textColor = UIColor("333333")
        textField.attributedPlaceholder = NSAttributedString(string: text)
        textField.textAlignment = .right
        textField.delegate = self
        return textField
    }
    
    func createLabel(textSize: CGFloat, text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: textSize)
        label.textColor = .black
        label.text = text
        return label
    }
    
}

extension SettingsViewController {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let last = currentTextField {
            last.resignFirstResponder()
        }
        currentTextField = textField
        textField.becomeFirstResponder()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        currentTextField = nil
        
        guard let text = textField.text else { return }
        if textField == timeoutTextField {
            timeoutButtonClick(text: text)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
