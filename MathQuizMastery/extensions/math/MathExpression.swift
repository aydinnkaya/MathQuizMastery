//
//  MathExpression.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation

// MARK: - Math Expression Structure
/// Matematik ifadelerini temsil eden ana yapı
struct MathExpression {
    
    // MARK: - Operation Types
    /// Matematik işlem türlerini tanımlayan enum
    indirect enum Operation {
        case addition(Int, Int)                          // Toplama işlemi
        case subtraction(Int, Int)                       // Çıkarma işlemi
        case multiplication(Int, Int)                    // Çarpma işlemi
        case division(Int, Int)                          // Bölme işlemi
        case fraction(numerator: Int, denominator: Int)  // Kesir işlemi
        case percentage(value: Int, total: Int)          // Yüzde işlemi
        case negative(Int, Int)                          // Negatif sayı işlemi
        case time(hour: Int, minute: Int)                // Saat ve zaman işlemi
        case geometricShape(name: String)                // Geometrik şekil tanıma
        case mental(Int, Int, mathOperator: String)          // Zihinsel matematik
        case randomMixed(Operation)                      // Karışık rastgele işlem
        
        // MARK: - Question Generation
        /// İşlem türüne göre soru metni oluşturur
        /// - Returns: Soru string'i
        func createQuestion() -> String {
            switch self {
            case .addition(let a, let b):
                return "\(a) + \(b) = ?"
                
            case .subtraction(let a, let b):
                return "\(a) - \(b) = ?"
                
            case .multiplication(let a, let b):
                return "\(a) × \(b) = ?"
                
            case .division(let a, let b):
                return "\(a) ÷ \(b) = ?"
                
            case .fraction(let numerator, let denominator):
                return "Kesiri ondalık sayıya çevirin: \(numerator)/\(denominator)"
                
            case .percentage(let value, let total):
                return "\(total) sayısının %\(value)'i kaçtır?"
                
            case .negative(let a, let b):
                let sign = b >= 0 ? "+" : ""
                return "\(a) \(sign) (\(b)) = ?"
                
            case .time(let hour, let minute):
                return "Saat kaç? \(hour):\(String(format: "%02d", minute))"
                
            case .geometricShape(let name):
                return "Bu şekli tanımlayın: \(name)"
                
            case .mental(let a, let b, let op):
                return "Zihinsel hesaplama: \(a) \(op) \(b) = ?"
                
            case .randomMixed(let operation):
                return operation.createQuestion()
            }
        }
        
        // MARK: - Answer Calculation
        /// İşlemin doğru cevabını hesaplar
        /// - Returns: Hesaplanan sonuç
        func calculateAnswer() -> Double {
            switch self {
            case .addition(let a, let b):
                return Double(a + b)
                
            case .subtraction(let a, let b):
                return Double(a - b)
                
            case .multiplication(let a, let b):
                return Double(a * b)
                
            case .division(let a, let b):
                guard b != 0 else {
                    print("⚠️ Division by zero attempted")
                    return 0.0
                }
                return Double(a) / Double(b)
                
            case .fraction(let numerator, let denominator):
                guard denominator != 0 else {
                    print("⚠️ Fraction with zero denominator")
                    return 0.0
                }
                return Double(numerator) / Double(denominator)
                
            case .percentage(let value, let total):
                return Double(total) * Double(value) / 100.0
                
            case .negative(let a, let b):
                return Double(a + b)
                
            case .time:
                // Zaman soruları UI üzerinden kontrol edilir
                return 0.0
                
            case .geometricShape:
                // Geometrik şekil soruları metin tabanlıdır
                return 0.0
                
            case .mental(let a, let b, let op):
                return calculateMentalOperation(a: a, b: b, mathOperator: op)
                
            case .randomMixed(let operation):
                return operation.calculateAnswer()
            }
        }
        
        // MARK: - Mental Math Helper
        /// Zihinsel matematik işlemlerini hesaplar
        /// - Parameters:
        ///   - a: İlk sayı
        ///   - b: İkinci sayı
        ///   - mathOperator: İşlem operatörü
        /// - Returns: Hesaplanan sonuç
        private func calculateMentalOperation(a: Int, b: Int, mathOperator: String) -> Double {
            switch mathOperator {
            case "+":
                return Double(a + b)
            case "-":
                return Double(a - b)
            case "×", "*":
                return Double(a * b)
            case "÷", "/":
                guard b != 0 else { return 0.0 }
                return Double(a) / Double(b)
            default:
                print("⚠️ Unknown operator: \(mathOperator)")
                return 0.0
            }
        }
        
        // MARK: - Type Detection
        /// İşlem türünü belirler
        /// - Returns: ExpressionType enum değeri
        func getExpressionType() -> ExpressionType {
            switch self {
            case .addition: return .addition
            case .subtraction: return .subtraction
            case .multiplication: return .multiplication
            case .division: return .division
            case .fraction: return .fractions
            case .percentage: return .percentages
            case .negative: return .negativeNumbers
            case .time: return .timeAndClock
            case .geometricShape: return .geometricShapes
            case .mental: return .mentalMath
            case .randomMixed: return .randomMixed
            }
        }
        
        // MARK: - Difficulty Level
        /// İşlemin zorluk seviyesini belirler
        /// - Returns: Zorluk seviyesi (1-5 arası)
        func getDifficultyLevel() -> Int {
            switch self {
            case .addition(let a, let b):
                return (a + b > 100) ? 3 : (a + b > 50) ? 2 : 1
                
            case .subtraction(let a, let b):
                return (a > 100 || b > 100) ? 3 : (a > 50 || b > 50) ? 2 : 1
                
            case .multiplication(let a, let b):
                return (a > 12 || b > 12) ? 4 : (a > 6 || b > 6) ? 3 : 2
                
            case .division:
                return 3
                
            case .fraction:
                return 4
                
            case .percentage:
                return 4
                
            case .negative:
                return 3
                
            case .time:
                return 2
                
            case .geometricShape:
                return 1
                
            case .mental:
                return 4
                
            case .randomMixed:
                return 3
            }
        }
    }
    
    // MARK: - Expression Types
    /// Matematik ifade türlerini tanımlayan enum (String raw value ile)
    enum ExpressionType: String, CaseIterable {
        case addition = "addition"                       // Toplama
        case subtraction = "subtraction"                 // Çıkarma
        case multiplication = "multiplication"           // Çarpma
        case division = "division"                       // Bölme
        case multiplicationTable = "multiplication_table" // Çarpım tablosu
        case orderOfOperations = "order_of_operations"   // İşlem önceliği
        case negativeNumbers = "negative_numbers"        // Negatif sayılar
        case fractions = "fractions"                     // Kesirler
        case percentages = "percentages"                 // Yüzdeler
        case geometricShapes = "geometric_shapes"        // Geometrik şekiller
        case timeAndClock = "time_and_clock"            // Saat ve zaman
        case mentalMath = "mental_math"                 // Zihinsel matematik
        case randomMixed = "random_mixed"               // Rastgele karışık
        
        // MARK: - Display Names
        /// Kullanıcı dostu görüntüleme ismi
        var displayName: String {
            switch self {
            case .addition: return "Toplama"
            case .subtraction: return "Çıkarma"
            case .multiplication: return "Çarpma"
            case .division: return "Bölme"
            case .multiplicationTable: return "Çarpım Tablosu"
            case .orderOfOperations: return "İşlem Önceliği"
            case .negativeNumbers: return "Negatif Sayılar"
            case .fractions: return "Kesirler"
            case .percentages: return "Yüzdeler"
            case .geometricShapes: return "Geometrik Şekiller"
            case .timeAndClock: return "Saat ve Zaman"
            case .mentalMath: return "Zihinsel Matematik"
            case .randomMixed: return "Rastgele Karışık"
            }
        }
        
        // MARK: - Icon Names
        /// Her tür için ikon ismini döner
        var iconName: String {
            switch self {
            case .addition: return "plus.circle.fill"
            case .subtraction: return "minus.circle.fill"
            case .multiplication: return "multiply.circle.fill"
            case .division: return "divide.circle.fill"
            case .multiplicationTable: return "grid"
            case .orderOfOperations: return "function"
            case .negativeNumbers: return "plusminus"
            case .fractions: return "divide"
            case .percentages: return "percent"
            case .geometricShapes: return "triangle"
            case .timeAndClock: return "clock"
            case .mentalMath: return "brain"
            case .randomMixed: return "shuffle"
            }
        }
        
        // MARK: - Difficulty Range
        /// Her tür için ortalama zorluk seviyesi
        var averageDifficulty: Int {
            switch self {
            case .addition, .subtraction: return 2
            case .multiplication: return 3
            case .division, .negativeNumbers: return 3
            case .multiplicationTable: return 2
            case .orderOfOperations: return 4
            case .fractions, .percentages: return 4
            case .geometricShapes: return 1
            case .timeAndClock: return 2
            case .mentalMath: return 4
            case .randomMixed: return 3
            }
        }
    }
    
    // MARK: - Expression Generation
    /// Belirtilen türde matematik ifadesi üretir
    /// - Parameter type: Üretilecek ifade türü
    /// - Returns: Oluşturulan Operation
    static func generateExpression(type: ExpressionType) -> Operation {
        switch type {
        case .addition:
            return generateAddition()
        case .subtraction:
            return generateSubtraction()
        case .multiplication:
            return generateMultiplication()
        case .division:
            return generateSafeDivision()
        case .multiplicationTable:
            return generateMultiplicationTable()
        case .orderOfOperations:
            return generateOrderOfOperations()
        case .negativeNumbers:
            return generateNegative()
        case .fractions:
            return generateFraction()
        case .percentages:
            return generatePercentage()
        case .geometricShapes:
            return generateShape()
        case .timeAndClock:
            return generateTime()
        case .mentalMath:
            return generateMental()
        case .randomMixed:
            return .randomMixed(generateMixedExpression())
        }
    }
    
    // MARK: - Batch Generation
    /// Birden fazla ifade üretir
    /// - Parameters:
    ///   - type: İfade türü
    ///   - count: Üretilecek ifade sayısı
    /// - Returns: Operation dizisi
    static func generateExpressions(type: ExpressionType, count: Int) -> [Operation] {
        return (0..<count).map { _ in generateExpression(type: type) }
    }
}

// MARK: - Private Generation Methods
private extension MathExpression {
    
    /// Rastgele operand çifti üretir
    /// - Parameter range: Sayı aralığı
    /// - Returns: İki rastgele sayı
    static func generateOperands(range: Range<Int> = 1..<100) -> (Int, Int) {
        return (Int.random(in: range), Int.random(in: range))
    }
    
    /// Toplama işlemi üretir
    /// - Returns: Addition operation
    static func generateAddition() -> Operation {
        let (a, b) = generateOperands(range: 1..<100)
        return .addition(a, b)
    }
    
    /// Çıkarma işlemi üretir (sonuç her zaman pozitif)
    /// - Returns: Subtraction operation
    static func generateSubtraction() -> Operation {
        let (a, b) = generateOperands(range: 1..<100)
        // Büyük sayıyı ilk sıraya koy ki sonuç pozitif olsun
        return .subtraction(max(a, b), min(a, b))
    }
    
    /// Çarpma işlemi üretir
    /// - Returns: Multiplication operation
    static func generateMultiplication() -> Operation {
        let (a, b) = generateOperands(range: 1..<20)
        return .multiplication(a, b)
    }
    
    /// Güvenli bölme işlemi üretir (tam bölünen sayılar)
    /// - Returns: Division operation
    static func generateSafeDivision() -> Operation {
        let divisor = Int.random(in: 2...12)
        let quotient = Int.random(in: 2...12)
        let dividend = divisor * quotient
        return .division(dividend, divisor)
    }
    
    /// Çarpım tablosu işlemi üretir
    /// - Returns: Multiplication table operation
    static func generateMultiplicationTable() -> Operation {
        let a = Int.random(in: 1...12)
        let b = Int.random(in: 1...12)
        return .multiplication(a, b)
    }
    
    /// İşlem önceliği sorusu üretir
    /// - Returns: Order of operations expression
    static func generateOrderOfOperations() -> Operation {
        // Basit örnek: (a + b) × c şeklinde
        let a = Int.random(in: 1...10)
        let b = Int.random(in: 1...10)
        let c = Int.random(in: 2...5)
        
        // Parantez içindeki işlemi önceden hesapla
        let result = (a + b) * c
        return .mental(a + b, c, mathOperator: "×")
    }
    
    /// Negatif sayı işlemi üretir
    /// - Returns: Negative number operation
    static func generateNegative() -> Operation {
        let a = Int.random(in: -50...50)
        let b = Int.random(in: -50...50)
        return .negative(a, b)
    }
    
    /// Kesir işlemi üretir
    /// - Returns: Fraction operation
    static func generateFraction() -> Operation {
        let numerator = Int.random(in: 1...20)
        let denominator = Int.random(in: 2...20)
        return .fraction(numerator: numerator, denominator: denominator)
    }
    
    /// Yüzde işlemi üretir
    /// - Returns: Percentage operation
    static func generatePercentage() -> Operation {
        let percentage = [10, 15, 20, 25, 30, 40, 50, 75].randomElement() ?? 25
        let total = Int.random(in: 20...500)
        return .percentage(value: percentage, total: total)
    }
    
    /// Geometrik şekil sorusu üretir
    /// - Returns: Geometric shape operation
    static func generateShape() -> Operation {
        let shapes = [
            "Üçgen", "Kare", "Daire", "Dikdörtgen",
            "Beşgen", "Altıgen", "Oval", "Eşkenar Dörtgen"
        ]
        let randomShape = shapes.randomElement() ?? "Üçgen"
        return .geometricShape(name: randomShape)
    }
    
    /// Saat ve zaman sorusu üretir
    /// - Returns: Time operation
    static func generateTime() -> Operation {
        let hour = Int.random(in: 1...12)
        let minute = [0, 15, 30, 45].randomElement() ?? 0
        return .time(hour: hour, minute: minute)
    }
    
    /// Zihinsel matematik sorusu üretir
    /// - Returns: Mental math operation
    static func generateMental() -> Operation {
        let operators = ["+", "-", "×", "÷"]
        let a = Int.random(in: 10...99)
        let b = Int.random(in: 1...20)
        let op = operators.randomElement() ?? "+"
        
        // Bölme için güvenli sayılar kullan
        if op == "÷" {
            let divisor = Int.random(in: 2...10)
            let quotient = Int.random(in: 2...10)
            return .mental(divisor * quotient, divisor, mathOperator: op)
        }
        
        return .mental(a, b, mathOperator: op)
    }
    
    /// Karışık rastgele ifade üretir
    /// - Returns: Random mixed operation
    static func generateMixedExpression() -> Operation {
        let basicTypes: [ExpressionType] = [
            .addition, .subtraction, .multiplication, .division
        ]
        
        guard let randomType = basicTypes.randomElement() else {
            return generateAddition()
        }
        
        return generateExpression(type: randomType)
    }
}

// MARK: - Convenience Extensions
extension MathExpression.Operation: Equatable {
    static func == (lhs: MathExpression.Operation, rhs: MathExpression.Operation) -> Bool {
        switch (lhs, rhs) {
        case let (.addition(a1, b1), .addition(a2, b2)):
            return a1 == a2 && b1 == b2
        case let (.subtraction(a1, b1), .subtraction(a2, b2)):
            return a1 == a2 && b1 == b2
        case let (.multiplication(a1, b1), .multiplication(a2, b2)):
            return a1 == a2 && b1 == b2
        case let (.division(a1, b1), .division(a2, b2)):
            return a1 == a2 && b1 == b2
        default:
            return false
        }
    }
}

extension MathExpression.Operation: CustomStringConvertible {
    var description: String {
        return createQuestion()
    }
}

// MARK: - Statistics and Analytics
extension MathExpression.ExpressionType {
    
    /// Bu tür için önerilen soru sayısı
    var recommendedQuestionCount: Int {
        switch self {
        case .addition, .subtraction: return 15
        case .multiplication, .multiplicationTable: return 12
        case .division, .fractions, .percentages: return 10
        case .negativeNumbers, .mentalMath: return 8
        case .orderOfOperations: return 6
        case .geometricShapes, .timeAndClock: return 5
        case .randomMixed: return 20
        }
    }
    
    /// Bu tür için önerilen süre (saniye)
    var recommendedTimeLimit: TimeInterval {
        switch averageDifficulty {
        case 1: return 30.0  // Kolay sorular
        case 2: return 45.0  // Orta sorular
        case 3: return 60.0  // Zor sorular
        case 4: return 90.0  // Çok zor sorular
        default: return 60.0
        }
    }
}
