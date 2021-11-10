//
//  AuthorizationViewController.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import UIKit

class AuthorizationViewController: UIViewController {

    lazy private var emailTextField = makeEmailTextField()
    lazy private var nameTextField = makeLoginTextField()
    lazy private var passwordTextField = makePasswordTextField()
    lazy private var signInButton = makeSignInButton()
    lazy private var signUpButton = makeSignUpButton()

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

// MARK: - UI

private extension AuthorizationViewController {

    func configureUI() {
        view.backgroundColor = .white
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, nameTextField, passwordTextField])
        textFieldsStackView.spacing = 28
        textFieldsStackView.axis = .vertical
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldsStackView)

        let buttonsStackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        buttonsStackView.spacing = 24
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldsStackView)

        let overallStackView = UIStackView(arrangedSubviews: [textFieldsStackView, buttonsStackView])
        overallStackView.spacing = 52
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overallStackView)

        NSLayoutConstraint.activate([
            overallStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overallStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }

    func makeSignInButton() -> TCCButton {
        let button = TCCButton(backgroundColor: .mainBlue, title: "Login")
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        return button
    }
    
    func makeSignUpButton() -> TCCButton {
        let button = TCCButton(backgroundColor: .mainBlue, textColor: .white, title: "Sign Up")
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)

        return button
    }

    func makeLoginTextField() -> TCCTextField {
        let textField = TCCTextField(placeholder: "Name")
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 260).isActive = true

        return textField
    }

    func makeEmailTextField() -> TCCTextField {
        let textField = TCCTextField(placeholder: "Email")
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 260).isActive = true

        return textField
    }

    func makePasswordTextField() -> TCCTextField {
        let textField = TCCTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 260).isActive = true

        return textField
    }

}

// MARK: - Private
private extension AuthorizationViewController {
    @objc func didTapSignUp() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            showError(error: "Please fill name, email and password fields")
            return
        }
        networkClient.performSignUp(name: name, email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                KeyChain.shared["token"] = response.data.accessToken
                self.moveToCharsListScreen()
            case .failure(let error):
                self.showError(error: error.reason)
            }
        }
    }
    
    @objc func didTapSignIn() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            showError(error: "Please fill email and password fields")
            return
        }
        networkClient.performSignIn(email: "test111@mail.com", password: "123123123a") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                KeyChain.shared["token"] = response.data.accessToken
                self.moveToCharsListScreen()
            case .failure(let error):
                self.showError(error: error.localizedDescription)
            }
        }
    }
}

// MARK: - Navigation -> should be removed to coord
private extension AuthorizationViewController {
    func moveToCharsListScreen() {
        navigationController?.pushViewController(CharCounterListViewController(networkClient: networkClient), animated: true)
    }
}
