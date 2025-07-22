//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameVC: UIViewController {
    @IBOutlet weak var questionNumberLabel: InfoLabel!
    @IBOutlet weak var questionLabel: QuestionLabel!
    @IBOutlet weak var buttonFirst: AnswerButton!
    @IBOutlet weak var buttonSecond: AnswerButton!
    @IBOutlet weak var timeLabel: TimerLabel!
    @IBOutlet weak var buttonThird: AnswerButton!
    @IBOutlet weak var scoreLabel: InfoLabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - Visual Effect Layers
    private let spaceBackgroundLayer = CAGradientLayer()        // Uzay arka planı
    private let nebulaLayer = CAGradientLayer()                 // Nebula efekti
    private let starFieldLayer = CAEmitterLayer()               // Yıldız alanı
    private let timeWarningLayer = CAShapeLayer()               // Zaman uyarısı
    
    // MARK: - Properties
    private var viewModel: GameScreenViewModelProtocol!        // ViewModel referansı
    private weak var coordinator: AppCoordinator!              // Coordinator referansı
    private let selectedExpressionType: MathExpression.ExpressionType // Seçili matematik türü
    
    // MARK: - Answer Buttons Array
    /// Cevap butonlarının dizisi - kolayca erişim için
    private var answerButtons: [AnswerButton] {
        return [buttonFirst, buttonSecond, buttonThird]
    }
    
    // MARK: - Initializer
    /// GameVC başlatıcı metodu
    /// - Parameters:
    ///   - viewModel: Game ViewModel (opsiyonel, nil ise oluşturulacak)
    ///   - coordinator: App Coordinator referansı
    ///   - selectedExpressionType: Matematik işlem türü
    init(viewModel: GameScreenViewModelProtocol? = nil,
         coordinator: AppCoordinator,
         selectedExpressionType: MathExpression.ExpressionType) {
        
        self.coordinator = coordinator
        self.selectedExpressionType = selectedExpressionType
        super.init(nibName: "GameVC", bundle: nil)
        
        // ViewModel'i ayarla
        self.viewModel = viewModel ?? GameScreenViewModel(
            delegate: nil,
            expressionType: selectedExpressionType
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        print("🎮 GameVC yüklendi - Tip: \(selectedExpressionType.displayName)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateVisualEffects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation bar'ı gizle
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // ViewModel'i temizle
        viewModel.endGame()
    }
    
    // MARK: - Setup Methods
    
    /// View controller'ı başlangıç ayarlarını yapar
    private func setupViewController() {
        configureViewModel()           // ViewModel'i yapılandır
        setupSpaceBackground()         // Uzay arka planını oluştur
        setupUIElements()              // UI bileşenlerini ayarla
        setupTimeWarningEffect()       // Zaman uyarısı efektini hazırla
        startGame()                    // Oyunu başlat
        
        // Navigation ayarları
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /// ViewModel'i yapılandırır ve delegate'i ayarlar
    private func configureViewModel() {
        // Eğer viewModel nil ise yeni bir tane oluştur
        if viewModel == nil {
            viewModel = GameScreenViewModel(
                delegate: self,
                expressionType: selectedExpressionType
            )
        }
        
        // Delegate'i kendisi olarak ayarla
        if let gameViewModel = viewModel as? GameScreenViewModel {
            gameViewModel.delegate = self
        }
        
        print("🔧 ViewModel yapılandırıldı")
    }
    
    /// Oyunu başlatır
    private func startGame() {
        viewModel.startGame()
        print("🚀 Oyun başlatıldı")
    }
    
    // MARK: - UI Setup Methods
    
    /// UI bileşenlerini başlangıç ayarlarını yapar
    private func setupUIElements() {
        // Skor etiketi
        scoreLabel.text = "Skor: 0"
        scoreLabel.cosmicTheme = .score
        
        // Soru numarası etiketi
        questionNumberLabel.text = "1 / \(viewModel.totalQuestions)"
        questionNumberLabel.cosmicTheme = .questionNumber
        
        // Zaman etiketi
        timeLabel.text = "\(viewModel.timeRemaining)"
        
        // Cevap butonlarını başlangıç durumuna getir
        answerButtons.forEach { button in
            button.isEnabled = true
            button.resetToNormal()
        }
        
        print("🎨 UI bileşenleri ayarlandı")
    }
    
    /// Uzay temalı arka plan efektlerini oluşturur
    private func setupSpaceBackground() {
        view.backgroundColor = UIColor.Custom.backgroundDark1
        
        // Ana uzay arka planı
        spaceBackgroundLayer.colors = UIColor.Custom.spaceBackgroundColors
        spaceBackgroundLayer.locations = [0.0, 0.4, 0.7, 1.0]
        spaceBackgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        spaceBackgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(spaceBackgroundLayer, at: 0)
        
        // Nebula efekti
        nebulaLayer.colors = UIColor.Custom.nebulaGradientColors
        nebulaLayer.locations = [0.0, 0.5, 1.0]
        nebulaLayer.startPoint = CGPoint(x: 0.2, y: 0.2)
        nebulaLayer.endPoint = CGPoint(x: 0.8, y: 0.8)
        view.layer.insertSublayer(nebulaLayer, above: spaceBackgroundLayer)
        
        // Yıldız alanı
        setupStarField()
        
        print("🌌 Uzay arka planı oluşturuldu")
    }
    
    /// Yıldız alanı efektini oluşturur
    private func setupStarField() {
        starFieldLayer.emitterPosition = CGPoint(x: 200, y: 0)
        starFieldLayer.emitterSize = CGSize(width: 400, height: 900)
        starFieldLayer.renderMode = .additive
        
        let star = CAEmitterCell()
        star.contents = createStarImage().cgImage
        star.birthRate = 25
        star.lifetime = Float.infinity
        star.velocity = 0
        star.emissionRange = .pi * 2
        star.scale = 0.4
        star.scaleRange = 0.3
        star.alphaRange = 0.6
        star.color = UIColor.Custom.starFieldColor
        
        starFieldLayer.emitterCells = [star]
        view.layer.insertSublayer(starFieldLayer, above: nebulaLayer)
    }
    
    /// Yıldız resmi oluşturur
    /// - Returns: Yıldız UIImage'i
    private func createStarImage() -> UIImage {
        let size = CGSize(width: 3, height: 3)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Zaman uyarısı efektini hazırlar
    private func setupTimeWarningEffect() {
        timeWarningLayer.fillColor = UIColor.clear.cgColor
        timeWarningLayer.strokeColor = UIColor.Custom.timeWarningStrokeColor
        timeWarningLayer.lineWidth = 6
        timeWarningLayer.opacity = 0
        view.layer.addSublayer(timeWarningLayer)
    }
    
    /// Visual efektleri günceller (layout değişimlerinde)
    private func updateVisualEffects() {
        spaceBackgroundLayer.frame = view.bounds
        nebulaLayer.frame = view.bounds
        starFieldLayer.frame = view.bounds
        starFieldLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        backgroundImage.frame = view.bounds
        
        // Zaman uyarısı path'i
        let warningPath = UIBezierPath()
        warningPath.move(to: CGPoint(x: 20, y: view.bounds.height - 20))
        warningPath.addLine(to: CGPoint(x: view.bounds.width - 20, y: view.bounds.height - 20))
        timeWarningLayer.path = warningPath.cgPath
    }
    
    // MARK: - Game Logic Methods
    
    /// UI'ı soru ve cevaplarla günceller
    /// - Parameters:
    ///   - question: Soru metni
    ///   - answers: Cevap seçenekleri
    private func updateQuestionUI(question: String, answers: [String]) {
        // Soru metnini animasyonlu güncelle
        questionLabel.animateTextChange(newText: question)
        
        // Cevap butonlarını güncelle
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            for (index, button) in self.answerButtons.enumerated() {
                if index < answers.count {
                    button.setTitle(answers[index], for: .normal)
                    button.isHidden = false
                } else {
                    button.isHidden = true
                }
            }
        }
        
        print("🔄 UI güncellendi - Soru: \(question)")
    }
    
    /// Cevap butonuna tıklanma işlemini yönetir
    /// - Parameter button: Tıklanan buton
    private func handleAnswerButtonTap(for button: AnswerButton) {
        guard let selectedAnswerText = button.title(for: .normal) else {
            print("❌ Cevap metni alınamadı")
            return
        }
        
        // String'i Double'a çevir
        let selectedAnswer: Double
        if let intValue = Int(selectedAnswerText) {
            selectedAnswer = Double(intValue)
        } else if let doubleValue = Double(selectedAnswerText) {
            selectedAnswer = doubleValue
        } else {
            print("❌ Geçersiz cevap formatı: \(selectedAnswerText)")
            return
        }
        
        // ViewModel'den cevabı kontrol et
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswer)
        
        // Cevap işlemini yönet
        handleAnswerFeedback(selectedButton: button, isCorrect: isCorrect)
        
        print("🎯 Cevap kontrol edildi: \(selectedAnswerText) - \(isCorrect ? "Doğru" : "Yanlış")")
    }
    
    /// Cevap verildikten sonraki geri bildirim işlemlerini yönetir
    /// - Parameters:
    ///   - selectedButton: Seçilen buton
    ///   - isCorrect: Cevap doğru mu?
    private func handleAnswerFeedback(selectedButton: AnswerButton, isCorrect: Bool) {
        // Tüm butonları devre dışı bırak
        answerButtons.forEach { $0.isEnabled = false }
        
        // Cevap animasyonu
        if isCorrect {
            selectedButton.triggerCorrectAnswer()
            showCorrectAnswerEffect()
        } else {
            selectedButton.triggerWrongAnswer()
            showWrongAnswerEffect()
        }
        
        // 1.2 saniye sonra sonraki soruya geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            
            // Butonları yeniden etkinleştir ve sıfırla
            self.answerButtons.forEach { button in
                button.isEnabled = true
                button.resetToNormal()
            }
            
            // Sonraki soruya geç
            self.viewModel.nextQuestion()
        }
    }
    
    // MARK: - Visual Effect Methods
    
    /// Doğru cevap efektini gösterir
    private func showCorrectAnswerEffect() {
        // Başarı arka plan efekti
        let successLayer = CALayer()
        successLayer.frame = view.bounds
        successLayer.backgroundColor = UIColor.Custom.successEffectBackground
        view.layer.addSublayer(successLayer)
        
        // Fade animasyonu
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.8
        successLayer.add(fadeAnimation, forKey: "fade")
        
        // Parçacık efekti
        createSuccessParticleEffect()
        
        // Temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            successLayer.removeFromSuperlayer()
        }
        
        print("✅ Doğru cevap efekti gösterildi")
    }
    
    /// Yanlış cevap efektini gösterir
    private func showWrongAnswerEffect() {
        // Ekran sarsıntısı
        let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shakeAnimation.fromValue = -10
        shakeAnimation.toValue = 10
        shakeAnimation.duration = 0.08
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 4
        view.layer.add(shakeAnimation, forKey: "shake")
        
        // Hata arka plan efekti
        let errorLayer = CALayer()
        errorLayer.frame = view.bounds
        errorLayer.backgroundColor = UIColor.Custom.wrongEffectBackground
        view.layer.addSublayer(errorLayer)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.6
        errorLayer.add(fadeAnimation, forKey: "fade")
        
        // Temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            errorLayer.removeFromSuperlayer()
        }
        
        print("❌ Yanlış cevap efekti gösterildi")
    }
    
    /// Başarı parçacık efekti oluşturur
    private func createSuccessParticleEffect() {
        let successEmitter = CAEmitterLayer()
        successEmitter.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        successEmitter.emitterSize = CGSize(width: 50, height: 50)
        
        let successParticle = CAEmitterCell()
        successParticle.contents = UIColor.Custom.successParticleColor
        successParticle.birthRate = 50
        successParticle.lifetime = 1.0
        successParticle.velocity = 100
        successParticle.velocityRange = 50
        successParticle.emissionRange = .pi * 2
        successParticle.scale = 0.5
        successParticle.scaleRange = 0.3
        successParticle.alphaSpeed = -1.0
        
        successEmitter.emitterCells = [successParticle]
        view.layer.addSublayer(successEmitter)
        
        // Temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            successEmitter.removeFromSuperlayer()
        }
    }
    
    /// Zaman uyarısı efektini başlatır
    private func startTimeWarningEffect() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.5
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        timeWarningLayer.add(pulseAnimation, forKey: "timeWarning")
        
        print("⚠️ Zaman uyarısı efekti başlatıldı")
    }
    
    /// Zaman uyarısı efektini durdurur
    private func stopTimeWarningEffect() {
        timeWarningLayer.removeAnimation(forKey: "timeWarning")
        timeWarningLayer.opacity = 0
        
        print("⏹️ Zaman uyarısı efekti durduruldu")
    }
    
    /// Oyun bitişi efektini gösterir
    /// - Parameter score: Final skoru
    private func showGameFinishEffect(score: Int) {
        let finishLayer = CAGradientLayer()
        finishLayer.frame = view.bounds
        
        // Skora göre renk seç
        if score >= 8 {
            finishLayer.colors = UIColor.Custom.finishEffectColorsHigh
        } else if score >= 6 {
            finishLayer.colors = UIColor.Custom.finishEffectColorsMedium
        } else {
            finishLayer.colors = UIColor.Custom.finishEffectColorsLow
        }
        
        view.layer.addSublayer(finishLayer)
        
        // Pulse animasyonu
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.6
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 4
        finishLayer.add(pulseAnimation, forKey: "pulse")
        
        // Temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            finishLayer.removeFromSuperlayer()
        }
        
        print("🏁 Oyun bitişi efekti gösterildi - Skor: \(score)")
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func answerFirstButton(_ sender: AnswerButton) {
        handleAnswerButtonTap(for: sender)
    }
    
    @IBAction func answerSecondButton(_ sender: AnswerButton) {
        handleAnswerButtonTap(for: sender)
    }
    
    @IBAction func answerThirdButton(_ sender: AnswerButton) {
        handleAnswerButtonTap(for: sender)
    }
    
    /// Memory warning alındığında çağrılır
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("⚠️ GameVC: Memory warning alındı")
        
        // Görsel efektleri temizle
        cleanupVisualEffects()
    }
    
    /// Görsel efektleri temizler
    private func cleanupVisualEffects() {
        starFieldLayer.removeFromSuperlayer()
        timeWarningLayer.removeFromSuperlayer()
        print("🧹 Görsel efektler temizlendi")
    }
    
    deinit {
        // ViewModel'i temizle
        viewModel?.endGame()
        
        // Katmanları temizle
        cleanupVisualEffects()
        
        print("🗑️ GameVC deinit edildi")
    }
}

// MARK: - GameScreenViewModelDelegate
extension GameVC: GameScreenViewModelDelegate {
    
    /// Soru güncellendi
    func didUpdateQuestion(questionText: String, answerOptions: [String]) {
        updateQuestionUI(question: questionText, answers: answerOptions)
    }
    
    /// Skor güncellendi
    func didUpdateScore(newScore: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.scoreLabel.animateTextChange(newText: "Skor: \(newScore)")
            self?.scoreLabel.activateHighlight()
        }
        print("📊 Skor güncellendi: \(newScore)")
    }
    
    /// Zaman güncellendi
    func didUpdateTime(formattedTime: String) {
        DispatchQueue.main.async { [weak self] in
            self?.timeLabel.animateTextChange(newText: formattedTime)
            
            // Zaman uyarısı kontrolü
            if let timeInt = Int(formattedTime) {
                if timeInt <= 10 && timeInt > 0 {
                    self?.timeLabel.triggerWarning()
                } else {
                    self?.timeLabel.resetToNormal()
                    self?.stopTimeWarningEffect()
                }
            }
        }
    }
    
    /// Soru numarası güncellendi
    func didUpdateQuestionNumber(current: Int, total: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.questionNumberLabel.animateTextChange(newText: "\(current) / \(total)")
        }
        print("🔢 Soru numarası: \(current)/\(total)")
    }
    
    /// Oyun bitti
    func didFinishGame(finalScore: Int, expressionType: MathExpression.ExpressionType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Bitişi efekti göster
            self.showGameFinishEffect(score: finalScore)
            
            // 2.5 saniye sonra sonuç ekranına git
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.coordinator?.goToResult(score: "\(finalScore)", expressionType: expressionType)
            }
        }
        
        print("🏆 Oyun bitti - Final skoru: \(finalScore)")
    }
    
    /// Countdown uyarısı başladı
    func didStartCountdownWarning() {
        DispatchQueue.main.async { [weak self] in
            self?.setupVibrantRocketLaunchAnimation()
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
        
        print("🚨 Countdown uyarısı başlatıldı")
    }
    
    /// Cevap verildi
    func didAnswerQuestion(isCorrect: Bool, correctAnswer: String) {
        // Bu delegate method'u UI tarafında zaten handle ediliyor
        // Ek işlemler gerekirse burada yapılabilir
        print("💭 Cevap işlendi: \(isCorrect ? "Doğru" : "Yanlış") - Doğru cevap: \(correctAnswer)")
    }
    
    /// Hata oluştu
    func didEncounterError(error: GameError) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Oyun Hatası",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { _ in
                self?.viewModel.startGame()
            })
            
            alert.addAction(UIAlertAction(title: "Ana Menü", style: .cancel) { _ in
                self?.coordinator?.goBackToHomeFromCategory()
            })
            
            self?.present(alert, animated: true)
        }
        
        print("❌ Oyun hatası: \(error.localizedDescription)")
    }
}

// MARK: - Countdown Animations
extension GameVC {
    
    /// Canlı roket fırlatma animasyonu
    private func setupVibrantRocketLaunchAnimation() {
        let spaceshipContainer = UIView()
        spaceshipContainer.frame = CGRect(x: view.bounds.width / 2 - 40, y: view.bounds.height + 200, width: 80, height: 200)
        view.addSubview(spaceshipContainer)
        
        // Roket gövdesi
        let rocketBody = CAShapeLayer()
        let bodyPath = UIBezierPath()
        bodyPath.move(to: CGPoint(x: 35, y: 170))
        bodyPath.addLine(to: CGPoint(x: 45, y: 170))
        bodyPath.addLine(to: CGPoint(x: 50, y: 100))
        bodyPath.addLine(to: CGPoint(x: 45, y: 40))
        bodyPath.addLine(to: CGPoint(x: 40, y: 10))
        bodyPath.addLine(to: CGPoint(x: 35, y: 40))
        bodyPath.addLine(to: CGPoint(x: 30, y: 100))
        bodyPath.close()
        
        rocketBody.path = bodyPath.cgPath
        rocketBody.fillColor = UIColor.white.cgColor
        rocketBody.strokeColor = UIColor.red.cgColor
        rocketBody.lineWidth = 2
        spaceshipContainer.layer.addSublayer(rocketBody)
        
        // Kanatlar
        addRocketFins(to: spaceshipContainer)
        
        // Cam
        addRocketCockpit(to: spaceshipContainer)
        
        // Alevler
        addRocketFlames(to: spaceshipContainer)
        
        // Kıvılcımlar
        addSparkEffect(to: spaceshipContainer)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        // Ekran sarsıntısı
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-5, 5, -4, 4, -2, 2, 0]
        shake.duration = 0.4
        view.layer.add(shake, forKey: "shake")
        
        // Fırlatma animasyonu
        UIView.animate(withDuration: 6.0, delay: 0, options: [.curveEaseOut], animations: {
            spaceshipContainer.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height - 300).rotated(by: CGFloat.pi / 40)
            spaceshipContainer.alpha = 0
        }) { _ in
            spaceshipContainer.removeFromSuperview()
        }
    }
    
    /// Roket kanatlarını ekler
    private func addRocketFins(to container: UIView) {
        // Sol kanat
        let leftFin = CAShapeLayer()
        let leftFinPath = UIBezierPath()
        leftFinPath.move(to: CGPoint(x: 30, y: 100))
        leftFinPath.addLine(to: CGPoint(x: 10, y: 130))
        leftFinPath.addLine(to: CGPoint(x: 30, y: 140))
        leftFinPath.close()
        leftFin.path = leftFinPath.cgPath
        leftFin.fillColor = UIColor.red.cgColor
        container.layer.addSublayer(leftFin)
        
        // Sağ kanat
        let rightFin = CAShapeLayer()
        let rightFinPath = UIBezierPath()
        rightFinPath.move(to: CGPoint(x: 50, y: 100))
        rightFinPath.addLine(to: CGPoint(x: 70, y: 130))
        rightFinPath.addLine(to: CGPoint(x: 50, y: 140))
        rightFinPath.close()
        rightFin.path = rightFinPath.cgPath
        rightFin.fillColor = UIColor.red.cgColor
        container.layer.addSublayer(rightFin)
    }
    
    /// Roket camını ekler
    private func addRocketCockpit(to container: UIView) {
        let cockpit = CAShapeLayer()
        let cockpitPath = UIBezierPath(ovalIn: CGRect(x: 38, y: 25, width: 8, height: 8))
        cockpit.path = cockpitPath.cgPath
        cockpit.fillColor = UIColor.systemBlue.cgColor
        cockpit.shadowColor = UIColor.white.cgColor
        cockpit.shadowRadius = 3
        cockpit.shadowOpacity = 0.8
        cockpit.shadowOffset = .zero
        container.layer.addSublayer(cockpit)
    }
    
    /// Roket alevlerini ekler
    private func addRocketFlames(to container: UIView) {
        // Kırmızı alev
        let flameRed = createFlameLayer(path: createFlamePath(width: 10, height: 30), color: .red)
        flameRed.position = CGPoint(x: 40, y: 185)
        container.layer.addSublayer(flameRed)
        
        // Sarı alev
        let flameYellow = createFlameLayer(path: createFlamePath(width: 8, height: 20), color: .yellow)
        flameYellow.position = CGPoint(x: 40, y: 180)
        container.layer.addSublayer(flameYellow)
        
        // Mavi alev
        let flameBlue = createFlameLayer(path: createFlamePath(width: 6, height: 15), color: .systemBlue)
        flameBlue.position = CGPoint(x: 40, y: 175)
        container.layer.addSublayer(flameBlue)
        
        // Alev animasyonları
        [flameRed, flameYellow, flameBlue].forEach { flame in
            let flicker = CABasicAnimation(keyPath: "opacity")
            flicker.fromValue = 0.5
            flicker.toValue = 1.0
            flicker.duration = 0.1
            flicker.autoreverses = true
            flicker.repeatCount = .infinity
            flame.add(flicker, forKey: "flicker")
        }
    }
    
    /// Alev katmanı oluşturur
    private func createFlameLayer(path: UIBezierPath, color: UIColor) -> CAShapeLayer {
        let flame = CAShapeLayer()
        flame.path = path.cgPath
        flame.fillColor = color.cgColor
        return flame
    }
    
    /// Alev path'i oluşturur
    private func createFlamePath(width: CGFloat, height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -width/2, y: 0))
        path.addLine(to: CGPoint(x: width/2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path
    }
    
    /// Kıvılcım efekti ekler
    private func addSparkEffect(to container: UIView) {
        let sparkEmitter = CAEmitterLayer()
        sparkEmitter.emitterPosition = CGPoint(x: 40, y: 170)
        sparkEmitter.emitterShape = .point
        
        let sparkCell = CAEmitterCell()
        sparkCell.birthRate = 120
        sparkCell.lifetime = 0.6
        sparkCell.velocity = 60
        sparkCell.velocityRange = 30
        sparkCell.emissionRange = .pi / 3
        sparkCell.scale = 0.025
        sparkCell.scaleRange = 0.01
        sparkCell.color = UIColor.yellow.cgColor
        sparkCell.contents = UIImage(systemName: "sparkle")?.withTintColor(.yellow).cgImage
        
        sparkEmitter.emitterCells = [sparkCell]
        container.layer.addSublayer(sparkEmitter)
        
        // Temizlik
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            sparkEmitter.removeFromSuperlayer()
        }
    }
}


