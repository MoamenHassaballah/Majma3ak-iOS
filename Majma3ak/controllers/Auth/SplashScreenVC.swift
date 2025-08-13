import UIKit

class SplashScreenVC: UIViewController {

    // MARK: - UI Elements

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        
        // Style to match the image
        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.35)
        
        // --- Customizing the corner radius ---
        // Set the corner radius for the outer track
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        
        // Set the corner radius for the inner progress bar
        // This is a common technique to make the inner bar rounded as well.
        progressView.layer.sublayers?[1].cornerRadius = 8
        progressView.subviews[1].clipsToBounds = true
        
        return progressView
    }()
    
    // MARK: - Properties
    
    private var timer: Timer?
    private let animationDuration: TimeInterval = 3.0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateProgressBar()
    }

    // MARK: - UI Setup

    private func setupUI() {
        // 1. Set the correct background color from the image (a light orange)
        // I have picked a color that closely matches your image.
        view.backgroundColor = .customColorFont
        
        // 2. Add subviews directly to the main view, not a stack view
        view.addSubview(logoImageView)
        view.addSubview(progressView)
        
        // 3. Set up Auto Layout constraints for precise positioning
        NSLayoutConstraint.activate([
            // --- Logo Constraints ---
            // Center the logo horizontally
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Position the logo above the progress bar with 30 points of spacing
            logoImageView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            // Set the size of the logo
            logoImageView.widthAnchor.constraint(equalToConstant: 194),
            logoImageView.heightAnchor.constraint(equalToConstant: 147),
            // --- Progress Bar Constraints ---
            // Position the progress bar slightly below the vertical center of the screen
            progressView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            // Set the width of the progress bar to be 60 points from each side
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            // Set the height (thickness) of the progress bar
            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    // MARK: - Animation and Transition

    private func animateProgressBar() {
        // This logic remains the same as it correctly handles the animation.
        self.progressView.setProgress(0.0, animated: false)
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }

    @objc private func updateProgress() {
        let progressIncrement = Float(0.05 / animationDuration)
        let newProgress = progressView.progress + progressIncrement
        progressView.setProgress(newProgress, animated: true)

        if newProgress >= 1.0 {
            timer?.invalidate()
            timer = nil
            // Wait a brief moment for the animation to feel complete before transitioning
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.transitionToMainNavigator()
            }
        }
    }

    private func transitionToMainNavigator() {
        
        // Make sure your MainNaigationController has the Storyboard ID "MainNaigationControllerID"
        guard let mainNav = self.storyboard?.instantiateViewController(withIdentifier: "MainNaigationController") as? MainNaigationController else {
            fatalError("Could not instantiate MainNaigationController. Check that its Storyboard ID is set to 'MainNaigationControllerID' in your storyboard file.")
        }

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainNav)
    }
}
