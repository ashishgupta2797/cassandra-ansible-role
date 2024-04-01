#!/bin/bash

install_cassandra() {
  # Update package list
  sudo apt update

  # Install OpenJDK 11 JRE
  sudo apt install -y openjdk-11-jre

  # Add Apache Cassandra repository
  echo 'deb [signed-by=/usr/share/keyrings/cassandra-archive-keyring.gpg] https://debian.cassandra.apache.org 41x main' | sudo tee /etc/apt/sources.list.d/cassandra.list > /dev/null

  # Create a new trusted.gpg.d directory if it doesn't exist
  sudo mkdir -p /etc/apt/trusted.gpg.d/

  # Add the Cassandra repository key
  curl -L https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor -o /usr/share/keyrings/cassandra-archive-keyring.gpg

  # Update package list again
  sudo apt update

  # Install Cassandra
  sudo apt install -y cassandra="4.1.3"

  # Start Cassandra service
  sudo service cassandra start

}

uninstall_cassandra() {
  # Stop Cassandra service
  sudo service cassandra stop

  # Uninstall Cassandra
  sudo apt purge -y cassandra

  # Remove Cassandra repository
  sudo rm /etc/apt/sources.list.d/cassandra.list

  # Remove Cassandra repository key
  sudo rm /usr/share/keyrings/cassandra-archive-keyring.gpg
}

# Check the number of arguments
if [ $# -eq 0 ]; then
  echo "Usage: $0 [install | uninstall]"
  exit 1
fi

# Perform action based on the argument
case "$1" in
  "install")
    install_cassandra
    ;;
  "uninstall")
    uninstall_cassandra
    ;;
  *)
    echo "Invalid argument. Usage: $0 [install | uninstall]"
    exit 1
    ;;
esac

exit 0