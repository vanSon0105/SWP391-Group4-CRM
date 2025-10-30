<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập TechShop</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shop.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
	integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	
	<style>
        .login-alert {
            position: fixed;
            inset: 0;
            display: none;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.35);
            z-index: 9999;
            padding: 16px;
        }

        .login-alert.show {
            display: flex;
        }

        .login-alert__box {
            position: relative;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 22px 45px rgba(15, 23, 42, 0.24);
            padding: 28px 32px;
            max-width: 360px;
            width: 100%;
            text-align: center;
        }

        .login-alert__icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .login-alert__message {
            color: #0f172a;
            font-size: 1.3rem;
            line-height: 1.5;
            margin-bottom: 18px;
        }

        .login-alert__close {
            position: absolute;
            top: -5px;
            right: 10px;
            background: transparent;
            border: none;
            font-size: 3rem;
            cursor: pointer;
            color: #475569;
            transition: color 0.2s ease;
        }

        .login-alert__close:hover {
            color: #0f172a;
        }

        .login-alert.info .login-alert__icon {
            background: rgba(59, 130, 246, 0.15);
            color: #1d4ed8;
        }

        .login-alert.error .login-alert__icon {
            background: rgba(220, 38, 38, 0.15);
            color: #b91c1c;
        }
    </style>
</head>
<body class="shop-page login-page">
<jsp:include page="../common/header.jsp"></jsp:include>
<div id="login-alert"
     class="login-alert"
     role="alertdialog"
     aria-modal="true"
     aria-live="assertive"
     data-message="${fn:escapeXml(loginAlertMessage)}"
     data-type="${fn:escapeXml(loginAlertType)}">
    <div class="login-alert__box">
        <button type="button" class="login-alert__close" data-close aria-label="Close alert">&times;</button>
        <div class="login-alert__icon" aria-hidden="true"></div>
        <p class="login-alert__message"></p>
    </div>
</div>
    <section class="card" style="margin: auto 0;">
        <h1>Đăng nhập TechShop</h1>
        <p>Truy cập đơn hàng, bảo hành, lịch sửa chữa và ưu đãi dành riêng cho bạn.</p>
        <c:if test="${sessionScope.mss != null}">
		    <p style="color:green;">${sessionScope.mss}</p>
		</c:if>
        
        <form action="login" method="post">
            <div style="display:grid; gap:10px; text-align:left;">
                <label for="email">Email</label>
                <input id="email" name="email" type="text" placeholder="Nhập email" required>
            </div>

            <div style="display:grid; gap:10px; text-align:left;">
                <label for="password">Mật khẩu</label>
                <input id="password" name="password" type="password" placeholder="Nhập mật khẩu" required>
            </div>

            <div class="links">
                 <a href="forgot-password">Quên mật khẩu?</a>
    			<a href="register">Đăng ký tài khoản</a>
            </div>

            <button type="submit">Đăng nhập</button>
        </form>
        <p class="register">Chưa có tài khoản? <a href="register">Tạo tài khoản ngay</a></p>
    </section>
    
    <script>

(function () {

    const alertContainer = document.getElementById('login-alert');

    if (!alertContainer) return;



    const message = alertContainer.dataset.message;

    if (!message) return;



    const type = alertContainer.dataset.type || 'info';

    const messageEl = alertContainer.querySelector('.login-alert__message');

    const iconEl = alertContainer.querySelector('.login-alert__icon');

    const closeBtn = alertContainer.querySelector('[data-close]');



    const hideAlert = () => {

        alertContainer.classList.remove('show', 'error', 'info');

        alertContainer.removeAttribute('data-message');

    };



    messageEl.textContent = message;

    alertContainer.classList.add('show', type);

    iconEl.textContent = type === 'error' ? '!' : 'i';



    closeBtn.addEventListener('click', hideAlert);

    alertContainer.addEventListener('click', (event) => {

        if (event.target === alertContainer) {

            hideAlert();

        }

    });
    
    setTimeout(hideAlert, 5000);

})();

</script>
</body>
</html>
