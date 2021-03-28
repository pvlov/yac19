## code to prepare `covrki` dataset goes here

covrki <- rki_fetch_all()

usethis::use_data(covrki, overwrite = TRUE, compress = "xz", version = 3)
