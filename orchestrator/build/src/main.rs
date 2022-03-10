use actix_web::{web, App, HttpServer};
use api::*;
mod api;
mod config;
mod docker_driver;
mod urbit_driver;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new().service(dashboard).service(homepage).service(
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
