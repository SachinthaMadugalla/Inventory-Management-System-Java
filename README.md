InventoryManagementSystem/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/inventory/
│       │       │
│       │       ├── model/                        # All entity/data classes
│       │       │   ├── Item.java
│       │       │   ├── Sale.java
│       │       │   ├── User.java
│       │       │   ├── Admin.java
│       │       │   └── Report.java
│       │       │
│       │       ├── util/                         # Utility & helper classes
│       │       │   ├── FileHandler.java
│       │       │   ├── Stack.java
│       │       │   └── MergeSort.java
│       │       │
│       │       ├── servlet/                      # All JSP Servlets (Backend)
│       │       │   │
│       │       │   ├── inventory/                # Component 01
│       │       │   │   ├── AddStockServlet.java
│       │       │   │   ├── ViewInventoryServlet.java
│       │       │   │   ├── SellStockServlet.java
│       │       │   │   ├── SearchItemServlet.java
│       │       │   │   ├── UpdateItemServlet.java
│       │       │   │   └── DeleteItemServlet.java
│       │       │   │
│       │       │   ├── expiry/                   # Component 02
│       │       │   │   ├── SortByExpiryServlet.java
│       │       │   │   ├── ExpiredItemsServlet.java
│       │       │   │   └── SortedInventoryServlet.java
│       │       │   │
│       │       │   ├── sales/                    # Component 03
│       │       │   │   ├── SalesEntryServlet.java
│       │       │   │   ├── SalesHistoryServlet.java
│       │       │   │   └── EditTransactionServlet.java
│       │       │   │
│       │       │   ├── user/                     # Component 04
│       │       │   │   ├── RegisterServlet.java
│       │       │   │   ├── LoginServlet.java
│       │       │   │   ├── LogoutServlet.java
│       │       │   │   └── AdminDashboardServlet.java
│       │       │   │
│       │       │   └── report/                   # Component 05
│       │       │       ├── StockReportServlet.java
│       │       │       ├── LowStockAlertServlet.java
│       │       │       └── InventorySummaryServlet.java
│       │       │
│       │       └── service/                      # Business logic layer
│       │           ├── InventoryService.java
│       │           ├── ExpiryService.java
│       │           ├── SalesService.java
│       │           ├── UserService.java
│       │           └── ReportService.java
│       │
│       └── webapp/
│           │
│           ├── WEB-INF/
│           │   └── web.xml                       # Servlet mappings
│           │
│           ├── views/                            # All JSP UI pages
│           │   │
│           │   ├── inventory/                    # Component 01 UI
│           │   │   ├── addStock.jsp
│           │   │   ├── viewInventory.jsp
│           │   │   ├── sellStock.jsp
│           │   │   ├── searchItem.jsp
│           │   │   ├── updateItem.jsp
│           │   │   └── deleteItem.jsp
│           │   │
│           │   ├── expiry/                       # Component 02 UI
│           │   │   ├── sortByExpiry.jsp
│           │   │   ├── expiredItems.jsp
│           │   │   └── sortedInventory.jsp
│           │   │
│           │   ├── sales/                        # Component 03 UI
│           │   │   ├── salesEntry.jsp
│           │   │   ├── salesHistory.jsp
│           │   │   └── editTransaction.jsp
│           │   │
│           │   ├── user/                         # Component 04 UI
│           │   │   ├── login.jsp
│           │   │   ├── register.jsp
│           │   │   └── adminDashboard.jsp
│           │   │
│           │   └── report/                       # Component 05 UI
│           │       ├── stockReport.jsp
│           │       ├── lowStockAlert.jsp
│           │       └── inventorySummary.jsp
│           │
│           ├── static/
│           │   ├── css/
│           │   │   └── style.css
│           │   ├── js/
│           │   │   └── main.js
│           │   └── images/
│           │
│           └── index.jsp                         # Landing / Home page
│
├── data/                                         # File storage (txt files)
│   ├── items.txt
│   ├── sales.txt
│   ├── users.txt
│   └── reports.txt
│
├── pom.xml                                       # Maven dependencies
└── README.md                                     # Project documentation
