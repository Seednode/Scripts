#!/bin/rzsh
# script to swap epon onts

# set required variables
confirm=("Yes" "No")

# set prompt
PS3="->"

# clear screen
clear

# prompt for old mac address
echo -e "\nEnter old ONT MAC address, or type \`quit\` to quit: "
read old_mac

# check for quit or incorrect mac address length
check_old="${#old_mac}"
if [ "$old_mac" = "quit" ];
  then exit;
elif [ "$check_old" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
fi

# clear screen
clear

# prompt for new mac address
echo -e "\nEnter new ONT MAC address, or type \`quit\` to quit: "
read new_mac

# check for quit or incorrect mac address length
check_new="${#new_mac}"
if [ "$new_mac" = "quit" ];
  then exit;
elif [ "$check_new" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
fi

# clear screen
clear

# confirm selected command
echo -e "\nYou're swapping "$old_mac" for "$new_mac". Is that correct?\n"

# prompt for final confirmation
select confirmation in "${confirm[@]}"; do
  case "$confirmation" in
    "Yes")
      echo "Swapping ONTs..."; ssh intranet epop "$old_mac" "$new_mac"; break;;
    "No")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac
done
