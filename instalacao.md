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

