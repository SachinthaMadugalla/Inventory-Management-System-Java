InventoryManagementSystem/
│
├── data/                                          # File-based storage (txt files)
│   ├── items.txt                                  # C01 - Inventory data
│   ├── sales.txt                                  # C03 - Sales transactions
│   ├── users.txt                                  # C04 - User & Admin accounts
│   └── reports.txt                                # C05 - Generated reports
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/inventory/
│       │       │
│       │       ├── model/                         # Entity / data classes
│       │       │   ├── Item.java                  # C01 + C02
│       │       │   ├── Sale.java                  # C03
│       │       │   ├── User.java                  # C04 ← YOU
│       │       │   ├── Admin.java                 # C04 ← YOU  (extends User)
│       │       │   ├── Report.java                # C05
│       │       │   └── Expiry.java                # C02
│       │       │
│       │       ├── service/                       # Business logic layer
│       │       │   ├── InventoryService.java      # C01
│       │       │   ├── ExpiryService.java         # C02
│       │       │   ├── SalesService.java          # C03
│       │       │   ├── UserService.java           # C04 ← YOU
│       │       │   ├── ReportService.java         # C05
│       │       │   └── EmailService.java          # Shared (OTP password reset)
│       │       │
│       │       ├── servlet/                       # JSP Servlets (backend controllers)
│       │       │   │
│       │       │   ├── AddStockServlet.java       # C01 - Add new stock item
│       │       │   ├── ViewInventoryServlet.java  # C01 - View all inventory
│       │       │   ├── EditStockServlet.java      # C01 - Edit stock item
│       │       │   ├── DeleteStockServlet.java    # C01 - Delete stock item
│       │       │   ├── DisposeItemServlet.java    # C01 - Dispose expired/damaged item
│       │       │   │
│       │       │   ├── ExpiryServlet.java         # C02 - Expiry management & sorting
│       │       │   │
│       │       │   ├── SalesServlet.java          # C03 - Record new sale
│       │       │   ├── ViewSalesServlet.java      # C03 - View sales history
│       │       │   ├── EditTransactionServlet.java# C03 - Edit a transaction
│       │       │   ├── DeleteSaleServlet.java     # C03 - Delete a transaction
│       │       │   │
│       │       │   ├── LoginServlet.java          # C04 ← YOU - Authenticate user
│       │       │   ├── RegisterServlet.java       # C04 ← YOU - Register new account
│       │       │   ├── LogoutServlet.java         # C04 ← YOU - Invalidate session
│       │       │   ├── UserManagementServlet.java # C04 ← YOU - View all users (admin)
│       │       │   ├── DeleteUserServlet.java     # C04 ← YOU - Delete a user (admin)
│       │       │   ├── EditProfileServlet.java    # C04 ← YOU - Update own profile
│       │       │   ├── ForgotPasswordServlet.java # C04 ← YOU - OTP password reset
│       │       │   │
│       │       │   ├── ReportServlet.java         # C05 - Generate reports
│       │       │   ├── DeleteReportServlet.java   # C05 - Delete a report
│       │       │   │
│       │       │   └── DashboardServlet.java      # Shared - Admin dashboard
│       │       │
│       │       └── util/                          # Utility & helper classes
│       │           ├── FileHandler.java           # Shared - Read/write all .txt files
│       │           ├── FilePath.java              # Shared - Resolve file paths
│       │           ├── Stack.java                 # C01 - LIFO data structure
│       │           └── MergeSort.java             # C02 - Sort items by expiry date
│       │
│       └── webapp/
│           │
│           ├── views/                             # JSP UI pages
│           │   ├── common/
│           │   │   └── sidebar.jsp               # Shared - Navigation sidebar
│           │   │
│           │   ├── inventory/                     # C01 UI
│           │   │   ├── addStock.jsp
│           │   │   ├── viewInventory.jsp
│           │   │   └── editStock.jsp
│           │   │
│           │   ├── expiry/                        # C02 UI
│           │   │   ├── expiryManagement.jsp
│           │   │   ├── expiredItems.jsp
│           │   │   └── sortedInventory.jsp
│           │   │
│           │   ├── sales/                         # C03 UI
│           │   │   ├── addSale.jsp
│           │   │   ├── viewSales.jsp
│           │   │   └── editTransaction.jsp
│           │   │
│           │   ├── user/                          # C04 UI
│           │   │   ├── login.jsp                  # C04
│           │   │   ├── register.jsp               # C04
│           │   │   ├── userManagement.jsp         # C04
│           │   │   ├── editProfile.jsp            # C04
│           │   │   └── forgotPassword.jsp         # C04
│           │   │
│           │   └── report/                        # C05 UI
│           │       └── viewReport.jsp
│           │
│           ├── WEB-INF/
│           │   └── web.xml                        # Servlet URL mappings
│           │
│           ├── dashboard.jsp                      # Admin dashboard view
│           └── index.jsp                          # Landing / home page
│
├── pom.xml                                        # Maven dependencies
└── README.md                                      # Project documentation


========================================================
 COMPONENT SUMMARY
========================================================

  C01  Inventory Core          Item.java, InventoryService.java
                               AddStock / ViewInventory / EditStock / DeleteStock / DisposeItem
                               Data structure: Stack (LIFO)

  C02  Expiry Management       Expiry.java, ExpiryService.java
                               ExpiryServlet
                               Algorithm: MergeSort (sort by expiry date)

  C03  Sales & Transactions    Sale.java, SalesService.java
                               Sales / ViewSales / EditTransaction / DeleteSale

  C04  User & Admin Mgmt       User.java, Admin.java, UserService.java
       (your component)        Login / Register / Logout / UserManagement
                               DeleteUser / EditProfile / ForgotPassword
                               Storage: users.txt
                               OOP: Encapsulation, Inheritance, Abstraction

  C05  Reporting               Report.java, ReportService.java
                               ReportServlet / DeleteReport

  Shared                       FileHandler.java, FilePath.java
                               EmailService.java, DashboardServlet.java
                               sidebar.jsp, dashboard.jsp, index.jsp
