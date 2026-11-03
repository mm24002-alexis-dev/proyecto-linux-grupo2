# Proyecto Linux - Grupo 2

Proyecto final de **Introducción al Software Libre (ISL135)** – Universidad de El Salvador, Facultad Multidisciplinaria de Occidente, Ciclo II-2026.

Implementación de un servidor Linux automatizado (`servidor-grupo2`) que integra administración del sistema, automatización con cron, control de versiones con Git/GitHub y contenedores Docker.

**Tutora:** Ing. Graciela Albaluz Escalante Grijalva (GT01)

## Integrantes

| Carnet | Nombre |
|--------|--------|
| MM24002 | Alexis Jonathan Mazariego Mazariego |
| QV22002 | Danilo Alejandro Quintana Vásquez |
| BM25011 | Jesús Antonio Barahona Mejía |
| FA24002 | Francisco Antonio Figueroa Amaya |

## Estructura del proyecto

```
/proyecto/
├── datos/      # Archivos de configuración (grupo: soporte)
├── web/        # Archivos del sitio web (grupo: web)
├── scripts/    # Scripts de automatización (reporte_sistema.sh)
├── capturas/   # Evidencias del proyecto
├── Dockerfile  # Imagen personalizada servidor-grupo2
└── README.md
```

## Pasos de instalación y configuración

### 1. Preparación del entorno servidor
```bash
sudo hostnamectl set-hostname servidor-grupo2
sudo useradd -m -s /bin/bash adminsys && sudo usermod -aG sudo adminsys
sudo useradd -m -s /bin/bash tecnico
sudo useradd -m -s /bin/bash visitante
sudo groupadd soporte && sudo groupadd web
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante
sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
sudo chgrp soporte /proyecto/datos && sudo chgrp web /proyecto/web
sudo chmod 2775 /proyecto/datos /proyecto/web   # setgid: los archivos heredan el grupo
```

### 2. Automatización y monitoreo
- Script `/proyecto/scripts/reporte_sistema.sh`: muestra fecha/hora, hostname, usuarios conectados, espacio libre en disco, RAM disponible y contenedores Docker activos.
- Tarea cron cada 30 minutos:
```bash
*/30 * * * * /proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log 2>&1
```

### 3. Control de versiones
```bash
cd /proyecto
git init
git add .
git commit -m "Primer commit: estructura inicial del proyecto"
git branch -M main
git remote add origin https://github.com/mm24002-alexis-dev/proyecto-linux-grupo2.git
git push -u origin main
```

### 4. Docker
```bash
sudo apt update && sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
docker --version
docker run hello-world
docker ps -a
```

### 5. Implementación de servidor web Nginx mediante Docker

En esta fase se implementó un servidor web utilizando la imagen oficial de Nginx disponible en Docker Hub.

Primero se preparó una página web personalizada dentro del directorio `/proyecto/web/`, la cual contiene información del proyecto y del servidor.

Posteriormente se ejecutó un contenedor Docker llamado `nginx-oficial`, utilizando el puerto 8080 del servidor Fedora para acceder al puerto 80 del contenedor. También se configuró un volumen compartido para que Nginx pudiera servir directamente los archivos almacenados en `/proyecto/web/`.

Durante la configuración se presentó un error HTTP 403 Forbidden debido a las políticas de seguridad de SELinux. Para solucionarlo se utilizó la opción `:Z` en el montaje del volumen, permitiendo el acceso adecuado del contenedor sin desactivar SELinux.

Finalmente se comprobó el funcionamiento mediante `curl`, se accedió a la página desde otro equipo de la red local y se revisaron los registros del contenedor mediante `docker logs`.

**Resultado:** el servidor Nginx quedó funcionando correctamente y sirviendo la página personalizada a través del puerto 8080.****

```bash
docker run -d --name nginx-web -p 8080:80 -v /proyecto/web:/usr/share/nginx/html nginx
```
Acceso: http://localhost:8080

### 6. Construcción de una imagen personalizada mediante Dockerfile
En esta fase se desarrolló una imagen Docker personalizada utilizando como base la imagen oficial de Nginx.
Primero se creó un archivo denominado Dockerfile dentro del directorio /proyecto/. En este archivo se definieron las instrucciones necesarias para construir el servidor web:
### FROM nginx:latest: establece Nginx como imagen base.
### COPY web/ /usr/share/nginx/html/: copia los archivos de la página web al directorio utilizado por Nginx.
### EXPOSE 80: declara el puerto que utiliza el servidor web dentro del contenedor.
### CMD ["nginx", "-g", "daemon off;"]: establece el comando para iniciar Nginx en primer plano.

Posteriormente se ejecutó el comando docker build -t servidor-grupo2 . para construir la imagen personalizada utilizando el directorio /proyecto/ como contexto de construcción.
Una vez construida, se ejecutó un nuevo contenedor denominado nginx-personalizado, utilizando el puerto 8081 del servidor para acceder al puerto 80 del contenedor.
Finalmente se verificó su funcionamiento mediante los comandos docker ps y curl, comprobando que tanto el servidor Nginx oficial como la imagen personalizada podían funcionar simultáneamente y entregar correctamente la página web.
Comparación: el primer contenedor utiliza directamente la imagen oficial de Nginx, mientras que el segundo utiliza una imagen construida mediante un Dockerfile, incorporando los archivos propios del proyecto.
Resultado: se logró construir y ejecutar una imagen Docker personalizada, manteniendo simultáneamente el servidor oficial y el personalizado en puertos diferentes.

```bash
docker build -t servidor-grupo2 /proyecto
docker run -d --name servidor-personalizado -p 8081:80 servidor-grupo2
```
Acceso: http://localhost:8081

### 7. Redes y volúmenes
```bash
docker network create red-proyecto
docker run -d --name nginx-red --network red-proyecto -p 8082:80 nginx
docker volume create volumen-web
docker run -d --name nginx-volumen -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx
```

### 8. Pruebas y verificación
```bash
docker run --rm --network red-proyecto alpine ping -c 4 nginx-red
docker ps
crontab -l
git log --oneline
```

## Servicios y puertos

| Puerto | Servicio |
|--------|----------|
| 8080 | Nginx oficial con /proyecto/web montado |
| 8081 | Imagen personalizada servidor-grupo2 |
| 8082 | Nginx conectado a red-proyecto |
| 8083 | Nginx con volumen persistente volumen-web |

## Tecnologías
GNU/Linux (Ubuntu), Bash, Cron, Git, GitHub, Docker, Nginx, Alpine Linux.


