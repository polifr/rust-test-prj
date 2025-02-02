# Fase 1: Compilazione
FROM rust:1.84 AS builder

# Imposta la cartella di lavoro
WORKDIR /app

# Copia il file Cargo e scarica le dipendenze
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release && rm -rf src

# Copia i sorgenti effettivi e compila
COPY . .
RUN cargo build --release

# Fase 2: Creazione dell'immagine finale
FROM debian:bullseye-slim

# Imposta la cartella di lavoro
WORKDIR /app

# Copia solo il binario compilato dalla fase precedente
COPY --from=builder /app/target/release/rust-test-prj .

# Espone la porta 8080
EXPOSE 8080

# Comando di esecuzione
CMD ["./rust-test-prj"]
