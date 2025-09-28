#!/bin/bash

file='data/data.json'
# create json file if it does not exist
if [[ ! -e "$file" ]]; then
	mkdir -p data
	echo "{}" > "$file"
fi

# print schedule
function print_schedule() { 
	echo "+--------+----------+----------+"
	printf "| %-6s | %-8s | %-6s|\n" " Team" "Shift" "Employees"
	echo "+--------+----------+----------+"

	jq -r 'to_entries[] | .key as $team | .value | to_entries[] | "\($team) \(.key) \(.value | join(", "))" ' "$file" | \
		while read -r team shift employees; do
			printf "| %-6s | %-8s | %-8s |\n" "$team" "$shift" "$employees"
		done

	echo "+--------+----------+----------+"
}

while true
do
	# input name
	read -p "Enter Employee Name: " emp_name
	
	# exit script
	[[ "$emp_name" == "exit" ]] && break
        
	# print schedule	
	[[ "$emp_name" == "print" ]] && { print_schedule; break; }

        # input and validate shift
	while true; do
		read -p "Enter Shift (morning, mid, night): " emp_shift
		[[ "$emp_shift" == "morning" || "$emp_shift" == "mid" || "$emp_shift" == "night" ]] && break

		echo -e "Invalid Shift. Please enter: morning, mid, or night.\n"
	done

	# input and validate team
	while true; do
		read -p "Enter Team (a1, a2, a3, b1, b2, b3): " emp_team
		[[ "$emp_team" =~ ^(a1|a2|a3|b1|b2|b3)$ ]] && break

		echo -e "Invalid Team. Please enter: a1, a2, a3, b1, b2, b3.\n"	
	done
	
        # count number of employee in a team per shift
	count=$(jq --arg name "$emp_name" --arg shift "$emp_shift"  --arg team "$emp_team" '.[$team][$shift] | length // 0' data/data.json)
 	if [[ "$count" -ge 2 ]]; then
		echo "Error: Maximum employee per shift in team ${emp_team} reached. Exiting"
		break
	fi

	# append to json file
	append_json=$(jq --arg name "$emp_name" --arg shift "$emp_shift"  --arg team "$emp_team" '.[$team][$shift] += [$name] // .[$team][$shift] = [$name]' "$file")
	echo "$append_json" > "$file"
done


