<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <style>
/**
* Typography
*/
body {
    font-family: Arial, sans-serif;
    font-size: 300%;
    background: white;
    margin: 64px
}

h1 {
    margin-bottom: 80px;
}

blockquote {
    font-style: italic;
    color: #777;
    border-left: 4px solid #ccc;
    margin: 1.5em 10px;
    padding: 0.5em 10px 0.5em 1em;
}

/*
blockquote:before {
    content: open-quote;
}

blockquote:after {
    content: close-quote;
}
*/

blockquote p {
    display: inline;
}

/**
 * Slides UI
 */

.slide {
    display: none;
    padding: 20px;
}

.slide.active {
    display: block;
}

.nav button {
    padding: 5px 10px;
    margin: 10px;
}

.nav {
    position: fixed;
    bottom: 10px;
    right: 10px;
    display: flex;
    justify-content: center;
}

#slide-number {
    font-size: 12px;
    margin-top: 16px;
    opacity: 0.5;
}

    </style>
</head>
<body>
<div id='slideshow'>
    {{ slides | safe }}
</div>
<div class='nav'>
    <button id='prev' title="Previous Slide">&lt;&mdash;</button>
    <span id='slide-number'>1 of 1</span>
    <button id='next' title="Next Slide">&mdash;&gt;</button>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        let slides = document.querySelectorAll(".slide");
        let currentSlide = 0;

        function showSlide(index) {
            slides[currentSlide].classList.remove("active");
            currentSlide = index;
            slides[currentSlide].classList.add("active");
            window.location.hash = `slide-id=${currentSlide}`;
            updateNavButtons();
            updateSlideNumber();
        }

        function getSlideFromHash() {
            const hash = window.location.hash;
            const match = hash.match(/slide-id=(\d+)/);
            return match ? parseInt(match[1], 10) : 0;
        }

        function updateNavButtons() {
            document.getElementById("prev").disabled = currentSlide === 0;
            document.getElementById("next").disabled = currentSlide === slides.length - 1;
        }

        function updateSlideNumber() {
            document.getElementById("slide-number").textContent = `${currentSlide + 1} of ${slides.length}`;
        }

        currentSlide = getSlideFromHash();
        showSlide(currentSlide);

        document.getElementById("prev").onclick = () => {
            if (currentSlide > 0) showSlide(currentSlide - 1);
        };
        document.getElementById("next").onclick = () => {
            if (currentSlide < slides.length - 1) showSlide(currentSlide + 1);
        };

        document.addEventListener("keydown", function(event) {
            if (event.key === "ArrowRight" || event.key === " ") {
                if (currentSlide < slides.length - 1) showSlide(currentSlide + 1);
            }
            if (event.key === "ArrowLeft") {
                if (currentSlide > 0) showSlide(currentSlide - 1);
            }
        });

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("devReload") === "1") {
            setInterval(() => {
                window.location.reload();
            }, 1000);
        }
    });
</script>
</body>
</html>
