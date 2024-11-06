<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <style>
        body {
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        .slide {
            display: none;
            padding: 20px;
            text-align: center;
        }

        .slide.active {
            display: block;
        }

        button {
            padding: 10px 20px;
            margin: 10px;
        }

        .nav {
            position: absolute;
            bottom: 10px;
            width: 100%;
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>
<div id='slideshow'>
    {{ slides | safe }}
</div>
<div class='nav'>
    <button id='prev'>Previous</button>
    <button id='next'>Next</button>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        let slides = document.querySelectorAll(".slide");
        let currentSlide = 0;

        function showSlide(index) {
            slides[currentSlide].classList.remove("active");
            currentSlide = (index + slides.length) % slides.length;
            slides[currentSlide].classList.add("active");
            window.location.hash = `slide-id=${currentSlide}`;
        }

        function getSlideFromHash() {
            const hash = window.location.hash;
            const match = hash.match(/slide-id=(\d+)/);
            return match ? parseInt(match[1], 10) : 0;
        }

        currentSlide = getSlideFromHash();
        showSlide(currentSlide);

        document.getElementById("prev").onclick = () => showSlide(currentSlide - 1);
        document.getElementById("next").onclick = () => showSlide(currentSlide + 1);

        document.addEventListener("keydown", function(event) {
            if (event.key === "ArrowRight" || event.key === " ") showSlide(currentSlide + 1);
            if (event.key === "ArrowLeft") showSlide(currentSlide - 1);
        });
    });
</script>
</body>
</html>