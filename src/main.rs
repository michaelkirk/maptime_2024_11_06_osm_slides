use pulldown_cmark::{Parser, Event, Tag, HeadingLevel, TagEnd};
use std::fs;


const CSS: &'static str = r#"
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
"#;

const JS: &'static str = r#"
document.addEventListener("DOMContentLoaded", function() {
    let slides = document.querySelectorAll(".slide");
    let currentSlide = 0;

    function showSlide(index) {
        slides[currentSlide].classList.remove("active");
        currentSlide = (index + slides.length) % slides.length;
        slides[currentSlide].classList.add("active");
    }

    document.getElementById("prev").onclick = () => showSlide(currentSlide - 1);
    document.getElementById("next").onclick = () => showSlide(currentSlide + 1);

    document.addEventListener("keydown", function(event) {
        if (event.key === "ArrowRight") showSlide(currentSlide + 1);
        if (event.key === "ArrowLeft") showSlide(currentSlide - 1);
    });

    showSlide(currentSlide);
});
"#;

fn main() {
    pretty_env_logger::init();
    let input = std::env::args().nth(1).expect("Please provide a markdown file path.");
    let markdown = fs::read_to_string(&input).expect("Failed to read the markdown file");

    let html = generate_slideshow_html(&markdown);
    fs::write("index.html", html).expect("Failed to write HTML file");
    println!("Slideshow created as index.html");
}

fn generate_slideshow_html(markdown: &str) -> String {
    let mut html_output = String::from("<!DOCTYPE html><html><head><meta charset='utf-8'>");
    html_output.push_str("<style>");
    html_output.push_str(&CSS);
    html_output.push_str("</style></head><body>");

    html_output.push_str("<div id='slideshow'>");

    let slide_idx = 0;
    let mut parser = Parser::new(markdown).into_iter();

    let mut slide_header = parser.next();
    let Some(Event::Start(Tag::Heading { level: HeadingLevel::H1, .. })) = &slide_header else {
        panic!("Expected first event to be <h1>, but got: {slide_header:?}")
    };

    loop {
        let Some(next_slide_header) = slide_header.take() else {
            log::info!("No more slides found");
            break;
        };
        {
            let h1_parser = std::iter::once(next_slide_header).chain((&mut parser).take_while(|event| {
                match event {
                    Event::End(TagEnd::Heading(HeadingLevel::H1)) => false,
                    _ => true,
                }
            }));

            html_output.push_str(&format!("<div class='slide'><!-- begin slide {slide_idx} -->"));
            pulldown_cmark::html::push_html(&mut html_output, h1_parser);
        }
        {
            let section_parser = (&mut parser).take_while(|event| {
                match event {
                    Event::Start(Tag::Heading { level: HeadingLevel::H1, .. }) => {
                        slide_header = Some(event.clone());
                        false
                    },
                    _ => true,
                }
            });
            html_output.push_str(&"<div class='slide-content'>");
            pulldown_cmark::html::push_html(&mut html_output, section_parser);
            html_output.push_str(&"</div><!-- end slide-content -->");
        }
        html_output.push_str(&format!("</div><!-- end slide {slide_idx} -->"));
    }
    html_output.push_str("</div><!-- end slideshow -->"); // Close slideshow div

    html_output.push_str("<div class='nav'><button id='prev'>Previous</button>");
    html_output.push_str("<button id='next'>Next</button></div>");

    html_output.push_str("<script>");
    html_output.push_str(&JS);
    html_output.push_str("</script></body></html>");

    html_output
}

