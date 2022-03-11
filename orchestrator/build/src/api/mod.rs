use actix_files::NamedFile;
use actix_web::{Error, HttpRequest, HttpResponse, Responder};
use reqwest::header::HeaderValue;
use reqwest::{header::HeaderName, StatusCode};
use std::env::{self, current_dir};
use std::path::PathBuf;
use std::str::FromStr;
use tracing::{debug, error, info, instrument, span, warn, Level};
pub async fn homepage_redirect(req: HttpRequest) -> HttpResponse {
    let mut res = HttpResponse::new(StatusCode::SEE_OTHER);
    res.headers_mut().append(
        HeaderName::from_str("LOCATION").unwrap(),
        HeaderValue::from_str("/ui/").unwrap(),
    );
    res
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

struct HomeUrbitStatus {
    netdata: AppStatus,
    minio: AppStatus,
    urbit: AppStatus,
    urbit_container: ContainerStatus,
    minio_container: ContainerStatus,
    netdata_container: ContainerStatus,
}

enum AppStatus {
    Loading,
    Running,
    Stopped,
    Unknown,
}

enum ContainerStatus {
    Running,
    Stopped,
}
