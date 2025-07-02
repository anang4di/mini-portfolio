# Mini Portfolio

Sebuah website portfolio sederhana. Proyek ini dibangun dengan fokus pada praktik **CI/CD pipeline menggunakan Jenkins** dan penerapan **DevSecOps** melalui integrasi tools seperti **Gitleaks** dan **Trivy**.

## Fitur

- Halaman portfolio responsif dan ringan
- CI/CD otomatis dengan Jenkins
- Keamanan kode dan image melalui Gitleaks dan Trivy
- Containerized menggunakan Docker
- Deployment ke EC2 via pipeline

## Teknologi yang Digunakan

- **Frontend**: HTML, CSS
- **CI/CD**: Jenkins Pipeline
- **DevSecOps Tools**:
  - [Gitleaks](https://github.com/gitleaks/gitleaks): Deteksi kebocoran secret/token
  - [Trivy](https://github.com/aquasecurity/trivy): Pemindaian kerentanan pada image
- **Containerization**: Docker
- **Hosting**: EC2 (Amazon Web Services)

## Keamanan DevSecOps

- **Gitleaks** memindai secret/token sensitif yang tidak sengaja ter-push ke Git
- **Trivy** memindai kerentanan pada image Docker sebelum di-deploy
- Kedua tools diintegrasikan dalam Jenkins pipeline sebagai tahap mandatory sebelum build dan deploy
