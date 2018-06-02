#!/bin/bash
#clear
function exists {
	while [ ! -f "$outFile" ]
	do
		echo -e "\n\e[93mEnter extant file and retry.\e[33m"
		read outFile
	done
	return 0
}
function zip_n_split {
	chrlen=${#outFile}
	uncut=$(wc -c "$outFile")
	chrlen=$((chrlen+1))
	cut=${uncut::-chrlen}
	if [ "$cut" -gt 99000000 ]; then
		noxtension=$(echo $outFile | cut -f 1 -d '.')
		file="${noxtension##*/}"
		echo -e "\n\e[37mCompressing, please wait...\e[90	m\n"
		7z -v99m -mx=0 a "$file".7z "$outFile" &> /dev/null
		numvols=$(7z l "$file.7z.001" | grep "Volumes" | tr -dc '0-9')
	else
		noxtension=$(echo $outFile | cut -f 1 -d '.')
		file="${noxtension##*/}"
		echo -e "\n\e[37mCompressing, please wait...\e[90	m\n"
		7z -v99m -mx=0 a "$file".7z "$outFile" &> /dev/null
		numvols=1
		return 0
	fi
}
function deccr {
	chrlen=${#outFile}
	uncut=$(wc -c "$outFile")
	chrlen=$((chrlen+1))
	cut=${uncut::-chrlen}
	rm -f links moe tek open
	echo -e "Mixtape links:\n" > moe
	echo -e "\nTeknik links:" > tek
	echo -e "\nOpenload.co links (use only if others down; has ads):" > open
	echo -e "\nMoe spare link (don't use or release, this is for backup!):" > moex
	if [ "$cut" -gt 99000000 ]; then
		7z -v99m -mx=0 a "$file".7z "$outFile" &> /dev/null
		numvols=$(7z l "$file.7z.001" | grep "Volumes" | tr -dc '0-9')
		j="$numvols"
		i=1	
		while [ "$i" -le "$j" ]; do
			if [ "$numvols" -le 9 ]; then
				outFile="$file"".7z"".00""$i"
			elif [ "$numvols" -le 99 ]; then
				outFile="$file"".7z"".0""$i"
			else
				outFile="$file"".7z"".""$i"
			fi
			echo -e "\n\e[37mFirst host...\e[90m"
			moes=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
			moex=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
			echo "$moex" >> moex
			echo "$moes" >> moe
			echo -e "\n\e[37mSecond host...\e[90m"
			ope1=$(curl --silent https://api.openload.co/1/file/ul? | jq -r '.result.url')
			ope2=$(curl --progress-bar -g -X POST -F "file1=@$outFile" "$ope1" | jq -r '.result.url')
			echo "ope2" >> open
			echo -e "\n\e[37mThird host...\e[90m"
			tek=$(curl --progress-bar -F file=@$outFile https://api.teknik.io/v1/Upload | jq -r '.result.url')
			echo "$tek" >> tek
			(( i="$i"+1 ))
		done	
	else
		7z -mx=0 a "$file".7z "$outFile" &> /dev/null
		outFile="$file"".7z"
		echo -e "\n\e[37mFirst host...\e[90m"
		moes=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
		moex=$(curl --progress-bar -F files[]="@$outFile" "https://mixtape.moe/upload.php" | jq -r '.files[].url')
		echo "$moex" >> moex
		echo "$moes" >> moe
		echo -e "\n\e[37mSecond host...\e[90m"
		ope1=$(curl --silent https://api.openload.co/1/file/ul? | jq -r '.result.url')
		ope2=$(curl --progress-bar -g -X POST -F "file1=@$outFile" "$ope1" | jq -r '.result.url')
		echo "$ope2" >> open
		echo -e "\n\e[37mThird host...\e[90m"
		tek=$(curl --progress-bar -F file=@$outFile https://api.teknik.io/v1/Upload | jq -r '.result.url')
		echo "$tek" >> tek

	fi
	livs=$(cat moe tek open > links)
	echo -e "\n\e[37mMaking link mirror 1...\e[90m"
	ix=$(cat links | curl --progress-bar -F 'f:1=<-' ix.io)
	ixio=$(curl --silent "http://ouo.io/api/DJoI8v6q?s=""$ix")
	echo -e "\n\e[37mMaking link mirror 2...\e[90m"
	sprun=$(cat links | curl --progress-bar -F 'clbin=<-' https://clbin.com)
	sprunge=$(curl --silent "http://ouo.io/api/DJoI8v6q?s=""$sprun")
	echo -e "\n\e[37mFinishing up...\e[90m"
	livs=$(cat links moex > linkx)
	nix=$(curl --progress-bar -F 'text=<-' http://nixpaste.lbr.uno < linkx)
	nix2=$(cat linkx | curl --progress-bar -F 'f:1=<-' ix.io)
	echo "$nix" "$nix2" > nixfil
	date=$(date +"%D")
	echo "$date" > date	
	pass=$(echo "exlineal""$date")
	scrypt enc -P nixfil nixfil.enc <<< "$pass"
	xxd nixfil.enc nixfil.hex
	b64 -e nixfil.hex nixfil.b64
	nixenc=$(tr -d '\n' < nixfil.b64)
	return 0
}



clear
table[1]="Movie"
table[2]="TV Show"
table[3]="Game"
table[4]="Music"
table[5]="Book"
table[6]="Software"
tab2[1]="movies"
tab2[2]="tv"
tab2[3]="games"
tab2[4]="music"
tab2[5]="books"
tab2[6]="software"
echo -e "\e[97mType of content: \n\t1. Movie\n\t2. TV Show\n\t3. Game\n\t4. Music\n\t5. Book\n\t6. Software\n\n?:"	
read mediatype
while [[ "$mediatype" != 1 && "$mediatype" != 2 && "$mediatype" != 3 && "$mediatype" != 4 && "$mediatype" != 5 && "$mediatype" != 6 ]]; do
	echo -e "\e[97mType of content: \n\t1. Movie\n\t2. TV Show\n\t3. Game\n\t4. Music\n\t5. Book\n\t6. Software\n\n?:"
	read mediatype
done
echo -e "\e[39m\n${table[$mediatype]}\n"
if [ "$mediatype" = 1 ]; then
	echo -e "\n\e[93mEnter title\n?:\e[33m"
	read title
	echo -e "\n\e[93mEnter rating\n?:\e[33m"
	read rating
	echo -e "\n\e[93mEnter genre\n?:\e[33m"
	read genre
	echo -e "\e[93mEnter description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!)\n?:\e[33m"
	read description
	echo -e "\e[93mEnter url where movie can be bought\n?:\e[33m"
	read url
	echo -e "\e[93mEnter IMDB url of movie\n?:\e[33m"
	read imdb
	echo -e "\e[93mEnter codec\n?:"
	read codec
	echo -e "\e[93mEnter filename for page. Usual filename rules apply.\e[33m"
	read pagename
	echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m "$title"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mgenre:\e[33m "$genre"\n\t\e[93mDescription:\e[33m "$description"\n\t\e[93mPurchase Link:\e[33m "$url"\n\t\e[93mIMDB Link:\e[33m "$imdb"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
	echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]; do
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
	done
	while [ "$correct" != "y" ]; do
		echo -e "\n\e[93mEnter title\n?:\e[33m"
		read title
		echo -e "\n\e[93mEnter rating\n?:\e[33m"
		read rating
		echo -e "\n\e[93mEnter genre\n?:\e[33m"
		read genre
		echo -e "\e[93mEnter description (MUST BE ALL ON ONE LINE; GOOGLE '"'text to one line'"'!)\n?:\e[33m"
		read description
		echo -e "\e[93mEnter url where movie can be bought\n?:\e[33m"
		read url
		echo -e "\e[93mEnter IMDB url of movie\n?:\e[33m"
		read imdb
		echo -e "\e[93mEnter codec\n?:"
		read codec
		echo -e "\e[93mEnter filename for page. Usual filename rules apply.\e[33m"
		read pagename
		echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m "$title"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mgenre:\e[33m "$genre"\n\t\e[93mDescription:\e[33m "$description"\n\t\e[93mPurchase Link:\e[33m "$url"\n\t\e[93mIMDB Link:\e[33m "$imdb"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]; do
			echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
			read correct
		done
	done
	echo -e "\e[93m\nEnter path to file\n?:\e[33m"
	read outFile
	exists
	echo -e "\e[90m"
	zip_n_split
	deccr
	export title="$title"
	export season="$season"
	export rating="$rating"
	export genre="$genre"
	export description="$description"
	export url="$url"
	export imdb="$imdb"
	export codec="$codec"
	export dlink="$ixio"
	export dlink2="$sprunge"
	export sparelink="$nixenc"
	export date=$(cat date)
	mo /exlineal/templates/temp_movie.mo > /exlineal/outfiles/movies/"$pagename".html	
elif [ "$mediatype" = 2 ]; then
	echo "TV Show"
	echo -e "\n\e[93mEnter title of show\n?:\e[33m"
	read name
	echo -e "\n\e[93mEnter season number\n?:\e[33m"
	read season
	echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
	read description
	echo -e "\e[93mEnter URL where show can be purchsed\n?:\e[33m"
	read site
	echo -e "\e[93mEnter rating\n?:\e[33m"
	read rating
	echo -e "\e[93mEnter genre\n?:\e[33m"
	read genre
	echo -e "\e[93mEnter IMDB URL\n?:\e[33m"
	read imdb
	echo -e "\e[93mEnter codec\n?:"
	read codec
	echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
	read pagename
	echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m "$name"\n\t\e[93mSeason:\e[33m "$season"\n\t\e[93mDescription:\e[33m "$description"\n\t\e[93mPurchase link:\e[33m "$site"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mGenre:\e[33m "$genre"\n\t\e[93mIMDB link: "$imdb"\n\t\e[93mCodec:\e[33m "$codec"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
	echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]; do
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
	done
	while [ "$correct" != "y" ]; do
		echo "TV Show"
		echo -e "\n\e[93mEnter title of show\n?:\e[33m"
		read name
		echo -e "\n\e[93mEnter season number\n?:\e[33m"
		read season
		echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
		read description
		echo -e "\e[93mEnter URL where show can be purchsed\n?:\e[33m"
		read site
		echo -e "\e[93mEnter rating\n?:\e[33m"
		read rating
		echo -e "\e[93mEnter genre\n?:\e[33m"
		read genre
		echo -e "\e[93mEnter IMDB URL\n?:\e[33m"
		read imdb
		echo -e "\e[93mEnter codec\n?:"
		read codec
		echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
		read pagename
		echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m "$name"\n\t\e[93mSeason:\e[33m "$season"\n\t\e[93mDescription:\e[33m "$description"\n\t\e[93mPurchase link:\e[33m "$site"\n\t\e[93mRating:\e[33m "$rating"\n\t\e[93mGenre:\e[33m "$genre"\n\t\e[93mIMDB link: "$imdb"\n\t\e[93mCodec:\e[33m "$codec"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]; do
			echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
			read correct
		done
	done
		echo -e "\e[93m\nEnter path to file\n?:\e[33m"
		read outFile
		exists
		echo -e "\e[90m"
		zip_n_split
		deccr
		export title="$name"
		export season="$season"
		export description="$description"
		export url="$site"
		export rating="$rating"
		export genre="$genre"
		export imdb="$imdb"
		export codec="$codec"
		export dlink="$ixio"
		export dlink2="$sprunge"
		export sparelink="$nixenc"
		export date=$(cat date)
		mo /exlineal/templates/temp_tv.mo > /exlineal/outfiles/tv/"$pagename".html	
		subf="tv"	
elif [ "$mediatype" = 3 ]; then
	echo "Game"
	echo -e "\n\e[93mName of the game\n?:\e[33m"
	read name
	echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
	read description
	echo -e "\e[93mEnter URL where game can be purchased\n?:\e[33m"
	read site
	echo -e "\e[93mEnter devs/studios of game\n?:\e[33m"
	read author
	echo -e "\e[93mPlatform of title\n?:\e[33m"
	read platform
	echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
	read pagename
	echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $name\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\e[93mDevs\\3\bstudios: "$author"\n\t\e[93mPlatform: "$platform"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
	echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]; do
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
	done
	while [ "$correct" != "y" ]; do
		echo "Game"
		echo -e "\n\e[93mName of the game\n?:\e[33m"
		read name
		echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
		read description
		echo -e "\e[93mEnter URL where game can be purchased\n?:\e[33m"
		read site
		echo -e "\e[93mEnter devs/studios of game\n?:\e[33m"
		read author
		echo -e "\e[93mPlatform of title\n?:\e[33m"
		read platform
		echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
		read pagename
		echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $name\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\e[93mDevs\\3\bstudios: "$author"\n\t\e[93mPlatform: "$platform"\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]; do
			echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
			read correct
		done
	done
	echo -e "\e[93m\nEnter path to file\n?:\e[33m"
	read outFile
	exists
	echo -e "\e[90m"
	zip_n_split
	deccr
	export title="$name"
	export description="$description"
	export url="$site"
	export devs="$author"
	export platform="$platform"
	export dlink="$ixio"
	export dlink2="$sprunge"
	export sparelink="$nixenc"
	export date=$(cat date)
	mo /exlineal/templates/temp_games.mo > /exlineal/outfiles/games/"$pagename".html
	subf="game"
elif [ "$mediatype" = 4 ]; then
	echo "Music"
	echo -e "\n\e[93mEnter ablum title\n?:\e[33m"
	read title
	echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
	read description
	echo -e "\e[93mEnter URL where album can be purchased\n?:\e[33m"
	read site
	echo -e "\e[93mEnter musician\n?:\e[33m"
	read author
	echo -e "\e[93mEnter format\n?:\e[33m"
	read format
	echo -e "\e[93mEnter genre\n?:\e[33m"
	read genre
	echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
	read pagename
	echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $title\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\n\t\e[93mMusician:\e[33m $author\n\t\e[93mFormat:\e[33m $format\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
	echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]; do
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
	done
	while [ "$correct" != "y" ]; do
		echo "Music"
		echo -e "\n\e[93mEnter ablum title\n?:\e[33m"
		read title
		echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
		read description
		echo -e "\e[93mEnter URL where album can be purchased\n?:\e[33m"
		read site
		echo -e "\e[93mEnter musician\n?:\e[33m"
		read author
		echo -e "\e[93mEnter format\n?:\e[33m"
		read format
		echo -e "\e[93mEnter genre\n?:\e[33m"
		read genre
		echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
		read pagename
		echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mName:\e[33m $title\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\n\t\e[93mMusician:\e[33m $author\n\t\e[93mFormat:\e[33m $format\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]; do
			echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
			read correct
		done
	done
	echo -e "\e[93m\nEnter path to file\n?:\e[33m"
	read outFile
	exists
	echo -e "\e[90m"
	zip_n_split
	deccr
	export title="$title"
	export description="$description"
	export url="$site"
	export musician="$author"
	export format="$format"
	export dlink="$ixio"
	export dlink2="$sprunge"
	export sparelink="$nixenc"
	export date=$(cat date)
	mo /exlineal/templates/temp_music.mo > /exlineal/outfiles/music/"$pagename".html
	subf="$music"
elif [ "$mediatype" = 5 ]; then
	echo "Book"
	echo -e "\e[93mEnter title\n?:\e[33m"
	read title
	echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
	read description
	echo -e "\e[93mEnter URL where book can be purchased\n?:\e[33m"
	read site
	echo -e "\e[93mEnter author\n?:\e[33m"
	read author
	echo -e "\e[93mEnter format\n?:\e[33m"
	read format
	echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
	read pagename
	echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m $title\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\n\t\e[93mAuthor:\e[33m $author\n\t\e[93mFormat:\e[33m $format\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
	echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
	read correct
	while [[ "$correct" != "y" && "$correct" != "n" ]]; do
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
	done
	while [ "$correct" != "y" ]; do
		echo "Book"
		echo -e "\e[93mEnter title\n?:\e[33m"
		read title
		echo -e "\e[93mEnter description (must be on one line)\n?:\e[33m"
		read description
		echo -e "\e[93mEnter URL where book can be purchased\n?:\e[33m"
		read site
		echo -e "\e[93mEnter author\n?:\e[33m"
		read author
		echo -e "\e[93mEnter format\n?:\e[33m"
		read format
		echo -e "\e[93mEnter filename for page. Usual filename rules apply.\n?:\e[33m"
		read pagename
		echo -e "\n\e[93mAre these details correct?\n\n\t\e[93mTitle:\e[33m $title\n\t\e[93mDescription:\e[33m $description\n\t\e[93mPurchase link:\e[33m $site\n\t\e[93mAuthor:\e[33m $author\n\t\e[93mFormat:\e[33m $format\n\t\e[93mPage name:\e[33m $pagename\n\t\e[93mMedia type:\e[33m ${table[$mediatype]}"
		echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
		read correct
		while [[ "$correct" != "y" && "$correct" != "n" ]]; do
			echo -e  "\e[93m\n(y\\3\bn)\n?:\e[33m "
			read correct
		done
	done
	echo -e "\e[93m\nEnter path to file\n?:\e[33m"
	read outFile
	exists
	echo -e "\e[90m"
	zip_n_split
	deccr
	export title="$title"
	export description="$description"
	export url="$site"
	export author="$author"
	export formats="$format"
	export dlink="$ixio"
	export dlink2="$sprunge"
	export sparelink="$nixenc"
	export date=$(cat date)
	mo /exlineal/templates/book.mo > /exlineal/outfiles/books/"$pagename".html
	subf="books"
else
	echo "Error at type-if"
fi
rm -f "$file".7z* &> /dev/null
rm 1 &> /dev/null
rm -f "$file"".0""*"
rm -f date links linkx moe moex moezlinkz.txt nixfil nixfil.b64 nixfil.enc nixfil.hex open openloadlinkz.txt tek tekniklinkz.txt 
echo -e "\e[32m\n\n\nPage for """$softname""" generated; saved to /exlineal/outfiles/"${tab2[$mediatype]}"/"$pagename".html\nEmail file to exlineal@protonmail.com to add.\n\n\e[37mFinished!"
