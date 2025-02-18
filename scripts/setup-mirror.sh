#!/bin/bash

# Definir el archivo de repositorio de kali
REPO_FILE="/etc/apt/sources.list.d/kali.list"
KEYRING="/usr/share/keyrings/kali-archive-keyring.gpg"

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root. Utilisez sudo."
    exit 1
fi

# Agregar el repositorio de kali si no existe
if [[ ! -f "$REPO_FILE" ]]; then
    echo "Ajout du dépôt Kali..."
    echo "deb [signed-by=$KEYRING] http://http.kali.org/kali kali-rolling main non-free contrib" | tee "$REPO_FILE"
else
    echo "Le dépôt Kali est déjà ajouté dans $REPO_FILE"
fi

# Telecharger les clefs de kali si ca n existe pas
if [[ ! -f "$KEYRING" ]]; then
    echo "Téléchargement de la clé GPG de Kali..."
    wget -qO - https://archive.kali.org/archive-key.asc | gpg --dearmor > "$KEYRING"
else
    echo "La clé GPG de Kali est déjà installée dans $KEYRING"
fi

# Actualizar lista de paquetes
echo "Mise à jour de la liste des paquets..."
apt update

echo "Le dépôt Kali a été ajouté avec succès."
