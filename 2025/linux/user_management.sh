#!/bin/bash

<<info

This script is for user account management.

Usage: script_name [OPTIONS]

Available options:
  -c, --create       Create a new user account
  -r, --reset        Reset password for an existing user
  -d, --delete       Delete an existing user account
  -l, --list         List all user accounts with details
  -h, --help         Display this help message

Examples:
  script_name --create        # Create a new user
  script_name --reset         # Reset password for a user
  script_name --list          # Show all users with UID, home, shell

info

# Common Utilities
function util {
	read -p "Enter username: " username

	if [[ -z "$username" ]]; then
		echo "User name cannot be empty"
		exit 1
	else
		echo "$username"
	fi
}

# Create User
function create_user {
	while true; do
		username=$(util)
		if grep -q "^$username:" /etc/passwd; then
			echo "User already exists!"
			continue
		fi

		if sudo useradd -m "$username"; then
			read -s -p "Enter password" password
			echo
			echo -e "$username:$password" | sudo chpasswd
			echo "=============== User $username created successfully! ==============="
		else
			echo "Something went wrong!"
		fi
		break
	done
}

#  Delete User
function delete_user {
	username=$(util)
	if grep -q "^$username:" /etc/passwd; then
		sudo userdel -r "$username" 2> /dev/null
		echo "=============== User $username deleted successfully! ==============="
	else
		echo "User doesn't exist!"
		exit 1
	fi
}

# Reset Password
function reset_password {
	username=$(util)
	if grep -q "^$username:" /etc/passwd; then
		read -s -p "Enter new password: " password
		echo
		read -s -p "Confirm password: " confirm
		echo

		if  [[ "$password" != "$confirm" ]]; then
			echo "Passwords don't match. Try again!"
			exit 1
		fi

		echo -e "$username:$password" | sudo chpasswd
		echo "Password updated for user $username"
		echo "=============== Password reset successfull! ==============="
	else
		echo "User doesn't exist!"
		exit 1
	fi
}

# List Users
function list_users {
	echo "=============== System Users ==============="
	awk -F: '{print "Username: "$1", UID: "$3}' /etc/passwd
}

# Help
function help {
	echo "Usage: $0 [OPTIONS]"
   	echo
	echo "Available options:"
	echo "  -c, --create       Create a new user account"
	echo "  -r, --reset        Reset password for an existing user"
	echo "  -d, --delete       Delete an existing user account"
	echo "  -l, --list         List all user accounts with details"
 	echo "  -h, --help         Display this help message"
 	echo
  	echo "Examples:"
 	echo "  $0 --create        # Create a new user"
 	echo "  $0 --reset         # Reset password for a user"
	echo "  $0 --list          # Show all users with UID, home, shell"
}

# Implementation of the Options
while [[ $# > 0 ]]; do

case "$1" in

	-c|--create) create_user ;;
	-d|--delete) delete_user ;;
	-r|--reset) reset_password ;;
	-l|--list) list_users ;;
	-h|--help) help ;;
	-*) echo "Invalid option: $1"
	exit 1 ;;

esac
shift
done
