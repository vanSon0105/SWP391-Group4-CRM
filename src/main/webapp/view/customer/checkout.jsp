<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Checkout</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
                <style>
                    .checkout-grid {
                        display: grid;
                        gap: 24px;
                        max-width: 1100px;
                        margin: 0 auto;
                        padding: 32px 16px;
                    }

                    .panel {
                        background: rgba(255, 255, 255, 0.97);
                        border-radius: 16px;
                        padding: 24px;
                        box-shadow: 0 14px 35px rgba(15, 23, 42, 0.1);
                    }

                    .summary {
                        background: #0f172a;
                        color: #fff;
                        border-radius: 16px;
                        padding: 24px;
                        box-shadow: 0 14px 45px rgba(15, 23, 42, 0.35);
                    }

                    .summary ul {
                        list-style: none;
                        padding: 0;
                        margin: 0 0 16px;
                        display: grid;
                        gap: 10px;
                    }

                    .summary-line,
                    .summary-total {
                        display: flex;
                        justify-content: space-between;
                        margin-top: 8px;
                        font-size: 15px;
                    }

                    .summary-total {
                        font-size: 18px;
                        font-weight: 600;
                        padding-top: 12px;
                        border-top: 1px solid rgba(255, 255, 255, 0.16);
                    }

                    .cta {
                        display: flex;
                        gap: 12px;
                        margin-top: 16px;
                    }

                    .cta-btn {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        padding: 12px 20px;
                        border-radius: 10px;
                        background: linear-gradient(120deg, #2563eb, #22d3ee);
                        color: #fff;
                        font-weight: 600;
                        text-decoration: none;
                        border: none;
                        cursor: pointer;
                    }

                    .cta-btn.secondary {
                        background: rgba(255, 255, 255, 0.14);
                        color: #0f172a;
                        border: 1px solid rgba(15, 23, 42, 0.08);
                    }

                    .alert-error {
                        background: #fee2e2;
                        color: #b91c1c;
                        padding: 12px 16px;
                        border-radius: 8px;
                        margin-bottom: 16px;
                    }

                    .form-block {
                        display: grid;
                        gap: 8px;
                        margin-bottom: 14px;
                    }

                    .form-block input,
                    .form-block textarea,
                    .form-block select {
                        border: 1px solid #cbd5f5;
                        border-radius: 8px;
                        padding: 10px 12px;
                        font-size: 15px;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 80px 16px;
                    }
                </style>
            </head>

            <body class="shop-page checkout-page">
                <jsp:include page="../common/header.jsp" />
                <main>
                    <c:choose>
                        <c:when test="${empty listCart}">
                            <section class="empty-state">
                                <h2>Your cart is empty</h2>
                                <p>Add items to your cart before proceeding to checkout.</p>
                                <a class="cta-btn" href="device-page">Continue
                                    shopping</a>
                            </section>
                        </c:when>
                        <c:otherwise>
                            <section class="checkout-grid">
                                <form class="panel" action="checkout" method="post">
                                    <h2>Shipping information</h2>
                                    <c:if test="${not empty error}">
                                        <div class="alert-error">${error}</div>
                                    </c:if>
                                    <div class="form-block">
                                        <label for="fullname">Full name *</label>
                                        <input id="fullname" name="fullname" type="text"
                                            value="${param.fullname != null ? param.fullname : formInfo.fullName}"
                                            required>
                                    </div>
                                    <div class="form-block">
                                        <label for="phone">Phone number *</label>
                                        <input id="phone" name="phone" type="text"
                                            value="${param.phone != null ? param.phone : formInfo.phone}" required>
                                    </div>
                                    <div class="form-block">
                                        <label for="address">Address *</label>
                                        <textarea id="address" name="address"
                                            required>${param.address != null ? param.address : formInfo.address}</textarea>
                                    </div>
                                    <div class="form-block">
                                        <label for="time">Delivery time *</label>
                                        <select id="time" name="time" required>
                                            <option value="">-- Select --</option>
                                            <option value="working_hours" ${param.time=='working_hours' ||
                                                formInfo.deliveryTime=='working_hours' ? 'selected' : '' }>Business
                                                hours</option>
                                            <option value="evening" ${param.time=='evening' ||
                                                formInfo.deliveryTime=='evening' ? 'selected' : '' }>Evening (18:00 -
                                                21:00)</option>
                                            <option value="weekend" ${param.time=='weekend' ||
                                                formInfo.deliveryTime=='weekend' ? 'selected' : '' }>Weekend</option>
                                        </select>
                                    </div>
                                    <div class="form-block">
                                        <label for="method">Payment method *</label>
                                        <select id="method" name="method" required>
                                            <option value="">-- Select --</option>
                                            <option value="credit_card" ${param.method=='credit_card' ||
                                                formInfo.paymentMethod=='credit_card' ? 'selected' : '' }>Credit card
                                            </option>
                                            <option value="bank_transfer" ${param.method=='bank_transfer' ||
                                                formInfo.paymentMethod=='bank_transfer' ? 'selected' : '' }>Bank
                                                transfer</option>
                                            <option value="e_wallet" ${param.method=='e_wallet' ||
                                                formInfo.paymentMethod=='e_wallet' ? 'selected' : '' }>E-wallet</option>
                                            <option value="cash_on_delivery" ${param.method=='cash_on_delivery' ||
                                                formInfo.paymentMethod=='cash_on_delivery' ? 'selected' : '' }>Cash on
                                                delivery</option>
                                        </select>
                                    </div>
                                    <div class="form-block">
                                        <label for="note">Additional note</label>
                                        <textarea id="note"
                                            name="note">${param.note != null ? param.note : formInfo.note}</textarea>
                                    </div>
                                    <div class="cta">
                                        <button type="submit" class="cta-btn">Confirm order</button>
                                        <a href="cart" class="cta-btn secondary">Back
                                            to cart</a>
                                    </div>
                                </form>

                                <section class="summary">
                                    <h2>Order summary</h2>
                                    <ul class="cart-items">
                                        <c:forEach var="item" items="${listCart}">
                                            <li>
                                                <span>${item.device.name} x ${item.quantity}</span>
                                                <strong>
                                                    <fmt:formatNumber value=""
                                                        type="number" /> VND
                                                </strong>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                    <div class="summary-line">
                                        <span>Subtotal</span>
                                        <strong>
                                            <fmt:formatNumber value="" type="number" /> VND
                                        </strong>
                                    </div>
                                    <div class="summary-line">
                                        <span>Discount</span>
                                        <strong>-
                                            ${sessionScope.discount}
                                        </strong>
                                    </div>
                                    <div class="summary-line">
                                        <span>Shipping</span>
                                        <strong>0 VND</strong>
                                    </div>
                                    <div class="summary-total">
                                        <span>Total</span>
                                        <strong>
                                            ${finalPrice}
                                        </strong>
                                    </div>
                                </section>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </main>
                <jsp:include page="../common/footer.jsp" />
            </body>

            </html>