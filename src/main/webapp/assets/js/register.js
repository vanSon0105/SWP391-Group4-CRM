//validate
const form = document.getElementById('registerForm');
const fields = ['name', 'username', 'email', 'phone', 'password', 'role'];

const validators = {
    name: value => value.trim().length >= 3 || 'Họ tên phải có ít nhất 3 ký tự',
    username: value => /^[a-zA-Z0-9_]{4,}$/.test(value) || 'Tên người dùng phải ≥ 4 ký tự và không có ký tự đặc biệt',
    email: value => /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(value) || 'Email không hợp lệ',
    phone: value => /^(0[0-9]{9})$/.test(value) || 'Số điện thoại phải có 10 chữ số và bắt đầu bằng 0',
    password: value => value.length >= 6 || 'Mật khẩu phải có ít nhất 6 ký tự',
    role: value => value.trim() !== '' || 'Vui lòng chọn mục đích sử dụng'
};

fields.forEach(id => {
    const input = document.getElementById(id);
    const errorEl = input.parentElement.querySelector('.error');

    const validate = () => {
        const result = validators[id](input.value);
        if (result !== true) {
            input.classList.add('error');
            errorEl.textContent = result;
            return false;
        } else {
            input.classList.remove('error');
            errorEl.textContent = '';
            return true;
        }
    };

    input.addEventListener('input', validate);
    input.addEventListener('blur', validate);
});

form.addEventListener('submit', (e) => {
    let valid = true;
    fields.forEach(id => {
        const input = document.getElementById(id);
        const result = validators[id](input.value);
        if (result !== true) {
            valid = false;
            input.classList.add('error');
            input.parentElement.querySelector('.error').textContent = result;
        }
    });
    if (!valid) e.preventDefault();
});

//check trung username / email
function checkDuplicate(type, value, input) {
    const errorEl = input.parentElement.querySelector('.error');
    if (value.trim() === '') return;

    const basePath = window.location.origin + window.location.pathname.replace(/\/[^/]+$/, '');
    fetch(`${basePath}/checkUser?${type}=${encodeURIComponent(value)}`)
        .then(res => res.json())
        .then(data => {
            if (data.exists) {
                input.classList.add('error');
                errorEl.textContent = (type === 'username')
                    ? 'Tên người dùng đã tồn tại'
                    : 'Email đã tồn tại';
            } else {
                input.classList.remove('error');
                errorEl.textContent = '';
            }
        })
        .catch(() => console.error("Lỗi khi gọi API kiểm tra " + type));
}

document.getElementById("username").addEventListener("input", function() {
    if (this.value.length >= 4) checkDuplicate("username", this.value, this);
});

document.getElementById("email").addEventListener("input", function() {
    if (this.value.includes("@")) checkDuplicate("email", this.value, this);
});
