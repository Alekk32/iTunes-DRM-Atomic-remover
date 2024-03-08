#!/bin/zsh

echo ""
echo "This will remove iTunes DRM tags with personal information from m4a and m4v files in this folder and all subfolders."
echo "Unfortunately, this will remove album covers from music video files (m4v)."
echo "You need to put ffmpeg file in this folder to proceed."
echo ""

skipConfirmation=""
current_dir=$(dirname "$0")

files=$(find "$current_dir" -type f \( -name "*.m4a" -o -name "*.m4v" \))

IFS=$'\n'
for file in $files; do
	if [[ ! -n $skipConfirmation ]]; then
		echo -n "To skip confirmation press R and ENTER or just press ENTER to continue: "
		read confirmation
		if [[ "$confirmation" == [Rr] ]]; then
			skipConfirmation=true
		fi
	fi

	echo "Processing file: $file"
	./ffmpeg -i "$file" -metadata encoder="" -map_metadata 0 -fflags +bitexact -c copy "${file}_temp.m4a"

	if [[ $? -ne 0 ]]; then
		echo "Error converting file: $file"
		echo -n "Do you want to continue processing other files? (Y/N): "
		read continueOnError
		if [[ "$continueOnError" == [Nn] ]]; then
			break
		fi
	fi

	mv "${file}_temp.m4a" "$file"
	echo ""
	echo "$file file processing completed."
	echo ""
done

echo "Script execution completed."
