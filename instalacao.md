# Instalação do servidor do cluster

OBS: Para o cluster de casa, ele é servidor de "backup do backup".    
Logo, precisa ser um servidor NFS também.

OBS: A primeira instalação foi testada numa máquina no Virtual Box.


## Instalação do Ubuntu Server 22.04.2

* Língua - English
* Teclado - Português (Brazil)
* Ubuntu Server + Search for third-party drivers
* Rede - Default
* Disco - Default (mas sem LVM)
* Disk layout - padrão
* Usuário - cluster
* Ubuntu PRO - Não
* OpenSSH Server - Instalar, sem importar identidade

### Pacotes - via snaps

* microk8s

Virão de repositórios próprios
* docker
* aws-cli
* google-cloud-sdk

Preciso avaliar melhor
* etcd
* mosquitto

## Prosseguir

Aguardar instalação   
Reboot now


## Login inicial

A máquina inicia uma instalação do `microk8s` automaticamente, mesmo antes do login.

### Upgrade

sudo bash
apt update
apt upgrade

### Aguardar instalação do `microk8s`

A instalação parece ainda acontecer em background.

Após algum tempo de espera, a máquina parece travar :-(

Reboot nela!

`microk8s` tá instalado :-)

## VBOX - Instalação do Guest Additions

Não roteirizado aqui (é muito específico)

## microk8s

### Habilitar usuário para usar



Habilitar addons   
https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s?&_ga=2.99577369.66062609.1677687423-1392530084.1676139765#3-enable-addons

`microk8s enable dns dashboard hostpath-storage`

