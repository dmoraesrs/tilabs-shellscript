#!/bin/bash
clear
while :;
do
    echo "Selecione uma Opção"
    echo "1) Gerenciamento de Usuário"
    echo "2) Gerenciamento de Backup"
    echo "3) Gerenciamento de Logs "
    echo "0) Sair "
    read OPCAO
        case $OPCAO in
        1)
            while :;
            do
                echo "Selecione uma Opção"
                echo "1) Cadastrar usuario"
                echo "2) Remover   usuário"
                echo "3) Validar   usuário"
                echo "0) SAIR"
                read OP_USER
                case $OP_USER in
                    1)
                        clear
                        echo -n "Qual o nome do usuário que será cadastrado: "
                        read USUARIO_CAD
                        VALIDATE=$(cat /etc/passwd |cut -d: -f1 |grep $USUARIO_CAD)
                            if [ "$VALIDATE" == "$USUARIO_CAD" ]
                                then
                                    echo "Usuário(a) já existe no sistema...."
                                    exit
                             else
                                    echo "Cadastrando usuario no sistema...."
                                    useradd $USUARIO_CAD && passwd $USUARIO_CAD && echo "Usuario cadastrado"   
                            fi
                    ;;
                    2)
                        clear
                        echo -n "Qual o nome do usuário que será removido: "
                        read USUARIO_CAD
                        VALIDATE=$(cat /etc/passwd |cut -d: -f1 |grep $USUARIO_CAD)
                            if [ "$VALIDATE" == "$USUARIO_CAD" ]
                                then
                                    userdel $USUARIO_CAD
                             else
                                    echo "Usuario Não existe"
                            fi
                    ;;
                    3)
                        clear
                        echo -n "Qual o nome do usuário que será validado: "
                        read USUARIO_CAD
                        VALIDATE=$(cat /etc/passwd |cut -d: -f1 |grep $USUARIO_CAD)
                            if [ "$VALIDATE" == "$USUARIO_CAD" ]
                                then
                                    id $USUARIO_CAD
                             else
                                    echo "Usuario Não existe"
                            fi
                    ;;
                    0)
                        exit
                    ;;
                    *)
                        clear
                        echo "Opção invalida" 
                        exit
                    ;;
                esac
            done
        ;;
        2)
            data=$(date +%d%m%Y_%H%M%S)
            logbackup=/var/log/backup.log
            dialog --msgbox "Gerenciamento de backup"
            clear
            dialog --inputbox 'Digite a origem do backup' 0 0 2>/tmp/tempdata1
            origem=$( cat /tmp/tempdata1 )
            clear
            dialog --inputbox 'Digite o Destino do backup' 0 0 2>/tmp/tempdata2
            destino=$( cat /tmp/tempdata2 )
            clear
            echo "Data execução: $data" >> $logbackup
            echo "Destino: $origem"     >> $logbackup
            echo "Destino: $destino"    >> $logbackup
            echo "Arquivos copiados:"   >> $logbackup
            tar czvf /$destino/$origem-$data.tar.gz    /$origem >> $logbackup
        ;;
        3)
            tail -f /var/log/messages > out &
            dialog                                         \
            --title 'Monitorando Mensagens do Sistema'  \
            --tailbox out                               \
            0 0
        ;;
        0)
            echo "Saindo....."
            exit
        ;;
        *)
            clear;echo "OPÇÃO INVALIDA"
            exit
        ;;
    esac
done
