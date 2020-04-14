#!/usr/bin/env bash

aws help | sed -ne '/acm/,$ p' | grep 'o ' | grep -v topics | awk '{ print $2 }' > ./services.txt

while read s; do
	echo $s
	mkdir -p ./services/$s
	
	tmpfile="./services/$s/temp.txt"
	rm $tmpfile
	aws $s help | grep -E "o (get|describe|list)-" | awk '{ print $2 }' >> "$tmpfile"

	echo -n "" > ./services/$s/entities.txt
	subcommands=$(<./services/$s/temp.txt)
	
	while read -r subcommand;
	do
		entity=${subcommand#*-}
		if [[ $entity == *statuses ]] || \
		   [[ $entity == *addresses ]] || \
		   [[ $entity == *aliases ]] || \
		   [[ $entity == *buses ]] || \
		   [[ $entity == *meshes ]] || \
		   [[ $entity == *branches ]];
		then
			entity="${entity%??}"
		elif [[ $entity == *status ]] || \
             [[ $entity == *address ]] || \
             [[ $entity == *alias ]] || \
             [[ $entity == *bus ]] || \
             [[ $entity == *-nfs ]] || \
             [[ $entity == *-efs ]];
		then
			: # PASS
		elif [[ $entity == *ies ]];
		then
			entity="${entity%???}y"
		elif [[ $entity == *s ]];
		then
			entity="${entity%?}"
		fi 
		echo "$entity" >> "./services/$s/entities.txt"
	done < "$tmpfile"

	sort -u -o "./services/$s/entities.txt" "./services/$s/entities.txt"
	# cat ./services/$s/{get,list,describe}.txt | sed -e 's/^[a-z]*-//' | sort -u > ./services/$s/entities.txt
done < ./services.txt

