#!/bin/bash

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]
then
    echo "Este script debe ser ejecutado como root. Usa 'sudo' para ejecutarlo."
    exit
fi

# Verificar si Apache ya está instalado
if ! command -v apache2 &> /dev/null
then
    # Instalar Apache
    sudo apt update
    sudo apt install -y apache2
else
    echo "Apache ya está instalado."
fi

# Verificar si MariaDB ya está instalado
if ! command -v mariadb &> /dev/null
then
    # Instalar MariaDB
    sudo apt install -y mariadb-server
else
    echo "MariaDB ya está instalado."
fi

# Verificar si PHP ya está instalado
if ! command -v php &> /dev/null
then
    # Instalar PHP y extensiones
    sudo apt install -y php libapache2-mod-php php-mysql
else
    echo "PHP ya está instalado."
fi

# Reiniciar servicios
sudo systemctl restart apache2
sudo systemctl restart mariadb

# Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>

# Copiar los archivos al directorio /var/www/html
sudo cp -r nombre_del_repo/* /var/www/html/

# Realizar un respaldo del archivo index.html
sudo mv /var/www/html/index.html /var/www/html/index.html.bkp

# Testear el servidor web utilizando curl
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
awk '{gsub(/172\.20\.1\.101/, "localhost")}1' "$archivo_index" > "${archivo_index}.temp"
mv "${archivo_index}.temp" "$archivo_index"

echo "La dirección IP en el archivo $archivo_index ha sido modificada a localhost con éxito."
