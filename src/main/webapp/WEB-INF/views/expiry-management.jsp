<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Expiry Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>Expiry Dashboard</h2>

    <!-- Expired and Expiring Soon Tables -->
    <div class="row">
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header bg-danger text-white">
                    <h5>Expired Items</h5>
                </div>
                <div class="card-body">
                    <table class="table table-sm">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Expiry Date</th>
                            <th>Qty</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${expired}">
                            <tr>
                                <td>${item.name}</td>
                                <td>${item.expiryDate}</td>
                                <td>${item.quantity}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/expiryManagement" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="markDisposed">
                                        <input type="hidden" name="itemIdToDispose" value="${item.id}">
                                        <button type="submit" class="btn btn-sm btn-warning">Dispose</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-header bg-warning">
                    <h5>Items Expiring Soon (30 Days)</h5>
                </div>
                <div class="card-body">
                    <table class="table table-sm">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Expiry Date</th>
                            <th>Qty</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${expiringSoon}">
                            <tr>
                                <td>${item.name}</td>
                                <td>${item.expiryDate}</td>
                                <td>${item.quantity}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Expiry CRUD Section -->
    <h3 class="mt-4">Manage Expiry Records</h3>
    <div class="card mb-4">
        <div class="card-header">
            <h5 id="form-title">Add New Expiry Record</h5>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/expiryManagement" method="post">
                <input type="hidden" name="action" id="form-action" value="add">
                <input type="hidden" name="id" id="expiry-id">

                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label for="itemId">Item ID</label>
                        <input type="text" class="form-control" id="itemId" name="itemId" required>
                    </div>
                    <div class="form-group col-md-4">
                        <label for="expiryDate">Expiry Date</label>
                        <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
                    </div>
                    <div class="form-group col-md-4 align-self-center">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="disposed" name="disposed">
                            <label class="form-check-label" for="disposed">Is Disposed?</label>
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Save Record</button>
                <button type="button" class="btn btn-secondary" onclick="resetForm()">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Expiry Records Table -->
    <div class="card">
        <div class="card-header">
            <h5>All Expiry Records</h5>
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead class="thead-light">
                <tr>
                    <th>Record ID</th>
                    <th>Item ID</th>
                    <th>Expiry Date</th>
                    <th>Disposed</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${expiryItems}">
                    <tr>
                        <td>${item.id}</td>
                        <td>${item.itemId}</td>
                        <td>${item.expiryDate}</td>
                        <td>${item.disposed}</td>
                        <td>
                            <button class="btn btn-sm btn-info" onclick="editItem('${item.id}', '${item.itemId}', '${item.expiryDate}', ${item.disposed})">Edit</button>
                            <form action="${pageContext.request.contextPath}/expiryManagement" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${item.id}">
                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function editItem(id, itemId, expiryDate, disposed) {
        document.getElementById('form-title').innerText = 'Edit Expiry Record';
        document.getElementById('form-action').value = 'update';
        document.getElementById('expiry-id').value = id;
        document.getElementById('itemId').value = itemId;
        document.getElementById('expiryDate').value = expiryDate;
        document.getElementById('disposed').checked = disposed;
        window.scrollTo(0, 0);
    }

    function resetForm() {
        document.getElementById('form-title').innerText = 'Add New Expiry Record';
        document.getElementById('form-action').value = 'add';
        document.getElementById('expiry-id').value = '';
        document.getElementById('itemId').value = '';
        document.getElementById('expiryDate').value = '';
        document.getElementById('disposed').checked = false;
    }
</script>

</body>
</html>