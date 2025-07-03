//
//  CategoryViewModelTests.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import Foundation
import Combine
import os.log
@testable import MathQuizMastery

// MARK: - Category Domain Models

/// Represents a math category with all necessary information for UI display and business logic
public struct CategoryModel: Equatable, Hashable, Identifiable {
    public let id: UUID
    public let iconName: String
    public let categoryName: String
    public let expressionType: MathExpression.ExpressionType
    public let displayName: String
    public let description: String
    public let difficulty: CategoryDifficulty
    public let estimatedCompletionTime: TimeInterval
    public let isEnabled: Bool
    public let minimumRequiredLevel: Int
    public let rewardCoins: Int
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        iconName: String,
        categoryName: String,
        expressionType: MathExpression.ExpressionType,
        displayName: String? = nil,
        description: String? = nil,
        difficulty: CategoryDifficulty = .medium,
        estimatedCompletionTime: TimeInterval = 300,
        isEnabled: Bool = true,
        minimumRequiredLevel: Int = 1,
        rewardCoins: Int = 10,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.iconName = iconName
        self.categoryName = categoryName
        self.expressionType = expressionType
        self.displayName = displayName ?? categoryName.localizedCapitalized
        self.description = description ?? "Practice \(categoryName) problems"
        self.difficulty = difficulty
        self.estimatedCompletionTime = estimatedCompletionTime
        self.isEnabled = isEnabled
        self.minimumRequiredLevel = minimumRequiredLevel
        self.rewardCoins = rewardCoins
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Mock Analytics Tracker for Testing

#if DEBUG
/// Mock analytics tracker for testing purposes
public final class MockAnalyticsTracker: CategoryAnalyticsTracking {
    public init() {}
    
    private let analyticsSubject = PassthroughSubject<AnalyticsEvent, Never>()
    
    public var analyticsPublisher: AnyPublisher<AnalyticsEvent, Never> {
        analyticsSubject.eraseToAnyPublisher()
    }
    
    // Captured data for testing
    public private(set) var viewedCategories: [CategoryModel] = []
    public private(set) var selectedCategories: [(CategoryModel, Int)] = []
    public private(set) var trackedErrors: [(CategoryError, String)] = []
    public private(set) var performanceMetrics: [(String, Double, String)] = []
    public private(set) var userBehaviors: [UserBehavior] = []
    
    public func trackCategoryViewed(_ category: CategoryModel) {
        viewedCategories.append(category)
        analyticsSubject.send(.categoryViewed(category))
    }
    
    public func trackCategorySelected(_ category: CategoryModel, at index: Int) {
        selectedCategories.append((category, index))
        analyticsSubject.send(.categorySelected(category, index))
    }
    
    public func trackCategoryError(_ error: CategoryError, context: String) {
        trackedErrors.append((error, context))
        analyticsSubject.send(.errorTracked(error, context))
    }
    
    public func trackPerformanceMetric(_ metric: String, value: Double, context: String) {
        performanceMetrics.append((metric, value, context))
        analyticsSubject.send(.performanceMetric(metric, value, context))
    }
    
    public func trackUserBehavior(_ behavior: UserBehavior) {
        userBehaviors.append(behavior)
        analyticsSubject.send(.userBehavior(behavior))
    }
    
    // Testing utilities
    public func reset() {
        viewedCategories.removeAll()
        selectedCategories.removeAll()
        trackedErrors.removeAll()
        performanceMetrics.removeAll()
        userBehaviors.removeAll()
    }
}
#endif

/// Enum representing different difficulty levels for categories
public enum CategoryDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case expert = "expert"
    case master = "master"
    
    public var displayName: String {
        switch self {
        case .beginner: return NSLocalizedString("Beginner", comment: "Beginner difficulty level")
        case .easy: return NSLocalizedString("Easy", comment: "Easy difficulty level")
        case .medium: return NSLocalizedString("Medium", comment: "Medium difficulty level")
        case .hard: return NSLocalizedString("Hard", comment: "Hard difficulty level")
        case .expert: return NSLocalizedString("Expert", comment: "Expert difficulty level")
        case .master: return NSLocalizedString("Master", comment: "Master difficulty level")
        }
    }
    
    public var multiplier: Double {
        switch self {
        case .beginner: return 0.8
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        case .expert: return 2.5
        case .master: return 3.0
        }
    }
    
    public var colorHex: String {
        switch self {
        case .beginner: return "#4CAF50"  // Green
        case .easy: return "#8BC34A"      // Light Green
        case .medium: return "#FF9800"    // Orange
        case .hard: return "#FF5722"      // Deep Orange
        case .expert: return "#F44336"    // Red
        case .master: return "#9C27B0"    // Purple
        }
    }
}

// MARK: - Category Events for Combine

/// Events that can be published by CategoryViewModel
public enum CategoryEvent: Equatable {
    case categoriesLoaded([CategoryModel])
    case categorySelected(CategoryModel, Int)
    case categoryViewed(CategoryModel)
    case loadingStateChanged(Bool)
    case errorOccurred(CategoryError)
    case cacheCleared
    case refreshCompleted
    case configurationUpdated(CategoryViewModelConfiguration)
    case performanceMetricsUpdated(PerformanceMetrics)
    
    public static func == (lhs: CategoryEvent, rhs: CategoryEvent) -> Bool {
        switch (lhs, rhs) {
        case (.categoriesLoaded(let l), .categoriesLoaded(let r)): return l == r
        case (.categorySelected(let l1, let l2), .categorySelected(let r1, let r2)): return l1 == r1 && l2 == r2
        case (.categoryViewed(let l), .categoryViewed(let r)): return l == r
        case (.loadingStateChanged(let l), .loadingStateChanged(let r)): return l == r
        case (.errorOccurred(let l), .errorOccurred(let r)): return l == r
        case (.cacheCleared, .cacheCleared): return true
        case (.refreshCompleted, .refreshCompleted): return true
        default: return false
        }
    }
}

// MARK: - Analytics & Tracking

/// Protocol for tracking category-related events with Combine support
public protocol CategoryAnalyticsTracking: AnyObject {
    var analyticsPublisher: AnyPublisher<AnalyticsEvent, Never> { get }
    
    func trackCategoryViewed(_ category: CategoryModel)
    func trackCategorySelected(_ category: CategoryModel, at index: Int)
    func trackCategoryError(_ error: CategoryError, context: String)
    func trackPerformanceMetric(_ metric: String, value: Double, context: String)
    func trackUserBehavior(_ behavior: UserBehavior)
}

/// Analytics events for comprehensive tracking
public enum AnalyticsEvent: Equatable {
    case categoryViewed(CategoryModel)
    case categorySelected(CategoryModel, Int)
    case errorTracked(CategoryError, String)
    case performanceMetric(String, Double, String)
    case userBehavior(UserBehavior)
    case sessionStarted
    case sessionEnded
    
    public static func == (lhs: AnalyticsEvent, rhs: AnalyticsEvent) -> Bool {
        switch (lhs, rhs) {
        case (.categoryViewed(let l), .categoryViewed(let r)): return l == r
        case (.categorySelected(let l1, let l2), .categorySelected(let r1, let r2)): return l1 == r1 && l2 == r2
        case (.errorTracked(let l1, let l2), .errorTracked(let r1, let r2)): return l1 == r1 && l2 == r2
        case (.sessionStarted, .sessionStarted): return true
        case (.sessionEnded, .sessionEnded): return true
        default: return false
        }
    }
}

/// User behavior tracking
public enum UserBehavior: String, CaseIterable, Codable {
    case quickSelection = "quick_selection"
    case detailedViewing = "detailed_viewing"
    case backAndForth = "back_and_forth"
    case systematicProgress = "systematic_progress"
    case randomExploration = "random_exploration"
    case difficultyProgression = "difficulty_progression"
}

/// Default implementation of analytics tracking with Combine
public final class DefaultCategoryAnalyticsTracker: CategoryAnalyticsTracking {
    private let logger = Logger(subsystem: "com.mathquizmastery", category: "CategoryAnalytics")
    private let analyticsSubject = PassthroughSubject<AnalyticsEvent, Never>()
    
    public init() {}
    
    public var analyticsPublisher: AnyPublisher<AnalyticsEvent, Never> {
        analyticsSubject.eraseToAnyPublisher()
    }
    
    public func trackCategoryViewed(_ category: CategoryModel) {
        logger.info("📊 Category viewed: \(category.categoryName, privacy: .public)")
        analyticsSubject.send(.categoryViewed(category))
    }
    
    public func trackCategorySelected(_ category: CategoryModel, at index: Int) {
        logger.info("🎯 Category selected: \(category.categoryName, privacy: .public) at index: \(index)")
        analyticsSubject.send(.categorySelected(category, index))
    }
    
    public func trackCategoryError(_ error: CategoryError, context: String) {
        logger.error("❌ Category error: \(error.localizedDescription, privacy: .public) in context: \(context, privacy: .public)")
        analyticsSubject.send(.errorTracked(error, context))
    }
    
    public func trackPerformanceMetric(_ metric: String, value: Double, context: String) {
        logger.info("📈 Performance metric - \(metric, privacy: .public): \(value) in \(context, privacy: .public)")
        analyticsSubject.send(.performanceMetric(metric, value, context))
    }
    
    public func trackUserBehavior(_ behavior: UserBehavior) {
        logger.info("👤 User behavior: \(behavior.rawValue, privacy: .public)")
        analyticsSubject.send(.userBehavior(behavior))
    }
}

// MARK: - Error Handling

/// Comprehensive error handling for category operations
public enum CategoryError: Error, LocalizedError, Equatable {
    case invalidIndex(Int)
    case categoryNotFound(String)
    case categoryDisabled(String)
    case insufficientLevel(required: Int, current: Int)
    case dataCorruption
    case networkError(underlying: String?)
    case configurationError(String)
    case cacheError(String)
    case validationError(String)
    case timeoutError
    case permissionDenied
    case rateLimitExceeded
    
    public var errorDescription: String? {
        switch self {
        case .invalidIndex(let index):
            return NSLocalizedString("Invalid category index: \(index)", comment: "Invalid index error")
        case .categoryNotFound(let name):
            return NSLocalizedString("Category '\(name)' not found", comment: "Category not found error")
        case .categoryDisabled(let name):
            return NSLocalizedString("Category '\(name)' is currently disabled", comment: "Category disabled error")
        case .insufficientLevel(let required, let current):
            return NSLocalizedString("Level \(required) required (current: \(current))", comment: "Insufficient level error")
        case .dataCorruption:
            return NSLocalizedString("Category data is corrupted", comment: "Data corruption error")
        case .networkError(let message):
            return NSLocalizedString("Network error: \(message ?? "Unknown")", comment: "Network error")
        case .configurationError(let message):
            return NSLocalizedString("Configuration error: \(message)", comment: "Configuration error")
        case .cacheError(let message):
            return NSLocalizedString("Cache error: \(message)", comment: "Cache error")
        case .validationError(let message):
            return NSLocalizedString("Validation error: \(message)", comment: "Validation error")
        case .timeoutError:
            return NSLocalizedString("Operation timed out", comment: "Timeout error")
        case .permissionDenied:
            return NSLocalizedString("Permission denied", comment: "Permission error")
        case .rateLimitExceeded:
            return NSLocalizedString("Rate limit exceeded", comment: "Rate limit error")
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .invalidIndex: return 1001
        case .categoryNotFound: return 1002
        case .categoryDisabled: return 1003
        case .insufficientLevel: return 1004
        case .dataCorruption: return 1005
        case .networkError: return 2001
        case .configurationError: return 3001
        case .cacheError: return 3002
        case .validationError: return 3003
        case .timeoutError: return 4001
        case .permissionDenied: return 4002
        case .rateLimitExceeded: return 4003
        }
    }
    
    public static func == (lhs: CategoryError, rhs: CategoryError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidIndex(let l), .invalidIndex(let r)): return l == r
        case (.categoryNotFound(let l), .categoryNotFound(let r)): return l == r
        case (.categoryDisabled(let l), .categoryDisabled(let r)): return l == r
        case (.insufficientLevel(let l1, let l2), .insufficientLevel(let r1, let r2)): return l1 == r1 && l2 == r2
        case (.dataCorruption, .dataCorruption): return true
        case (.networkError(let l), .networkError(let r)): return l == r
        case (.configurationError(let l), .configurationError(let r)): return l == r
        case (.cacheError(let l), .cacheError(let r)): return l == r
        case (.validationError(let l), .validationError(let r)): return l == r
        case (.timeoutError, .timeoutError): return true
        case (.permissionDenied, .permissionDenied): return true
        case (.rateLimitExceeded, .rateLimitExceeded): return true
        default: return false
        }
    }
}

// MARK: - Data Source Protocol

/// Protocol for category data source operations with Combine support
public protocol CategoryDataSource: AnyObject {
    var dataSourcePublisher: AnyPublisher<DataSourceEvent, Error> { get }
    
    func loadCategories() -> AnyPublisher<[CategoryModel], Error>
    func saveCategories(_ categories: [CategoryModel]) -> AnyPublisher<Void, Error>
    func category(for expressionType: MathExpression.ExpressionType) -> AnyPublisher<CategoryModel?, Error>
    func updateCategoryAvailability() -> AnyPublisher<Void, Error>
    func searchCategories(query: String) -> AnyPublisher<[CategoryModel], Error>
    func getCategoryStatistics() -> AnyPublisher<CategoryStatistics, Error>
}

/// Data source events
public enum DataSourceEvent {
    case dataLoaded([CategoryModel])
    case dataSaved
    case dataUpdated
    case cacheInvalidated
    case syncCompleted
    case offlineModeEnabled
    case onlineModeEnabled
}

/// Category statistics for analytics
public struct CategoryStatistics: Codable, Equatable {
    public let totalCategories: Int
    public let enabledCategories: Int
    public let avgCompletionTime: TimeInterval
    public let popularityRanking: [String]
    public let difficultyDistribution: [CategoryDifficulty: Int]
    public let lastUpdated: Date
    
    public init(
        totalCategories: Int,
        enabledCategories: Int,
        avgCompletionTime: TimeInterval,
        popularityRanking: [String],
        difficultyDistribution: [CategoryDifficulty: Int],
        lastUpdated: Date = Date()
    ) {
        self.totalCategories = totalCategories
        self.enabledCategories = enabledCategories
        self.avgCompletionTime = avgCompletionTime
        self.popularityRanking = popularityRanking
        self.difficultyDistribution = difficultyDistribution
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Configuration

/// Configuration object for CategoryViewModel behavior
public struct CategoryViewModelConfiguration: Equatable, Codable {
    public let enableAnalytics: Bool
    public let enableCaching: Bool
    public let cacheDuration: TimeInterval
    public let enableOfflineMode: Bool
    public let minimumRefreshInterval: TimeInterval
    public let maxRetryAttempts: Int
    public let timeoutInterval: TimeInterval
    public let enablePrefetching: Bool
    public let maxConcurrentOperations: Int
    public let enablePerformanceMonitoring: Bool
    public let logLevel: LogLevel
    
    public enum LogLevel: String, CaseIterable, Codable {
        case debug, info, warning, error, none
    }
    
    public init(
        enableAnalytics: Bool = true,
        enableCaching: Bool = true,
        cacheDuration: TimeInterval = 3600, // 1 hour
        enableOfflineMode: Bool = true,
        minimumRefreshInterval: TimeInterval = 300, // 5 minutes
        maxRetryAttempts: Int = 3,
        timeoutInterval: TimeInterval = 30,
        enablePrefetching: Bool = true,
        maxConcurrentOperations: Int = 5,
        enablePerformanceMonitoring: Bool = true,
        logLevel: LogLevel = .info
    ) {
        self.enableAnalytics = enableAnalytics
        self.enableCaching = enableCaching
        self.cacheDuration = cacheDuration
        self.enableOfflineMode = enableOfflineMode
        self.minimumRefreshInterval = minimumRefreshInterval
        self.maxRetryAttempts = maxRetryAttempts
        self.timeoutInterval = timeoutInterval
        self.enablePrefetching = enablePrefetching
        self.maxConcurrentOperations = maxConcurrentOperations
        self.enablePerformanceMonitoring = enablePerformanceMonitoring
        self.logLevel = logLevel
    }
    
    public static let `default` = CategoryViewModelConfiguration()
    public static let testing = CategoryViewModelConfiguration(
        enableAnalytics: false,
        enableCaching: false,
        enableOfflineMode: false,
        logLevel: .none
    )
    public static let production = CategoryViewModelConfiguration(
        enableAnalytics: true,
        enableCaching: true,
        enablePerformanceMonitoring: true,
        logLevel: .warning
    )
}

// MARK: - Performance Monitoring

/// Performance metrics for monitoring with Combine
public struct PerformanceMetrics: Codable, Equatable {
    public let loadTime: TimeInterval
    public let categoryCount: Int
    public let errorCount: Int
    public let lastUpdateTime: Date?
    public let memoryUsage: Int
    public let cacheHitRate: Double
    public let averageResponseTime: TimeInterval
    public let operationsPerSecond: Double
    public let timestamp: Date
    
    public init(
        loadTime: TimeInterval,
        categoryCount: Int,
        errorCount: Int,
        lastUpdateTime: Date?,
        memoryUsage: Int,
        cacheHitRate: Double = 0.0,
        averageResponseTime: TimeInterval = 0.0,
        operationsPerSecond: Double = 0.0,
        timestamp: Date = Date()
    ) {
        self.loadTime = loadTime
        self.categoryCount = categoryCount
        self.errorCount = errorCount
        self.lastUpdateTime = lastUpdateTime
        self.memoryUsage = memoryUsage
        self.cacheHitRate = cacheHitRate
        self.averageResponseTime = averageResponseTime
        self.operationsPerSecond = operationsPerSecond
        self.timestamp = timestamp
    }
}

// MARK: - State Management with Combine

/// Observable state object for category loading and error handling
@available(iOS 13.0, *)
public final class CategoryViewModelState: ObservableObject {
    @Published public private(set) var categories: [CategoryModel] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: CategoryError?
    @Published public private(set) var lastUpdateTime: Date?
    @Published public private(set) var searchResults: [CategoryModel] = []
    @Published public private(set) var statistics: CategoryStatistics?
    @Published public private(set) var performanceMetrics: PerformanceMetrics?
    
    private let stateSubject = PassthroughSubject<StateChange, Never>()
    
    public var statePublisher: AnyPublisher<StateChange, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    public enum StateChange {
        case categoriesUpdated([CategoryModel])
        case loadingChanged(Bool)
        case errorChanged(CategoryError?)
        case searchResultsUpdated([CategoryModel])
        case statisticsUpdated(CategoryStatistics)
        case performanceMetricsUpdated(PerformanceMetrics)
    }
    
    // MARK: - Internal Update Methods
    
    internal func updateCategories(_ categories: [CategoryModel]) {
        self.categories = categories
        self.lastUpdateTime = Date()
        stateSubject.send(.categoriesUpdated(categories))
    }
    
    internal func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        stateSubject.send(.loadingChanged(isLoading))
    }
    
    internal func setError(_ error: CategoryError?) {
        self.error = error
        stateSubject.send(.errorChanged(error))
    }
    
    internal func clearError() {
        setError(nil)
    }
    
    internal func updateSearchResults(_ results: [CategoryModel]) {
        self.searchResults = results
        stateSubject.send(.searchResultsUpdated(results))
    }
    
    internal func updateStatistics(_ statistics: CategoryStatistics) {
        self.statistics = statistics
        stateSubject.send(.statisticsUpdated(statistics))
    }
    
    internal func updatePerformanceMetrics(_ metrics: PerformanceMetrics) {
        self.performanceMetrics = metrics
        stateSubject.send(.performanceMetricsUpdated(metrics))
    }
}

// MARK: - Protocols

/// Enhanced protocol for CategoryViewModel with comprehensive functionality
public protocol CategoryViewModelProtocol: AnyObject {
    // MARK: - Properties
    var delegate: CategoryViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var configuration: CategoryViewModelConfiguration { get }
    
    // MARK: - Combine Publishers
    var categoriesPublisher: AnyPublisher<[CategoryModel], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<CategoryError?, Never> { get }
    var eventsPublisher: AnyPublisher<CategoryEvent, Never> { get }
    var performancePublisher: AnyPublisher<PerformanceMetrics, Never> { get }
    
    // MARK: - Core Methods
    func category(at index: Int) -> Result<CategoryModel, CategoryError>
    func categorySelected(at index: Int)
    func loadInitialData() -> AnyPublisher<Void, CategoryError>
    func refresh() -> AnyPublisher<Void, CategoryError>
    
    // MARK: - Advanced Methods
    func categoryByType(_ type: MathExpression.ExpressionType) -> CategoryModel?
    func availableCategories(for userLevel: Int) -> [CategoryModel]
    func searchCategories(query: String) -> AnyPublisher<[CategoryModel], CategoryError>
    func nextRecommendedCategory(for userLevel: Int, completedTypes: Set<MathExpression.ExpressionType>) -> CategoryModel?
    func estimatedCompletionTime(for category: CategoryModel) -> TimeInterval
    func canAccessCategory(_ category: CategoryModel, userLevel: Int) -> Bool
    func updateConfiguration(_ configuration: CategoryViewModelConfiguration)
}

/// Enhanced delegate protocol with additional callbacks
public protocol CategoryViewModelDelegate: AnyObject {
    func navigateToGameVC(with type: MathExpression.ExpressionType)
    
    // Optional methods with default implementations
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didLoadCategories categories: [CategoryModel])
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didFailWithError error: CategoryError)
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didStartLoading isLoading: Bool)
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didUpdateCategory category: CategoryModel)
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didUpdatePerformanceMetrics metrics: PerformanceMetrics)
}

// MARK: - Default Delegate Implementations
public extension CategoryViewModelDelegate {
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didLoadCategories categories: [CategoryModel]) {}
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didFailWithError error: CategoryError) {}
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didStartLoading isLoading: Bool) {}
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didUpdateCategory category: CategoryModel) {}
    func categoryViewModel(_ viewModel: CategoryViewModelProtocol, didUpdatePerformanceMetrics metrics: PerformanceMetrics) {}
}

// MARK: - Main ViewModel Implementation

/// Enterprise-level CategoryViewModel with comprehensive Combine integration
@available(iOS 13.0, *)
public final class CategoryViewModel: CategoryViewModelProtocol, ObservableObject {
    
    // MARK: - Public Properties
    public weak var delegate: CategoryViewModelDelegate?
    public private(set) var configuration: CategoryViewModelConfiguration
    public let state = CategoryViewModelState()
    
    public var numberOfItems: Int {
        state.categories.count
    }
    
    // MARK: - Combine Publishers
    public var categoriesPublisher: AnyPublisher<[CategoryModel], Never> {
        state.$categories.eraseToAnyPublisher()
    }
    
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        state.$isLoading.eraseToAnyPublisher()
    }
    
    public var errorPublisher: AnyPublisher<CategoryError?, Never> {
        state.$error.eraseToAnyPublisher()
    }
    
    public var eventsPublisher: AnyPublisher<CategoryEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }
    
    public var performancePublisher: AnyPublisher<PerformanceMetrics, Never> {
        state.$performanceMetrics
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let dataSource: CategoryDataSource?
    private let analyticsTracker: CategoryAnalyticsTracking
    private let logger = Logger(subsystem: "com.mathquizmastery", category: "CategoryViewModel")
    
    // Combine subjects
    private let eventsSubject = PassthroughSubject<CategoryEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // Performance tracking
    private var performanceTracker = PerformanceTracker()
    private var operationQueue = OperationQueue()
    
    // Thread safety
    private let accessQueue = DispatchQueue(label: "categoryvm.access", attributes: .concurrent)
    private let categoriesLock = NSLock()
    private var internalCategories: [CategoryModel] = []
    
    // Cache management
    private var lastRefreshTime: Date?
    private var retryCount = 0
    
    // MARK: - Constants
    private enum Constants {
        static let defaultCategories: [CategoryModel] = [
            CategoryModel(
                iconName: "add_icon",
                categoryName: "addition",
                expressionType: .addition,
                description: "Master addition problems with confidence",
                difficulty: .easy,
                estimatedCompletionTime: 180,
                rewardCoins: 5
            ),
            CategoryModel(
                iconName: "minus_icon",
                categoryName: "subtraction",
                expressionType: .subtraction,
                description: "Perfect your subtraction skills",
                difficulty: .easy,
                estimatedCompletionTime: 200,
                rewardCoins: 5
            ),
            CategoryModel(
                iconName: "multiply_icon",
                categoryName: "multiplication",
                expressionType: .multiplication,
                description: "Enhance multiplication abilities",
                difficulty: .medium,
                estimatedCompletionTime: 240,
                rewardCoins: 10
            ),
            CategoryModel(
                iconName: "divide_icon",
                categoryName: "division",
                expressionType: .division,
                description: "Master division techniques",
                difficulty: .medium,
                estimatedCompletionTime: 280,
                rewardCoins: 10
            ),
            CategoryModel(
                iconName: "random_icon",
                categoryName: "mixed",
                expressionType: .mixed,
                description: "Challenge yourself with mixed operations",
                difficulty: .hard,
                estimatedCompletionTime: 360,
                rewardCoins: 20
            )
        ]
    }
    
    // MARK: - Initialization
    
    public init(
        dataSource: CategoryDataSource? = nil,
        analyticsTracker: CategoryAnalyticsTracking? = nil,
        configuration: CategoryViewModelConfiguration = .default,
        delegate: CategoryViewModelDelegate? = nil
    ) {
        self.dataSource = dataSource
        self.analyticsTracker = analyticsTracker ?? DefaultCategoryAnalyticsTracker()
        self.configuration = configuration
        self.delegate = delegate
        
        setupOperationQueue()
        setupDefaultCategories()
        setupObservers()
        setupPerformanceTracking()
        
        logger.info("🚀 CategoryViewModel initialized with \(Constants.defaultCategories.count) default categories")
        
        // Start analytics session
        analyticsTracker!.analyticsPublisher
            .sink { [weak self] event in
                self?.handleAnalyticsEvent(event)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
        logger.debug("💀 CategoryViewModel deallocated")
    }
    
    // MARK: - Private Setup Methods
    
    private func setupOperationQueue() {
        operationQueue.maxConcurrentOperationCount = configuration.maxConcurrentOperations
        operationQueue.qualityOfService = .userInitiated
    }
    
    private func setupDefaultCategories() {
        updateInternalCategories(Constants.defaultCategories)
        state.updateCategories(Constants.defaultCategories)
        logger.debug("📚 Default categories loaded: \(Constants.defaultCategories.count) items")
    }
    
    private func setupObservers() {
        // Observe category changes
        categoriesPublisher
            .dropFirst()
            .sink { [weak self] categories in
                guard let self = self else { return }
                self.eventsSubject.send(.categoriesLoaded(categories))
                self.delegate?.categoryViewModel(self, didLoadCategories: categories)
                self.updatePerformanceMetrics()
            }
            .store(in: &cancellables)
        
        // Observe loading state changes
        isLoadingPublisher
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.eventsSubject.send(.loadingStateChanged(isLoading))
                self.delegate?.categoryViewModel(self, didStartLoading: isLoading)
            }
            .store(in: &cancellables)
        
        // Observe and handle errors
        errorPublisher
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let self = self else { return }
                self.eventsSubject.send(.errorOccurred(error))
                self.analyticsTracker.trackCategoryError(error, context: "ViewModel Observer")
                self.delegate?.categoryViewModel(self, didFailWithError: error)
                self.logger.error("❌ Category error observed: \(error.localizedDescription)")
            }
            .store(in: &cancellables)
        
        // Observe state changes
        state.statePublisher
            .sink { [weak self] stateChange in
                guard let self = self else { return }
                self.handleStateChange(stateChange)
            }
            .store(in: &cancellables)
        
        // Setup data source observers if available
        dataSource?.dataSourcePublisher
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleDataSourceError(error)
                    }
                },
                receiveValue: { [weak self] event in
                    self?.handleDataSourceEvent(event)
                }
            )
            .store(in: &cancellables)
    }
    
    private func setupPerformanceTracking() {
        guard configuration.enablePerformanceMonitoring else { return }
        
        // Track performance metrics every 30 seconds
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updatePerformanceMetrics()
            }
            .store(in: &cancellables)
    }
    
    private func updateInternalCategories(_ categories: [CategoryModel]) {
        categoriesLock.lock()
        defer { categoriesLock.unlock() }
        internalCategories = categories
    }
    
    private func getInternalCategories() -> [CategoryModel] {
        categoriesLock.lock()
        defer { categoriesLock.unlock() }
        return internalCategories
    }
    
    // MARK: - Event Handlers
    
    private func handleAnalyticsEvent(_ event: AnalyticsEvent) {
        logger.debug("📊 Analytics event: \(String(describing: event))")
        // Additional analytics processing can be added here
    }
    
    private func handleStateChange(_ stateChange: CategoryViewModelState.StateChange) {
        switch stateChange {
        case .categoriesUpdated(let categories):
            updateInternalCategories(categories)
        case .performanceMetricsUpdated(let metrics):
            delegate?.categoryViewModel(self, didUpdatePerformanceMetrics: metrics)
            eventsSubject.send(.performanceMetricsUpdated(metrics))
        default:
            break
        }
    }
    
    private func handleDataSourceEvent(_ event: DataSourceEvent) {
        logger.info("📡 Data source event: \(String(describing: event))")
        switch event {
        case .dataLoaded(let categories):
            updateInternalCategories(categories)
            state.updateCategories(categories)
        case .cacheInvalidated:
            eventsSubject.send(.cacheCleared)
        default:
            break
        }
    }
    
    private func handleDataSourceError(_ error: Error) {
        let categoryError = error as? CategoryError ?? CategoryError.networkError(underlying: error.localizedDescription)
        state.setError(categoryError)
    }
    
    // MARK: - Core Protocol Methods
    
    public func category(at index: Int) -> Result<CategoryModel, CategoryError> {
        let startTime = CFAbsoluteTimeGetCurrent()
        defer {
            let endTime = CFAbsoluteTimeGetCurrent()
            performanceTracker.recordOperation(duration: endTime - startTime)
        }
        
        let categories = getInternalCategories()
        
        guard index >= 0 && index < categories.count else {
            let error = CategoryError.invalidIndex(index)
            state.setError(error)
            return .failure(error)
        }
        
        let category = categories[index]
        
        if configuration.enableAnalytics {
            analyticsTracker.trackCategoryViewed(category)
        }
        
        eventsSubject.send(.categoryViewed(category))
        return .success(category)
    }
    
    public func categorySelected(at index: Int) {
        let result = category(at: index)
        
        switch result {
        case .success(let category):
            guard category.isEnabled else {
                let error = CategoryError.categoryDisabled(category.categoryName)
                state.setError(error)
                return
            }
            
            if configuration.enableAnalytics {
                analyticsTracker.trackCategorySelected(category, at: index)
            }
            
            eventsSubject.send(.categorySelected(category, index))
            
            // Analyze user behavior
            analyzeUserBehavior(selectedCategory: category, at: index)
            
            // Notify delegate
            delegate?.navigateToGameVC(with: category.expressionType)
            
            logger.info("✅ Category selected successfully: \(category.categoryName) at index: \(index)")
            
        case .failure(let error):
            state.setError(error)
            logger.error("❌ Failed to select category at index \(index): \(error.localizedDescription)")
        }
    }
    
    public func loadInitialData() -> AnyPublisher<Void, CategoryError> {
        guard !state.isLoading else {
            logger.debug("⏳ Load operation already in progress")
            return Just(()).setFailureType(to: CategoryError.self).eraseToAnyPublisher()
        }
        
        state.setLoading(true)
        state.clearError()
        retryCount = 0
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        return Future<Void, CategoryError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.configurationError("ViewModel deallocated")))
                return
            }
            
            if let dataSource = self.dataSource {
                // Load from data source with retry
                self.loadCategoriesWithRetry(from: dataSource)
                    .sink(
                        receiveCompletion: { completion in
                            let endTime = CFAbsoluteTimeGetCurrent()
                            self.performanceTracker.recordLoadTime(endTime - startTime)
                            
                            switch completion {
                            case .finished:
                                self.lastRefreshTime = Date()
                                self.state.setLoading(false)
                                promise(.success(()))
                            case .failure(let error):
                                let categoryError = error as? CategoryError ?? CategoryError.networkError(underlying: error.localizedDescription)
                                self.handleLoadError(categoryError)
                                self.state.setLoading(false)
                                promise(.failure(categoryError))
                            }
                        },
                        receiveValue: { categories in
                            self.updateInternalCategories(categories)
                            self.state.updateCategories(categories)
                            self.logger.info("📊 Categories loaded from data source: \(categories.count) items")
                        }
                    )
                    .store(in: &self.cancellables)
            } else {
                // Use default categories
                let categories = Constants.defaultCategories
                self.updateInternalCategories(categories)
                self.state.updateCategories(categories)
                self.lastRefreshTime = Date()
                self.state.setLoading(false)
                
                let endTime = CFAbsoluteTimeGetCurrent()
                self.performanceTracker.recordLoadTime(endTime - startTime)
                
                self.logger.debug("📚 Using default categories: \(categories.count) items")
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func refresh() -> AnyPublisher<Void, CategoryError> {
        // Check minimum refresh interval
        if let lastRefresh = lastRefreshTime,
           Date().timeIntervalSince(lastRefresh) < configuration.minimumRefreshInterval {
            logger.debug("🔄 Refresh skipped due to minimum interval")
            return Just(()).setFailureType(to: CategoryError.self).eraseToAnyPublisher()
        }
        
        return loadInitialData()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.eventsSubject.send(.refreshCompleted)
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Advanced Methods
    
    public func categoryByType(_ type: MathExpression.ExpressionType) -> CategoryModel? {
        return getInternalCategories().first { $0.expressionType == type }
    }
    
    public func availableCategories(for userLevel: Int) -> [CategoryModel] {
        return getInternalCategories().filter { canAccessCategory($0, userLevel: userLevel) }
    }
    
    public func searchCategories(query: String) -> AnyPublisher<[CategoryModel], CategoryError> {
        let searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !searchQuery.isEmpty else {
            return Just([]).setFailureType(to: CategoryError.self).eraseToAnyPublisher()
        }
        
        return Future<[CategoryModel], CategoryError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.configurationError("ViewModel deallocated")))
                return
            }
            
            let categories = self.getInternalCategories()
            let results = categories.filter { category in
                category.categoryName.lowercased().contains(searchQuery) ||
                category.displayName.lowercased().contains(searchQuery) ||
                category.description.lowercased().contains(searchQuery)
            }
            
            self.state.updateSearchResults(results)
            promise(.success(results))
        }
        .eraseToAnyPublisher()
    }
    
    public func nextRecommendedCategory(
        for userLevel: Int,
        completedTypes: Set<MathExpression.ExpressionType>
    ) -> CategoryModel? {
        let availableCategories = availableCategories(for: userLevel)
        
        // First, recommend incomplete categories
        let incompleteCategories = availableCategories.filter { !completedTypes.contains($0.expressionType) }
        
        if !incompleteCategories.isEmpty {
            // Sort by difficulty and return easiest incomplete category
            return incompleteCategories.min { $0.difficulty.multiplier < $1.difficulty.multiplier }
        }
        
        // If all available categories are completed, recommend based on difficulty progression
        return availableCategories.min { $0.minimumRequiredLevel < $1.minimumRequiredLevel }
    }
    
    public func estimatedCompletionTime(for category: CategoryModel) -> TimeInterval {
        return category.estimatedCompletionTime * category.difficulty.multiplier
    }
    
    public func canAccessCategory(_ category: CategoryModel, userLevel: Int) -> Bool {
        return category.isEnabled && userLevel >= category.minimumRequiredLevel
    }
    
    public func updateConfiguration(_ configuration: CategoryViewModelConfiguration) {
        self.configuration = configuration
        setupOperationQueue()
        
        if configuration.enablePerformanceMonitoring {
            setupPerformanceTracking()
        }
        
        eventsSubject.send(.configurationUpdated(configuration))
        logger.info("⚙️ Configuration updated")
    }
    
    // MARK: - Private Helper Methods
    
    private func loadCategoriesWithRetry(from dataSource: CategoryDataSource) -> AnyPublisher<[CategoryModel], Error> {
        return dataSource.loadCategories()
            .timeout(.seconds(configuration.timeoutInterval), scheduler: DispatchQueue.main)
            .retry(configuration.maxRetryAttempts)
            .catch { [weak self] error -> AnyPublisher<[CategoryModel], Error> in
                self?.logger.warning("🔄 Load failed after \(self?.configuration.maxRetryAttempts ?? 0) attempts: \(error.localizedDescription)")
                
                // Fallback to cache or default categories
                if self?.configuration.enableOfflineMode == true {
                    return Just(Constants.defaultCategories)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func handleLoadError(_ error: CategoryError) {
        state.setError(error)
        analyticsTracker.trackCategoryError(error, context: "Load Operation")
        
        // Fallback to default categories in offline mode
        if configuration.enableOfflineMode && getInternalCategories().isEmpty {
            updateInternalCategories(Constants.defaultCategories)
            state.updateCategories(Constants.defaultCategories)
            logger.warning("⚠️ Fallback to default categories due to error")
        }
    }
    
    private func analyzeUserBehavior(selectedCategory: CategoryModel, at index: Int) {
        // Simple behavior analysis - can be enhanced with ML
        let categories = getInternalCategories()
        
        if index == 0 {
            analyticsTracker.trackUserBehavior(.systematicProgress)
        } else if index == categories.count - 1 {
            analyticsTracker.trackUserBehavior(.randomExploration)
        } else if selectedCategory.difficulty == .hard || selectedCategory.difficulty == .expert {
            analyticsTracker.trackUserBehavior(.difficultyProgression)
        } else {
            analyticsTracker.trackUserBehavior(.quickSelection)
        }
    }
    
    private func updatePerformanceMetrics() {
        let categories = getInternalCategories()
        let metrics = PerformanceMetrics(
            loadTime: performanceTracker.averageLoadTime,
            categoryCount: categories.count,
            errorCount: state.error != nil ? 1 : 0,
            lastUpdateTime: lastRefreshTime,
            memoryUsage: MemoryLayout<CategoryModel>.size * categories.count,
            cacheHitRate: performanceTracker.cacheHitRate,
            averageResponseTime: performanceTracker.averageResponseTime,
            operationsPerSecond: performanceTracker.operationsPerSecond
        )
        
        state.updatePerformanceMetrics(metrics)
        
        if configuration.enableAnalytics {
            analyticsTracker.trackPerformanceMetric("load_time", metrics.loadTime, "categories")
            analyticsTracker.trackPerformanceMetric("memory_usage", Double(metrics.memoryUsage), "categories")
        }
    }
    
    private func validateCategoryData(_ categories: [CategoryModel]) throws {
        guard !categories.isEmpty else {
            throw CategoryError.dataCorruption
        }
        
        // Check for duplicate expression types
        let expressionTypes = categories.map { $0.expressionType }
        let uniqueTypes = Set(expressionTypes)
        
        if expressionTypes.count != uniqueTypes.count {
            throw CategoryError.validationError("Duplicate expression types found")
        }
        
        // Validate required categories
        let requiredTypes: Set<MathExpression.ExpressionType> = [.addition, .subtraction, .multiplication, .division]
        let providedTypes = Set(expressionTypes)
        
        if !requiredTypes.isSubset(of: providedTypes) {
            let missingTypes = requiredTypes.subtracting(providedTypes)
            throw CategoryError.validationError("Missing required categories: \(missingTypes)")
        }
        
        // Validate category data integrity
        for category in categories {
            if category.iconName.isEmpty || category.categoryName.isEmpty {
                throw CategoryError.validationError("Invalid category data: empty fields")
            }
            
            if category.estimatedCompletionTime <= 0 || category.rewardCoins < 0 {
                throw CategoryError.validationError("Invalid category values")
            }
        }
    }
}

// MARK: - Performance Tracker

private final class PerformanceTracker {
    private var loadTimes: [TimeInterval] = []
    private var operationTimes: [TimeInterval] = []
    private var cacheHits = 0
    private var cacheMisses = 0
    private let lock = NSLock()
    
    var averageLoadTime: TimeInterval {
        lock.lock()
        defer { lock.unlock() }
        return loadTimes.isEmpty ? 0 : loadTimes.reduce(0, +) / Double(loadTimes.count)
    }
    
    var averageResponseTime: TimeInterval {
        lock.lock()
        defer { lock.unlock() }
        return operationTimes.isEmpty ? 0 : operationTimes.reduce(0, +) / Double(operationTimes.count)
    }
    
    var operationsPerSecond: Double {
        lock.lock()
        defer { lock.unlock() }
        return operationTimes.isEmpty ? 0 : Double(operationTimes.count) / operationTimes.reduce(0, +)
    }
    
    var cacheHitRate: Double {
        lock.lock()
        defer { lock.unlock() }
        let total = cacheHits + cacheMisses
        return total == 0 ? 0 : Double(cacheHits) / Double(total)
    }
    
    func recordLoadTime(_ time: TimeInterval) {
        lock.lock()
        defer { lock.unlock() }
        loadTimes.append(time)
        if loadTimes.count > 100 { loadTimes.removeFirst() } // Keep last 100
    }
    
    func recordOperation(duration: TimeInterval) {
        lock.lock()
        defer { lock.unlock() }
        operationTimes.append(duration)
        if operationTimes.count > 1000 { operationTimes.removeFirst() } // Keep last 1000
    }
    
    func recordCacheHit() {
        lock.lock()
        defer { lock.unlock() }
        cacheHits += 1
    }
    
    func recordCacheMiss() {
        lock.lock()
        defer { lock.unlock() }
        cacheMisses += 1
    }
}

// MARK: - Thread Safety Extensions

@available(iOS 13.0, *)
public extension CategoryViewModel {
    
    /// Thread-safe category access with Combine
    func safeCategoryAccess(at index: Int) -> AnyPublisher<CategoryModel, CategoryError> {
        return Future<CategoryModel, CategoryError> { [weak self] promise in
            self?.accessQueue.async {
                let result = self?.category(at: index) ?? .failure(.configurationError("ViewModel unavailable"))
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Thread-safe category selection with Combine
    func safeCategorySelection(at index: Int) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            self?.accessQueue.async {
                self?.categorySelected(at: index)
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Cache Management

@available(iOS 13.0, *)
public extension CategoryViewModel {
    
    /// Clear cached categories and reload with Combine
    func clearCacheAndReload() -> AnyPublisher<Void, CategoryError> {
        updateInternalCategories([])
        state.updateCategories([])
        eventsSubject.send(.cacheCleared)
        
        return loadInitialData()
    }
    
    /// Get cache statistics
    func getCacheStatistics() -> AnyPublisher<(count: Int, lastUpdate: Date?), Never> {
        return Just((count: getInternalCategories().count, lastUpdate: lastRefreshTime))
            .eraseToAnyPublisher()
    }
    
    /// Prefetch categories if enabled
    func prefetchCategories() -> AnyPublisher<Void, CategoryError> {
        guard configuration.enablePrefetching else {
            return Just(()).setFailureType(to: CategoryError.self).eraseToAnyPublisher()
        }
        
        return loadInitialData()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.logger.info("🚀 Categories prefetched successfully")
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Debug and Testing Support

#if DEBUG
@available(iOS 13.0, *)
public extension CategoryViewModel {
    
    /// Force error state for testing
    func forceError(_ error: CategoryError) {
        state.setError(error)
    }
    
    /// Force loading state for testing
    func forceLoadingState(_ isLoading: Bool) {
        state.setLoading(isLoading)
    }
    
    /// Override categories for testing
    func overrideCategories(_ categories: [CategoryModel]) {
        updateInternalCategories(categories)
        state.updateCategories(categories)
    }
    
    /// Get internal state for testing
    var debugInfo: (categories: [CategoryModel], isLoading: Bool, error: CategoryError?, retryCount: Int) {
        return (
            categories: getInternalCategories(),
            isLoading: state.isLoading,
            error: state.error,
            retryCount: retryCount
        )
    }
    
    /// Get all publishers for testing
    var testPublishers: (
        categories: AnyPublisher<[CategoryModel], Never>,
        loading: AnyPublisher<Bool, Never>,
        errors: AnyPublisher<CategoryError?, Never>,
        events: AnyPublisher<CategoryEvent, Never>
    ) {
        return (
            categories: categoriesPublisher,
            loading: isLoadingPublisher,
            errors: errorPublisher,
            events: eventsPublisher
        )
    }
}
#endif

// MARK: - Convenience Extensions

public extension CategoryModel {
    
    /// Create test category for unit testing
    static func makeTestCategory(
        iconName: String = "test_icon",
        categoryName: String = "test_category",
        expressionType: MathExpression.ExpressionType = .addition
    ) -> CategoryModel {
        return CategoryModel(
            iconName: iconName,
            categoryName: categoryName,
            expressionType: expressionType
        )
    }
    
    /// Create all standard categories
    static func makeAllCategories() -> [CategoryModel] {
        return [
            CategoryModel(iconName: "add_icon", categoryName: "addition", expressionType: .addition),
            CategoryModel(iconName: "minus_icon", categoryName: "subtraction", expressionType: .subtraction),
            CategoryModel(iconName: "multiply_icon", categoryName: "multiplication", expressionType: .multiplication),
            CategoryModel(iconName: "divide_icon", categoryName: "division", expressionType: .division),
            CategoryModel(iconName: "random_icon", categoryName: "mixed", expressionType: .mixed)
        ]
    }
    
    /// Create categories with different difficulties for testing
    static func makeTestCategories(count: Int) -> [CategoryModel] {
        let difficulties: [CategoryDifficulty] = [.beginner, .easy, .medium, .hard, .expert, .master]
        let types: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
        
        return (0..<count).map { index in
            CategoryModel(
                iconName: "test_icon_\(index)",
                categoryName: "test_category_\(index)",
                expressionType: types[index % types.count],
                difficulty: difficulties[index % difficulties.count],
                rewardCoins: (index + 1) * 5
            )
        }
    }
}

// MARK: - Backward Compatibility

/// Legacy ViewModel for iOS 12 and below (without Combine)
public final class LegacyCategoryViewModel: CategoryViewModelProtocol {
    public weak var delegate: CategoryViewModelDelegate?
    public let configuration: CategoryViewModelConfiguration
    
    private var categories: [CategoryModel] = []
    private var isLoading = false
    private var error: CategoryError?
    
    public var numberOfItems: Int { categories.count }
    
    // Dummy publishers for protocol compliance (will not emit on iOS 12)
    public var categoriesPublisher: AnyPublisher<[CategoryModel], Never> {
        fatalError("Combine not available on iOS 12. Use delegate methods instead.")
    }
    
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        fatalError("Combine not available on iOS 12. Use delegate methods instead.")
    }
    
    public var errorPublisher: AnyPublisher<CategoryError?, Never> {
        fatalError("Combine not available on iOS 12. Use delegate methods instead.")
    }
    
    public var eventsPublisher: AnyPublisher<CategoryEvent, Never> {
        fatalError("Combine not available on iOS 12. Use delegate methods instead.")
    }
    
    public var performancePublisher: AnyPublisher<PerformanceMetrics, Never> {
        fatalError("Combine not available on iOS 12. Use delegate methods instead.")
    }
    
    public init(configuration: CategoryViewModelConfiguration = .default) {
        self.configuration = configuration
        self.categories = CategoryModel.makeAllCategories()
    }
    
    public func category(at index: Int) -> Result<CategoryModel, CategoryError> {
        guard index >= 0 && index < categories.count else {
            return .failure(.invalidIndex(index))
        }
        return .success(categories[index])
    }
    
    public func categorySelected(at index: Int) {
        let result = category(at: index)
        switch result {
        case .success(let category):
            delegate?.navigateToGameVC(with: category.expressionType)
        case .failure(let error):
            delegate?.categoryViewModel(self, didFailWithError: error)
        }
    }
    
    public func loadInitialData() -> AnyPublisher<Void, CategoryError> {
        fatalError("Combine not available on iOS 12. Use completion-based methods instead.")
    }
    
    public func refresh() -> AnyPublisher<Void, CategoryError> {
        fatalError("Combine not available on iOS 12. Use completion-based methods instead.")
    }
    
    public func categoryByType(_ type: MathExpression.ExpressionType) -> CategoryModel? {
        return categories.first { $0.expressionType == type }
    }
    
    public func availableCategories(for userLevel: Int) -> [CategoryModel] {
        return categories.filter { canAccessCategory($0, userLevel: userLevel) }
    }
    
    public func searchCategories(query: String) -> AnyPublisher<[CategoryModel], CategoryError> {
        fatalError("Combine not available on iOS 12. Use completion-based methods instead.")
    }
    
    public func nextRecommendedCategory(for userLevel: Int, completedTypes: Set<MathExpression.ExpressionType>) -> CategoryModel? {
        return categories.first { !completedTypes.contains($0.expressionType) && canAccessCategory($0, userLevel: userLevel) }
    }
    
    public func estimatedCompletionTime(for category: CategoryModel) -> TimeInterval {
        return category.estimatedCompletionTime * category.difficulty.multiplier
    }
    
    public func canAccessCategory(_ category: CategoryModel, userLevel: Int) -> Bool {
        return category.isEnabled && userLevel >= category.minimumRequiredLevel
    }
    
    public func updateConfiguration(_ configuration: CategoryViewModelConfiguration) {
        // Configuration update for legacy version
    }
}

// MARK: - Factory

/// Factory for creating appropriate ViewModel based on iOS version
public final class CategoryViewModelFactory {
    
    /// Shared instance of analytics tracker to reuse across app
    public static let sharedAnalyticsTracker = DefaultCategoryAnalyticsTracker()
    
    public static func create(
        dataSource: CategoryDataSource? = nil,
        analyticsTracker: CategoryAnalyticsTracking? = nil,
        configuration: CategoryViewModelConfiguration = .default,
        delegate: CategoryViewModelDelegate? = nil
    ) -> CategoryViewModelProtocol {
        
        let tracker = analyticsTracker ?? sharedAnalyticsTracker
        
        if #available(iOS 13.0, *) {
            return CategoryViewModel(
                dataSource: dataSource,
                analyticsTracker: tracker,
                configuration: configuration,
                delegate: delegate
            )
        } else {
            return LegacyCategoryViewModel(configuration: configuration)
        }
    }
    
    /// Create with default analytics tracker
    public static func createDefault(
        dataSource: CategoryDataSource? = nil,
        configuration: CategoryViewModelConfiguration = .default,
        delegate: CategoryViewModelDelegate? = nil
    ) -> CategoryViewModelProtocol {
        return create(
            dataSource: dataSource,
            analyticsTracker: nil,
            configuration: configuration,
            delegate: delegate
        )
    }
    
    /// Create for testing (no analytics)
    public static func createForTesting(
        dataSource: CategoryDataSource? = nil,
        configuration: CategoryViewModelConfiguration = .testing,
        delegate: CategoryViewModelDelegate? = nil
    ) -> CategoryViewModelProtocol {
        return create(
            dataSource: dataSource,
            analyticsTracker: MockAnalyticsTracker(),
            configuration: configuration,
            delegate: delegate
        )
    }
}

////
////  CategoryViewModelTests.swift
////  MathQuizMasteryTests
////
////  Created by AydınKaya on 2.07.2025.
////
//
//import XCTest
//@testable import MathQuizMastery
//
//// MARK: - Mock Dependencies
//
///// Mock implementation of CategoryViewModelDelegate for testing purposes
//class MockCategoryViewModelDelegate: CategoryViewModelDelegate {
//    
//    // MARK: - Captured Method Calls
//    var navigateToGameVCCallCount = 0
//    
//    // MARK: - Captured Parameters
//    var capturedExpressionTypes: [MathExpression.ExpressionType] = []
//    
//    // MARK: - CategoryViewModelDelegate Implementation
//    
//    func navigateToGameVC(with type: MathExpression.ExpressionType) {
//        navigateToGameVCCallCount += 1
//        capturedExpressionTypes.append(type)
//    }
//}
//
//// MARK: - CategoryViewModel Tests
//
//final class CategoryViewModelTests: XCTestCase {
//    
//    // MARK: - Properties
//    
//    private var viewModel: CategoryViewModel!
//    private var mockDelegate: MockCategoryViewModelDelegate!
//    
//    // MARK: - Setup & Teardown
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        viewModel = CategoryViewModel()
//        mockDelegate = MockCategoryViewModelDelegate()
//        viewModel.delegate = mockDelegate
//    }
//    
//    override func tearDownWithError() throws {
//        viewModel = nil
//        mockDelegate = nil
//        try super.tearDownWithError()
//    }
//    
//    // MARK: - Initialization Tests
//    
//    func test_Init_ShouldInitializeWithCorrectNumberOfCategories() {
//        // Given/When - Setup is done in setUpWithError
//        
//        // Then
//        XCTAssertNotNil(viewModel, "ViewModel should be initialized")
//        XCTAssertEqual(viewModel.numberOfItems, 5, "Should have exactly 5 categories")
//        XCTAssertTrue(viewModel.delegate === mockDelegate, "Delegate should be set correctly")
//    }
//    
//    // MARK: - Category Data Tests
//    
//    func test_NumberOfItems_ShouldReturnCorrectCount() {
//        // Given/When
//        let numberOfItems = viewModel.numberOfItems
//        
//        // Then
//        XCTAssertEqual(numberOfItems, 5, "Should return exactly 5 categories")
//    }
//    
//    func test_CategoryAtIndex_ShouldReturnCorrectCategoryForAllIndices() {
//        // Given
//        let expectedCategories = [
//            ("add_icon", "addition", MathExpression.ExpressionType.addition),
//            ("minus_icon", "subtraction", MathExpression.ExpressionType.subtraction),
//            ("multiply_icon", "multiplication", MathExpression.ExpressionType.multiplication),
//            ("divide_icon", "division", MathExpression.ExpressionType.division),
//            ("random_icon", "mixed", MathExpression.ExpressionType.mixed)
//        ]
//        
//        // When/Then
//        for (index, expectedCategory) in expectedCategories.enumerated() {
//            let category = viewModel.category(at: index)
//            
//            XCTAssertEqual(category.iconName, expectedCategory.0, "Icon name should match for index \(index)")
//            XCTAssertEqual(category.categoryName, expectedCategory.1, "Category name should match for index \(index)")
//            XCTAssertEqual(category.expressionType, expectedCategory.2, "Expression type should match for index \(index)")
//        }
//    }
//    
//    func test_CategoryAtIndex_Addition_ShouldReturnCorrectData() {
//        // Given
//        let index = 0
//        
//        // When
//        let category = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "add_icon")
//        XCTAssertEqual(category.categoryName, "addition")
//        XCTAssertEqual(category.expressionType, .addition)
//    }
//    
//    func test_CategoryAtIndex_Subtraction_ShouldReturnCorrectData() {
//        // Given
//        let index = 1
//        
//        // When
//        let category = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "minus_icon")
//        XCTAssertEqual(category.categoryName, "subtraction")
//        XCTAssertEqual(category.expressionType, .subtraction)
//    }
//    
//    func test_CategoryAtIndex_Multiplication_ShouldReturnCorrectData() {
//        // Given
//        let index = 2
//        
//        // When
//        let category = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "multiply_icon")
//        XCTAssertEqual(category.categoryName, "multiplication")
//        XCTAssertEqual(category.expressionType, .multiplication)
//    }
//    
//    func test_CategoryAtIndex_Division_ShouldReturnCorrectData() {
//        // Given
//        let index = 3
//        
//        // When
//        let category = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "divide_icon")
//        XCTAssertEqual(category.categoryName, "division")
//        XCTAssertEqual(category.expressionType, .division)
//    }
//    
//    func test_CategoryAtIndex_Mixed_ShouldReturnCorrectData() {
//        // Given
//        let index = 4
//        
//        // When
//        let category = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "random_icon")
//        XCTAssertEqual(category.categoryName, "mixed")
//        XCTAssertEqual(category.expressionType, .mixed)
//    }
//    
//    // MARK: - Category Selection Tests
//    
//    func test_CategorySelected_Addition_ShouldNotifyDelegateWithCorrectType() {
//        // Given
//        let index = 0
//        
//        // When
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 1, "Should capture exactly one expression type")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .addition, "Should navigate with addition type")
//    }
//    
//    func test_CategorySelected_Subtraction_ShouldNotifyDelegateWithCorrectType() {
//        // Given
//        let index = 1
//        
//        // When
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .subtraction, "Should navigate with subtraction type")
//    }
//    
//    func test_CategorySelected_Multiplication_ShouldNotifyDelegateWithCorrectType() {
//        // Given
//        let index = 2
//        
//        // When
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .multiplication, "Should navigate with multiplication type")
//    }
//    
//    func test_CategorySelected_Division_ShouldNotifyDelegateWithCorrectType() {
//        // Given
//        let index = 3
//        
//        // When
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .division, "Should navigate with division type")
//    }
//    
//    func test_CategorySelected_Mixed_ShouldNotifyDelegateWithCorrectType() {
//        // Given
//        let index = 4
//        
//        // When
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .mixed, "Should navigate with mixed type")
//    }
//    
//    func test_CategorySelected_MultipleSelections_ShouldHandleCorrectly() {
//        // Given
//        let selections = [0, 2, 4, 1, 3] // addition, multiplication, mixed, subtraction, division
//        let expectedTypes: [MathExpression.ExpressionType] = [.addition, .multiplication, .mixed, .subtraction, .division]
//        
//        // When
//        for index in selections {
//            viewModel.categorySelected(at: index)
//        }
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 5, "Should capture five expression types")
//        
//        for (index, expectedType) in expectedTypes.enumerated() {
//            XCTAssertEqual(mockDelegate.capturedExpressionTypes[index], expectedType, "Expression type at index \(index) should match")
//        }
//    }
//    
//    // MARK: - Edge Cases Tests
//    
//    func test_CategorySelected_SameIndexMultipleTimes_ShouldHandleCorrectly() {
//        // Given
//        let index = 2 // multiplication
//        
//        // When
//        viewModel.categorySelected(at: index)
//        viewModel.categorySelected(at: index)
//        viewModel.categorySelected(at: index)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 3, "Delegate should be called three times")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 3, "Should capture three expression types")
//        
//        for expressionType in mockDelegate.capturedExpressionTypes {
//            XCTAssertEqual(expressionType, .multiplication, "All captured types should be multiplication")
//        }
//    }
//    
//    func test_CategorySelected_AllIndicesInSequence_ShouldHandleCorrectly() {
//        // Given
//        let expectedSequence: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
//        
//        // When
//        for index in 0..<viewModel.numberOfItems {
//            viewModel.categorySelected(at: index)
//        }
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes, expectedSequence, "Should capture all expression types in correct order")
//    }
//    
//    func test_CategorySelected_RandomOrder_ShouldHandleCorrectly() {
//        // Given
//        let randomIndices = [3, 1, 4, 0, 2] // division, subtraction, mixed, addition, multiplication
//        let expectedTypes: [MathExpression.ExpressionType] = [.division, .subtraction, .mixed, .addition, .multiplication]
//        
//        // When
//        for index in randomIndices {
//            viewModel.categorySelected(at: index)
//        }
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes, expectedTypes, "Should capture expression types in selection order")
//    }
//    
//    // MARK: - Boundary Tests
//    
//    func test_CategoryAtIndex_FirstIndex_ShouldReturnCorrectCategory() {
//        // Given
//        let firstIndex = 0
//        
//        // When
//        let category = viewModel.category(at: firstIndex)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "add_icon")
//        XCTAssertEqual(category.categoryName, "addition")
//        XCTAssertEqual(category.expressionType, .addition)
//    }
//    
//    func test_CategoryAtIndex_LastIndex_ShouldReturnCorrectCategory() {
//        // Given
//        let lastIndex = viewModel.numberOfItems - 1
//        
//        // When
//        let category = viewModel.category(at: lastIndex)
//        
//        // Then
//        XCTAssertEqual(category.iconName, "random_icon")
//        XCTAssertEqual(category.categoryName, "mixed")
//        XCTAssertEqual(category.expressionType, .mixed)
//    }
//    
//    func test_CategorySelected_FirstIndex_ShouldWork() {
//        // Given
//        let firstIndex = 0
//        
//        // When
//        viewModel.categorySelected(at: firstIndex)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1)
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .addition)
//    }
//    
//    func test_CategorySelected_LastIndex_ShouldWork() {
//        // Given
//        let lastIndex = viewModel.numberOfItems - 1
//        
//        // When
//        viewModel.categorySelected(at: lastIndex)
//        
//        // Then
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1)
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .mixed)
//    }
//    
//    // MARK: - Memory Management Tests
//    
//    func test_ViewModelDeallocation_ShouldNotCauseCrash() {
//        // Given
//        weak var weakViewModel: CategoryViewModel?
//        var localDelegate: MockCategoryViewModelDelegate?
//        
//        autoreleasepool {
//            let tempViewModel = CategoryViewModel()
//            localDelegate = MockCategoryViewModelDelegate()
//            tempViewModel.delegate = localDelegate
//            weakViewModel = tempViewModel
//            
//            tempViewModel.categorySelected(at: 0)
//        }
//        
//        // When
//        localDelegate = nil
//        
//        // Then
//        XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
//    }
//    
//    func test_DelegateDeallocation_ShouldNotCauseCrash() {
//        // Given
//        weak var weakDelegate: MockCategoryViewModelDelegate?
//        
//        autoreleasepool {
//            let tempDelegate = MockCategoryViewModelDelegate()
//            viewModel.delegate = tempDelegate
//            weakDelegate = tempDelegate
//            
//            viewModel.categorySelected(at: 0)
//        }
//        
//        // When
//        viewModel.delegate = nil
//        
//        // Then
//        XCTAssertNil(weakDelegate, "Delegate should be deallocated")
//    }
//    
//    // MARK: - Performance Tests
//    
//    func test_CategoryAtIndex_PerformanceTest() {
//        // When/Then
//        measure {
//            for _ in 0..<1000 {
//                for index in 0..<viewModel.numberOfItems {
//                    _ = viewModel.category(at: index)
//                }
//            }
//        }
//    }
//    
//    func test_CategorySelected_PerformanceTest() {
//        // When/Then
//        measure {
//            for _ in 0..<1000 {
//                for index in 0..<viewModel.numberOfItems {
//                    viewModel.categorySelected(at: index)
//                }
//            }
//        }
//        
//        // Verify all selections were processed
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5000, "All 5000 selections should be processed")
//    }
//    
//    // MARK: - Thread Safety Tests
//    
//    func test_ConcurrentCategorySelection_ShouldHandleCorrectly() {
//        // Given
//        let concurrentExpectation = XCTestExpectation(description: "Concurrent category selections")
//        concurrentExpectation.expectedFulfillmentCount = 5
//        
//        // When
//        for index in 0..<5 {
//            DispatchQueue.global().async {
//                self.viewModel.categorySelected(at: index)
//                concurrentExpectation.fulfill()
//            }
//        }
//        
//        // Then
//        wait(for: [concurrentExpectation], timeout: 1.0)
//        
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "All concurrent selections should be handled")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 5, "Should capture all expression types")
//    }
//    
//    func test_ConcurrentCategoryAccess_ShouldHandleCorrectly() {
//        // Given
//        let concurrentExpectation = XCTestExpectation(description: "Concurrent category access")
//        concurrentExpectation.expectedFulfillmentCount = 10
//        
//        var capturedCategories: [CategoryModel] = []
//        let lock = NSLock()
//        
//        // When
//        for index in 0..<10 {
//            DispatchQueue.global().async {
//                let category = self.viewModel.category(at: index % self.viewModel.numberOfItems)
//                
//                lock.lock()
//                capturedCategories.append(category)
//                lock.unlock()
//                
//                concurrentExpectation.fulfill()
//            }
//        }
//        
//        // Then
//        wait(for: [concurrentExpectation], timeout: 1.0)
//        
//        XCTAssertEqual(capturedCategories.count, 10, "All concurrent accesses should return categories")
//    }
//    
//    // MARK: - State Consistency Tests
//    
//    func test_CategoryData_ShouldBeConsistentAcrossMultipleAccesses() {
//        // Given
//        let index = 2 // multiplication
//        
//        // When
//        let firstAccess = viewModel.category(at: index)
//        let secondAccess = viewModel.category(at: index)
//        let thirdAccess = viewModel.category(at: index)
//        
//        // Then
//        XCTAssertEqual(firstAccess.iconName, secondAccess.iconName, "Icon name should be consistent")
//        XCTAssertEqual(firstAccess.categoryName, secondAccess.categoryName, "Category name should be consistent")
//        XCTAssertEqual(firstAccess.expressionType, secondAccess.expressionType, "Expression type should be consistent")
//        
//        XCTAssertEqual(secondAccess.iconName, thirdAccess.iconName, "Icon name should be consistent")
//        XCTAssertEqual(secondAccess.categoryName, thirdAccess.categoryName, "Category name should be consistent")
//        XCTAssertEqual(secondAccess.expressionType, thirdAccess.expressionType, "Expression type should be consistent")
//    }
//    
//    func test_NumberOfItems_ShouldBeConsistentAcrossMultipleAccesses() {
//        // When
//        let firstAccess = viewModel.numberOfItems
//        let secondAccess = viewModel.numberOfItems
//        let thirdAccess = viewModel.numberOfItems
//        
//        // Then
//        XCTAssertEqual(firstAccess, 5, "Number of items should be 5")
//        XCTAssertEqual(secondAccess, 5, "Number of items should be consistent")
//        XCTAssertEqual(thirdAccess, 5, "Number of items should be consistent")
//        XCTAssertEqual(firstAccess, secondAccess, "Number of items should be consistent between accesses")
//        XCTAssertEqual(secondAccess, thirdAccess, "Number of items should be consistent between accesses")
//    }
//    
//    // MARK: - Integration Tests
//    
//    func test_CompleteWorkflow_ShouldWorkCorrectly() {
//        // Given
//        let testScenarios = [
//            (index: 0, expectedType: MathExpression.ExpressionType.addition),
//            (index: 1, expectedType: MathExpression.ExpressionType.subtraction),
//            (index: 2, expectedType: MathExpression.ExpressionType.multiplication),
//            (index: 3, expectedType: MathExpression.ExpressionType.division),
//            (index: 4, expectedType: MathExpression.ExpressionType.mixed)
//        ]
//        
//        // When/Then
//        for (scenarioIndex, scenario) in testScenarios.enumerated() {
//            // Get category data
//            let category = viewModel.category(at: scenario.index)
//            
//            // Verify category data
//            XCTAssertNotNil(category.iconName, "Icon name should not be nil for index \(scenario.index)")
//            XCTAssertNotNil(category.categoryName, "Category name should not be nil for index \(scenario.index)")
//            XCTAssertEqual(category.expressionType, scenario.expectedType, "Expression type should match for index \(scenario.index)")
//            
//            // Select category
//            viewModel.categorySelected(at: scenario.index)
//            
//            // Verify selection
//            XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, scenarioIndex + 1, "Navigation should be called for selection \(scenarioIndex + 1)")
//            XCTAssertEqual(mockDelegate.capturedExpressionTypes.last, scenario.expectedType, "Last captured type should match for index \(scenario.index)")
//        }
//        
//        // Final verification
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, testScenarios.count, "Total navigation calls should match scenario count")
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, testScenarios.count, "Total captured types should match scenario count")
//    }
//}
//
//// MARK: - Test Extensions
//
//extension CategoryViewModelTests {
//    
//    /// Helper method to verify category data
//    private func verifyCategoryData(
//        _ category: CategoryModel,
//        expectedIconName: String,
//        expectedCategoryName: String,
//        expectedExpressionType: MathExpression.ExpressionType,
//        at index: Int,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertEqual(category.iconName, expectedIconName, "Icon name mismatch at index \(index)", file: file, line: line)
//        XCTAssertEqual(category.categoryName, expectedCategoryName, "Category name mismatch at index \(index)", file: file, line: line)
//        XCTAssertEqual(category.expressionType, expectedExpressionType, "Expression type mismatch at index \(index)", file: file, line: line)
//    }
//    
//    /// Helper method to verify delegate call counts
//    private func verifyDelegateCallCounts(
//        expectedNavigationCount: Int,
//        expectedCapturedTypesCount: Int,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, expectedNavigationCount, "Navigation call count mismatch", file: file, line: line)
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, expectedCapturedTypesCount, "Captured types count mismatch", file: file, line: line)
//    }
//    
//    /// Helper method to test category selection with expected type
//    private func testCategorySelection(
//        at index: Int,
//        expectedType: MathExpression.ExpressionType,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        // Reset delegate state
//        mockDelegate.navigateToGameVCCallCount = 0
//        mockDelegate.capturedExpressionTypes.removeAll()
//        
//        // Perform selection
//        viewModel.categorySelected(at: index)
//        
//        // Verify results
//        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Navigation should be called exactly once for index \(index)", file: file, line: line)
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 1, "Should capture exactly one type for index \(index)", file: file, line: line)
//        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, expectedType, "Should capture correct type for index \(index)", file: file, line: line)
//    }
//}
//
//// MARK: - CategoryModel Tests
//
//extension CategoryViewModelTests {
//    
//    /// Test CategoryModel initialization and properties
//    func test_CategoryModel_Initialization() {
//        // Given
//        let iconName = "test_icon"
//        let categoryName = "test_category"
//        let expressionType = MathExpression.ExpressionType.addition
//        
//        // When
//        let categoryModel = CategoryModel(
//            iconName: iconName,
//            categoryName: categoryName,
//            expressionType: expressionType
//        )
//        
//        // Then
//        XCTAssertEqual(categoryModel.iconName, iconName, "Icon name should be set correctly")
//        XCTAssertEqual(categoryModel.categoryName, categoryName, "Category name should be set correctly")
//        XCTAssertEqual(categoryModel.expressionType, expressionType, "Expression type should be set correctly")
//    }
//    
//    /// Test CategoryModel with different expression types
//    func test_CategoryModel_WithDifferentExpressionTypes() {
//        // Given
//        let expressionTypes: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
//        
//        // When/Then
//        for (index, expressionType) in expressionTypes.enumerated() {
//            let categoryModel = CategoryModel(
//                iconName: "icon_\(index)",
//                categoryName: "category_\(index)",
//                expressionType: expressionType
//            )
//            
//            XCTAssertEqual(categoryModel.expressionType, expressionType, "Expression type should match for index \(index)")
//        }
//    }
//}
//
//// MARK: - CategoryModel Test Helpers
//
//extension CategoryModel {
//    /// Creates a test category model with default or custom values
//    static func makeTestCategory(
//        iconName: String = "test_icon",
//        categoryName: String = "test_category",
//        expressionType: MathExpression.ExpressionType = .addition
//    ) -> CategoryModel {
//        return CategoryModel(
//            iconName: iconName,
//            categoryName: categoryName,
//            expressionType: expressionType
//        )
//    }
//    
//    /// Creates all available categories for testing
//    static func makeAllCategories() -> [CategoryModel] {
//        return [
//            CategoryModel(iconName: "add_icon", categoryName: "addition", expressionType: .addition),
//            CategoryModel(iconName: "minus_icon", categoryName: "subtraction", expressionType: .subtraction),
//            CategoryModel(iconName: "multiply_icon", categoryName: "multiplication", expressionType: .multiplication),
//            CategoryModel(iconName: "divide_icon", categoryName: "division", expressionType: .division),
//            CategoryModel(iconName: "random_icon", categoryName: "mixed", expressionType: .mixed)
//        ]
//    }
//}
