import XCTest
@testable import SharedTab

final class CalculationTest: XCTestCase {

    var balanceManager: BalanceManager!
    var groupId: String!
    var logView: LogView!

    override func setUp() {
        super.setUp()
        
        groupId = "TEST"
        balanceManager = BalanceManager(groupId: groupId)
        
        balanceManager.graph = [
            "A": ["B": 50.0, "C": 25.0],
            "B": ["A": 50.0],
            "C": ["A": 25.0]
        ]
        
        balanceManager.owedStatements = [
            OweStatement(debtor: "A", creditor: "B", amount: 50.0, currencyCode: "USD"),
            OweStatement(debtor: "A", creditor: "C", amount: 25.0, currencyCode: "USD"),
            OweStatement(debtor: "B", creditor: "A", amount: 50.0, currencyCode: "USD"),
            OweStatement(debtor: "C", creditor: "A", amount: 25.0, currencyCode: "USD")
        ]
        logView = LogView(balanceManager: balanceManager, friendManager: FriendManager(groupId: "TEST"), transactions: .constant([]))
    }


    // Test Case 1: Owe statements cannot be negative
    func testOweStatementsCannotBeNegative() {
        // Arrange
        balanceManager.updateBalancesAddedTransaction(with: ["B": -50.0], payer: "A")
        
        // Assert
        XCTAssertTrue(balanceManager.graph["A"]?["B"] ?? 0.0 >= 0)
    }

    // Test Case 2: Net Balances
    func testNetBalances() {
        // Arrange
        let expenses: [String: Double] = ["B": 50.0, "C": 25.0]
        let payer = "A"
        
        // Act
        balanceManager.updateBalancesAddedTransaction(with: expenses, payer: payer)
        
        // Assert
        XCTAssertEqual(balanceManager.graph["A"]?["B"], 50.0)
        XCTAssertEqual(balanceManager.graph["A"]?["C"], 25.0)
    }
}
