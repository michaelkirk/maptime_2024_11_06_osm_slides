use pulldown_cmark::{Event, HeadingLevel, Parser, Tag, TagEnd};
use std::fs;
use tera::{Context, Tera};

fn main() {
    pretty_env_logger::init();
    let input = std::env::args()
        .nth(1)
        .expect("Please provide a markdown file path.");
    let markdown = fs::read_to_string(&input).expect("Failed to read the markdown file");

    let html = generate_slideshow_html(&markdown);
    fs::write("index.html", html).expect("Failed to write HTML file");
    println!("Slideshow created as index.html");
}

fn generate_slideshow_html(markdown: &str) -> String {
    let mut html_output = String::new();

    let mut slide_idx = 0;
    let mut parser = Parser::new(markdown).into_iter();

    let mut slide_header = parser.next();
    let Some(Event::Start(Tag::Heading {
        level: HeadingLevel::H1,
        ..
    })) = &slide_header
    else {
        panic!("Expected first event to be <h1>, but got: {slide_header:?}")
    };

    loop {
        let Some(next_slide_header) = slide_header.take() else {
            log::info!("No more slides found");
            break;
        };
        {
            let h1_parser =
                std::iter::once(next_slide_header).chain((&mut parser).take_while(|event| {
                    match event {
                        Event::End(TagEnd::Heading(HeadingLevel::H1)) => false,
                        _ => true,
                    }
                })).chain(std::iter::once(Event::End(TagEnd::Heading(HeadingLevel::H1))));

            html_output.push_str(&format!(
                "\n<div class='slide slide-{slide_idx}'>"
            ));
            pulldown_cmark::html::push_html(&mut html_output, h1_parser);
        }
        {
            let section_parser = (&mut parser).take_while(|event| match event {
                Event::Start(Tag::Heading {
                    level: HeadingLevel::H1,
                    ..
                }) => {
                    slide_header = Some(event.clone());
                    false
                }
                _ => true,
            });
            html_output.push_str(&"<div class='slide-content'>\n");
            pulldown_cmark::html::push_html(&mut html_output, section_parser);
            html_output.push_str(&"\n</div><!-- end slide-content -->");
        }
        html_output.push_str(&format!("\n</div><!-- end slide-{slide_idx} -->"));
        slide_idx += 1;
    }

    let tera = Tera::new("templates/*").expect("Failed to initialize Tera");
    let mut context = Context::new();
    context.insert("slides", &html_output);

    tera.render("index.html.tpl", &context)
        .expect("Failed to render template")
}
