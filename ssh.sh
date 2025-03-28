#!/bin/bash

# Проверка наличия публичного ключа
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "Публичный ключ ~/.ssh/id_rsa.pub не найден. Создайте его с помощью ssh-keygen."
    exit 1
fi

while read -r line
do
    echo "running $line"
    
    scp -o "StrictHostKeyChecking=no" ~/.ssh/id_rsa.pub root@"$line":/tmp/id_rsa.pub

    ssh -o "StrictHostKeyChecking=no" root@"$line" "mkdir -p ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys && rm /tmp/id_rsa.pub" < /dev/null &
    
    sleep 3  # Короткая пауза
done < "serverlist"

wait
