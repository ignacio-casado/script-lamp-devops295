#!/bin/bash

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ser ejecutado como root. Usa 'sudo' para ejecutarlo."
    exit 1
fi

# Verificar e instalar Apache
if ! command -v apache2 &> /dev/null; then
    echo "Instalando Apache..."
    sudo apt update
    sudo apt install -y apache2
else
    echo "Apache ya está instalado."
fi

# Verificar e instalar MariaDB
if ! command -v mariadb &> /dev/null; then
    echo "Instalando MariaDB..."
    sudo apt install -y mariadb-server
else
    echo "MariaDB ya está instalado."
fi

# Verificar e instalar PHP
if ! command -v php &> /dev/null; then
    echo "Instalando PHP y extensiones..."
    sudo apt install -y php libapache2-mod-php php-mysql
else
    echo "PHP ya está instalado."
fi

# Reiniciar servicios
sudo systemctl restart apache2
sudo systemctl restart mariadb

# Clonar el repositorio (reemplaza <URL_DEL_REPOSITORIO>)
git clone <URL_DEL_REPOSITORIO>

# Copiar archivos al directorio /var/www/html
sudo cp -r nombre_del_repo/* /var/www/html/

# Realizar un respaldo del archivo index.html
sudo mv /var/www/html/index.html /var/www/html/index.html.bkp

# Testear el servidor web utilizando curl
echo "Probando el servidor web..."
curl http://localhost

# Ruta del archivo index.php
archivo_index="/var/www/html/index.php"

# Verificar si el archivo existe
if [ ! -f "$archivo_index" ]; then
    echo "El archivo $archivo_index no existe."
    exit 1
fi

# Hacer una copia de seguridad del archivo index.php
cp "$archivo_index" "${archivo_index}.backup"

# Modificar la dirección IP a localhost usando awk
if command -v awk &> /dev/null; then
    awk '{gsub(/172\.20\.1\.101/, "localhost")}1' "$archivo_index" > "${archivo_index}.temp"
    mv "${archivo_index}.temp" "$archivo_index"
    echo "La dirección IP en el archivo $archivo_index ha sido modificada a localhost con éxito."
else
    echo "ATENCIÓN: 'awk' no está instalado. La modificación del archivo index.php no se realizó."
fi
