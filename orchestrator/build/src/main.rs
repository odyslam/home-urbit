use actix_files;
use actix_web::{middleware, web, App, HttpServer};
use api::*;
use tracing::{info, Level};
use tracing_subscriber;
mod api;
mod config;
mod docker_driver;
mod urbit_driver;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Enable logging
    std::env::set_var("RUST_LOG", "DEBUG");
    tracing_subscriber::fmt::init();
    // Main actix web app
    HttpServer::new(|| {
        App::new()
            .wrap(middleware::Logger::default())
            // Normalize path: /ui to /ui/ and /ui/// to /ui/
            .wrap(middleware::NormalizePath::new(
                middleware::TrailingSlash::MergeOnly,
            ))
            .route("/", web::get().to(homepage_redirect))
            .service(
                actix_files::Files::new("/ui", "./src/ui")
                    .show_files_listing()
                    .index_file("index.html"),
            )
            .service(
                web::scope("/api/v1")
                    .route("/upload_key", web::post().to(upload_key))
                    .route("/upload_pier", web::post().to(upload_pier))
                    .route("/status", web::get().to(status)),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
