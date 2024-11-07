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
    padding: 0;
    margin: 64px 64px
}

h1 {
    margin-bottom: 80px;
}

h2 {
  margin-block-end: 0.2em;
}

blockquote {
    font-style: italic;
    color: #777;
    border-left: 4px solid #ccc;
    margin: 1.5em 10px;
    padding: 0.5em 10px 0.5em 1em;
}

/**
* Slide layout components
*/

.column {
    display: flex;
    flex: 1;
    flex-direction: column;
}

/* first content in slide is already pushed down because it has an h1 at the top */
.column :first-child {
    margin-top: 0;
}

.highlight-bg {
    background: rgba(0, 160, 255, 0.2)
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

    width: 100%;
    padding: 20px;
    flex-direction: column;
}

.slide.active {
    display: flex;
}

.slide-content {
  display: flex;
  flex-direction: column;
}

.slide-content:has(.column) {
    flex-direction: row;
    gap: 32px;
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
    <button id='fullscreen' title="Toggle Full Screen">⛶</button>
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

        function toggleFullScreen() {
            if (!document.fullscreenElement) {
                document.documentElement.requestFullscreen();
            } else if (document.exitFullscreen) {
                document.exitFullscreen();
            }
        }

        currentSlide = getSlideFromHash();
        showSlide(currentSlide);

        document.getElementById("prev").onclick = () => {
            if (currentSlide > 0) showSlide(currentSlide - 1);
        };
        document.getElementById("next").onclick = () => {
            if (currentSlide < slides.length - 1) showSlide(currentSlide + 1);
        };
        document.getElementById("fullscreen").onclick = toggleFullScreen;

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
