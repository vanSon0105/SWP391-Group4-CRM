// Banner promos
(function () {
    var slider = document.querySelector('[data-hero-slider]');
    if (!slider) return;

    var track = slider.querySelector('.banner-promos-track');
    var cards = Array.from(track.children);
    if (!cards.length) return;

    var prevBtn = slider.querySelector('[data-hero-direction="prev"]');
    var nextBtn = slider.querySelector('[data-hero-direction="next"]');
    var dots = [];
    var currentIndex = 0;
    var gap = parseFloat(getComputedStyle(track).gap) || 0;
    var timer = null;
    var delay = 2000;

    function getVisibleCount() {
        return window.innerWidth >= 1100 ? 2 : 1;
    }

    function maxIndex() {
        return Math.max(cards.length - getVisibleCount(), 0);
    }

    function clamp(index) {
        var max = maxIndex();
        if (index < 0) return max;
        if (index > max) return 0;
        return index;
    }

    function updateDots() {
        if (!dots.length) return;
        dots.forEach(function (dot, i) {
            dot.classList.toggle('active', i === currentIndex);
            dot.disabled = i === currentIndex;
        });
    }

    function updateSlider() {
        var cardWidth = cards[0].getBoundingClientRect().width;
        var offset = currentIndex * (cardWidth + gap);
        track.style.transform = 'translateX(-' + offset + 'px)';
        updateDots();
    }

    function stop() {
        if (timer) {
            clearInterval(timer);
            timer = null;
        }
    }

    function start() {
        stop();
        if (maxIndex() <= 0) return;
        timer = setInterval(function () {
            currentIndex = clamp(currentIndex + 1);
            updateSlider();
        }, delay);
    }


    if (prevBtn) {
        prevBtn.addEventListener('click', function () {
            currentIndex = clamp(currentIndex - 1);
            updateSlider();
            start();
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', function () {
            currentIndex = clamp(currentIndex + 1);
            updateSlider();
            start();
        });
    }
    updateSlider();
})();


(function () {
    var menu = document.querySelector('[data-category-menu]');
    if (!menu) return;

    var toggleBtn = menu.querySelector('[data-category-toggle]');
    var panel = menu.querySelector('[data-category-panel]');
    if (!toggleBtn || !panel) return;

    toggleBtn.addEventListener('click', function () {
        panel.classList.toggle('show');
    });

    document.addEventListener('click', function (event) {
        if (!menu.contains(event.target)) {
            panel.classList.remove('show');
        }
    });
})();

