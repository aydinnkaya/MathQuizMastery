//
//  GameScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation
import UIKit

// MARK: - Game Screen Protocols

/// GameScreenViewModel için gerekli metodları tanımlayan protocol
protocol GameScreenViewModelProtocol: AnyObject {
    var currentExpression: MathExpression.Operation { get }
    var answerOptions: [Double] { get }
    var correctAnswer: Double { get }
    var currentScore: Int { get }
    var currentQuestionNumber: Int { get }
    var totalQuestions: Int { get }
    var timeRemaining: Int { get }
    var isGameActive: Bool { get }
    
    func startGame()
    func nextQuestion()
    func checkAnswer(selectedAnswer: Double) -> Bool
    func pauseGame()
    func resumeGame()
    func endGame()
}

/// GameScreenViewModel delegate protokolü - UI güncellemeleri için
protocol GameScreenViewModelDelegate: AnyObject {
    func didUpdateQuestion(questionText: String, answerOptions: [String])
    func didUpdateScore(newScore: Int)
    func didUpdateTime(formattedTime: String)
    func didUpdateQuestionNumber(current: Int, total: Int)
    func didFinishGame(finalScore: Int, expressionType: MathExpression.ExpressionType)
    func didStartCountdownWarning()
    func didAnswerQuestion(isCorrect: Bool, correctAnswer: String)
    func didEncounterError(error: GameError)
}

// MARK: - Game Errors
/// Oyun sırasında oluşabilecek hatalar
enum GameError: Error, LocalizedError {
    case invalidExpressionType
    case failedToGenerateQuestion
    case timerError
    case invalidAnswer
    
    var errorDescription: String? {
        switch self {
        case .invalidExpressionType:
            return "Geçersiz matematik işlem tipi"
        case .failedToGenerateQuestion:
            return "Soru oluşturulamadı"
        case .timerError:
            return "Zamanlayıcı hatası"
        case .invalidAnswer:
            return "Geçersiz cevap"
        }
    }
}

// MARK: - Game Configuration
/// Oyun ayarları için yapılandırma
struct GameConfiguration {
    let totalQuestions: Int
    let timeLimit: TimeInterval
    let pointsForCorrect: Int
    let pointsForIncorrect: Int
    let countdownWarningTime: Int
    let wrongAnswersCount: Int
    let answerRangeMultiplier: Int
    
    static let `default` = GameConfiguration(
        totalQuestions: 10,
        timeLimit: 60,
        pointsForCorrect: 1,
        pointsForIncorrect: -1,
        countdownWarningTime: 10,
        wrongAnswersCount: 3,
        answerRangeMultiplier: 10
    )
}

// MARK: - Game Screen ViewModel
/// Oyun ekranının iş mantığını yöneten ViewModel sınıfı
class GameScreenViewModel: GameScreenViewModelProtocol {
    
    // MARK: - Public Properties
    private(set) var currentExpression: MathExpression.Operation
    private(set) var answerOptions: [Double] = []
    private(set) var correctAnswer: Double = 0.0
    private(set) var currentScore: Int = 0
    private(set) var currentQuestionNumber: Int = 1
    private(set) var timeRemaining: Int = 0
    private(set) var isGameActive: Bool = false
    
    let totalQuestions: Int
    
    // MARK: - Private Properties
    private let expressionType: MathExpression.ExpressionType
    private let configuration: GameConfiguration
    private var gameTimer: Timer?
    private var isPaused: Bool = false
    
    weak var delegate: GameScreenViewModelDelegate?
    
    // MARK: - Initializer
    /// GameScreenViewModel başlatıcı metodu
    /// - Parameters:
    ///   - delegate: UI güncellemeleri için delegate
    ///   - expressionType: Matematik işlem tipi
    ///   - configuration: Oyun konfigürasyonu
    init(delegate: GameScreenViewModelDelegate?,
         expressionType: MathExpression.ExpressionType,
         configuration: GameConfiguration = .default) {
        
        self.delegate = delegate
        self.expressionType = expressionType
        self.configuration = configuration
        self.totalQuestions = configuration.totalQuestions
        self.timeRemaining = Int(configuration.timeLimit)
        
        // İlk soruyu oluştur
        self.currentExpression = MathExpression.generateExpression(type: expressionType)
        
        // Oyunu başlat
        generateCurrentQuestion()
        
        print("🎮 GameViewModel başlatıldı - Tip: \(expressionType.displayName)")
    }
    
    deinit {
        endGame()
        print("🗑️ GameViewModel deinit edildi")
    }
    
    // MARK: - Game Control Methods
    
    /// Oyunu başlatır
    func startGame() {
        guard !isGameActive else {
            print("⚠️ Oyun zaten aktif")
            return
        }
        
        isGameActive = true
        currentScore = 0
        currentQuestionNumber = 1
        timeRemaining = Int(configuration.timeLimit)
        
        // İlk soruyu hazırla
        generateCurrentQuestion()
        
        // Timer'ı başlat
        startTimer()
        
        // UI'ı güncelle
        updateUI()
        
        print("🚀 Oyun başlatıldı - Toplam soru: \(totalQuestions), Süre: \(timeRemaining)s")
    }
    
    /// Sonraki soruya geçer
    func nextQuestion() {
        guard isGameActive else { return }
        
        if currentQuestionNumber < totalQuestions {
            currentQuestionNumber += 1
            generateCurrentQuestion()
            updateUI()
            
            print("➡️ Sonraki soru: \(currentQuestionNumber)/\(totalQuestions)")
        } else {
            // Oyun bitti
            finishGame()
        }
    }
    
    /// Verilen cevabı kontrol eder
    /// - Parameter selectedAnswer: Seçilen cevap
    /// - Returns: Cevap doğru mu?
    func checkAnswer(selectedAnswer: Double) -> Bool {
        guard isGameActive else { return false }
        
        let isCorrect = abs(selectedAnswer - correctAnswer) < 0.01 // Double karşılaştırma toleransı
        
        // Puanı güncelle
        updateScore(isCorrect: isCorrect)
        
        // Delegate'i bilgilendir
        let correctAnswerString = formatAnswer(correctAnswer)
        delegate?.didAnswerQuestion(isCorrect: isCorrect, correctAnswer: correctAnswerString)
        
        print("🎯 Cevap kontrol edildi - Doğru: \(isCorrect), Skor: \(currentScore)")
        
        return isCorrect
    }
    
    /// Oyunu duraklatır
    func pauseGame() {
        guard isGameActive && !isPaused else { return }
        
        isPaused = true
        gameTimer?.invalidate()
        gameTimer = nil
        
        print("⏸️ Oyun duraklatıldı")
    }
    
    /// Oyunu devam ettirir
    func resumeGame() {
        guard isGameActive && isPaused else { return }
        
        isPaused = false
        startTimer()
        
        print("▶️ Oyun devam ettirildi")
    }
    
    /// Oyunu sonlandırır
    func endGame() {
        guard isGameActive else { return }
        
        isGameActive = false
        isPaused = false
        gameTimer?.invalidate()
        gameTimer = nil
        
        print("🏁 Oyun sonlandırıldı - Final skoru: \(currentScore)")
    }
    
    // MARK: - Private Methods
    
    /// Mevcut soru için quiz oluşturur
    private func generateCurrentQuestion() {
        do {
            // Yeni ifade oluştur
            currentExpression = MathExpression.generateExpression(type: expressionType)
            
            // Doğru cevabı hesapla
            correctAnswer = currentExpression.calculateAnswer()
            
            // Yanlış cevapları oluştur ve karıştır
            generateAnswerOptions()
            
            print("❓ Yeni soru oluşturuldu: \(currentExpression.createQuestion())")
            
        } catch {
            print("❌ Soru oluşturulamadı: \(error)")
            delegate?.didEncounterError(error: .failedToGenerateQuestion)
        }
    }
    
    /// Cevap seçeneklerini oluşturur
    private func generateAnswerOptions() {
        var options: [Double] = []
        options.append(correctAnswer) // Doğru cevap
        
        // Yanlış cevapları oluştur
        let wrongAnswers = generateWrongAnswers()
        options.append(contentsOf: wrongAnswers)
        
        // Seçenekleri karıştır
        answerOptions = options.shuffled()
        
        print("📝 Cevap seçenekleri: \(answerOptions.map { formatAnswer($0) }.joined(separator: ", "))")
    }
    
    /// Yanlış cevapları oluşturur
    /// - Returns: Yanlış cevap dizisi
    private func generateWrongAnswers() -> [Double] {
        var wrongAnswers: [Double] = []
        let range = configuration.answerRangeMultiplier
        
        // Expression type'a göre farklı yanlış cevap stratejileri
        switch expressionType {
        case .addition, .subtraction, .multiplication:
            // Tam sayı işlemleri için tam sayı yanlış cevaplar
            while wrongAnswers.count < configuration.wrongAnswersCount {
                let offset = Int.random(in: -range...range)
                let wrongAnswer = correctAnswer + Double(offset)
                
                if !isAnswerAlreadyExists(wrongAnswer, in: wrongAnswers) && wrongAnswer != correctAnswer {
                    wrongAnswers.append(wrongAnswer)
                }
            }
            
        case .division, .fractions:
            // Bölme ve kesirler için ondalık yanlış cevaplar
            while wrongAnswers.count < configuration.wrongAnswersCount {
                let multiplier = Double.random(in: 0.5...2.0)
                let wrongAnswer = correctAnswer * multiplier
                
                if !isAnswerAlreadyExists(wrongAnswer, in: wrongAnswers) && abs(wrongAnswer - correctAnswer) > 0.1 {
                    wrongAnswers.append(wrongAnswer)
                }
            }
            
        case .percentages:
            // Yüzde işlemleri için mantıklı yanlış cevaplar
            while wrongAnswers.count < configuration.wrongAnswersCount {
                let percentage = Double.random(in: 5...50)
                let wrongAnswer = correctAnswer + (correctAnswer * percentage / 100.0)
                
                if !isAnswerAlreadyExists(wrongAnswer, in: wrongAnswers) && wrongAnswer != correctAnswer {
                    wrongAnswers.append(wrongAnswer)
                }
            }
            
        default:
            // Genel yanlış cevap üretimi
            while wrongAnswers.count < configuration.wrongAnswersCount {
                let variation = Double.random(in: -Double(range)...Double(range))
                let wrongAnswer = correctAnswer + variation
                
                if !isAnswerAlreadyExists(wrongAnswer, in: wrongAnswers) && wrongAnswer != correctAnswer {
                    wrongAnswers.append(wrongAnswer)
                }
            }
        }
        
        return wrongAnswers
    }
    
    /// Cevabın zaten listede olup olmadığını kontrol eder
    /// - Parameters:
    ///   - answer: Kontrol edilecek cevap
    ///   - existingAnswers: Mevcut cevaplar listesi
    /// - Returns: Cevap zaten var mı?
    private func isAnswerAlreadyExists(_ answer: Double, in existingAnswers: [Double]) -> Bool {
        return existingAnswers.contains { abs($0 - answer) < 0.01 }
    }
    
    /// Skoru günceller
    /// - Parameter isCorrect: Cevap doğru mu?
    private func updateScore(isCorrect: Bool) {
        if isCorrect {
            currentScore += configuration.pointsForCorrect
        } else {
            currentScore += configuration.pointsForIncorrect
            currentScore = max(0, currentScore) // Negatif skor olmamasi için
        }
        
        delegate?.didUpdateScore(newScore: currentScore)
    }
    
    /// UI'ı günceller
    private func updateUI() {
        let questionText = currentExpression.createQuestion()
        let formattedOptions = answerOptions.map { formatAnswer($0) }
        
        delegate?.didUpdateQuestion(questionText: questionText, answerOptions: formattedOptions)
        delegate?.didUpdateQuestionNumber(current: currentQuestionNumber, total: totalQuestions)
        delegate?.didUpdateScore(newScore: currentScore)
    }
    
    /// Cevabı formatlar
    /// - Parameter answer: Formatlanacak cevap
    /// - Returns: Formatlanmış cevap string'i
    private func formatAnswer(_ answer: Double) -> String {
        // Tam sayı ise .0 kısmını gösterme
        if answer.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(answer))
        } else {
            return String(format: "%.2f", answer)
        }
    }
    
    /// Timer'ı başlatır
    private func startTimer() {
        gameTimer?.invalidate() // Önceki timer'ı iptal et
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            let formattedTime = String(format: "%02d", self.timeRemaining)
            self.delegate?.didUpdateTime(formattedTime: formattedTime)
            
            // Countdown uyarısı
            if self.timeRemaining == self.configuration.countdownWarningTime {
                self.delegate?.didStartCountdownWarning()
                print("⚠️ Countdown uyarısı başlatıldı")
            }
            
            // Süre doldu
            if self.timeRemaining <= 0 {
                self.finishGame()
            }
        }
    }
    
    /// Oyunu bitirir
    private func finishGame() {
        endGame()
        delegate?.didFinishGame(finalScore: currentScore, expressionType: expressionType)
        print("🏆 Oyun tamamlandı - Final skoru: \(currentScore)/\(totalQuestions)")
    }
}

// MARK: - Game Statistics Extension
extension GameScreenViewModel {
    
    /// Oyun istatistiklerini döner
    var gameStatistics: GameStatistics {
        let accuracy = totalQuestions > 0 ? Double(currentScore) / Double(totalQuestions) * 100.0 : 0.0
        let timePerQuestion = totalQuestions > 0 ? Double(Int(configuration.timeLimit) - timeRemaining) / Double(currentQuestionNumber) : 0.0
        
        return GameStatistics(
            totalQuestions: totalQuestions,
            correctAnswers: currentScore,
            accuracy: accuracy,
            timeSpent: Int(configuration.timeLimit) - timeRemaining,
            averageTimePerQuestion: timePerQuestion
        )
    }
}

// MARK: - Game Statistics Structure
/// Oyun istatistikleri yapısı
struct GameStatistics {
    let totalQuestions: Int
    let correctAnswers: Int
    let accuracy: Double
    let timeSpent: Int
    let averageTimePerQuestion: Double
    
    var displayAccuracy: String {
        return String(format: "%.1f%%", accuracy)
    }
    
    var displayAverageTime: String {
        return String(format: "%.1f sn", averageTimePerQuestion)
    }
}
