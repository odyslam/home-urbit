use actix_web::{get, HttpResponse, Responder};

#[get("/")]
pub async fn homepage() -> HttpResponse {
    HttpResponse::Ok().body("Hello world!")
}

#[get("/dashboard")]
pub async fn dashboard() -> HttpResponse {
    HttpResponse::Ok().body("Hello world!")
}

pub async fn upload_key() -> HttpResponse {
    HttpResponse::Ok().body("upload_key")
}

pub async fn upload_pier() -> HttpResponse {
    HttpResponse::Ok().body("upload_key")
}

pub async fn status() -> HttpResponse {
    HttpResponse::Ok().body("upload_key")
}
