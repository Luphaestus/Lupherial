#!/bin/bash

function drawProgressBar() {
    local maxValue="$1"
    local currentValue="$2"
    local title="$3"

    local color=""

    if [[ $currentValue -eq $maxValue ]]; then
        color="\e[32m" # Green color for 100% progress
    else
        color="\e[95m" # Bright pink color for current progress
    fi

    local progress=$(( $currentValue * 100 / $maxValue ))
    local progressBarFinished=""
    local progressBarNotFinished=""

    for ((i=0;i<$progress;i+=2)); do
        progressBarFinished+="━"
    done
    
    if [[ $progress -eq 0 || $progress -eq 100 ]]; then
    	if [[ $progress -eq 0 ]]; then
    	   progressBarNotFinished+="━"
    	else
           progressBarFinished+="━"
        fi
    else
        progressBarNotFinished+="╺"
    fi

    for ((i=$progress+1;i<100;i+=2)); do
        progressBarNotFinished+="━"
    done

if [[ $currentValue -eq $maxValue ]]; then
    printf "│ %-40s ${color} %s\e[90m${progressBarNotFinished}   \e[97m%3d%% │\n" "$title" "$progressBarFinished" "$progress"
else
    printf "│ %-40s ${color} %s\e[90m${progressBarNotFinished}   \e[97m%3d%% │\r" "$title" "$progressBarFinished" "$progress"

fi

}

git  add .
override=false
github=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --override)
      override=true
      shift 1
      ;;
    --github)
      github=true
      shift 1
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ "$override" == false && -z $(git status --porcelain) ]]; then
  echo "Nothing to commit. Exiting."
  exit 0
fi
rm -r "./../log.txt" > ../log.txt 2>&1

echo "┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐"

REPO_OWNER="Luphaestus"
REPO_NAME="Lupherial"
GITHUB_TOKEN=$(cat ../credentials.txt)

drawProgressBar 3 0 "Syncing with Github:"
git pull origin > ../log.txt 2>&1
drawProgressBar 3 1 "Syncing with Github:"
git commit -m "Automatic Push" > ../log.txt 2>&1
drawProgressBar 3 2 "Syncing with Github:"
git push https://${REPO_OWNER}:${GITHUB_TOKEN}@github.com/${REPO_OWNER}/${REPO_NAME}.git main > ../log.txt 2>&1
drawProgressBar 3 3 "Syncing with Github:"

if $github; then
  echo "└──────────────────────────────────────────────────────────────────────────────────────────────────────┘"
  exit 0
fi
if [[ -z $(git status --porcelain) ]]; then
	drawProgressBar 3 0 "Removing old compiled directories: "
	rm -r -f "../bin/lupherial-linux/lupherial" > ../log.txt 2>&1
	drawProgressBar 3 1 "Removing old compiled directories: "
	rm -r -f "../bin/lupherial-macos/lupherial" > ../log.txt 2>&1
	drawProgressBar 3 2 "Removing old compiled directories: "
	rm -r -f "../bin/lupherial-windows/lupherial" > ../log.txt 2>&1
	drawProgressBar 3 3 "Removing old compiled directories: "

	drawProgressBar 3 0 "Coppying updated files:"
	cp -R "" "../bin/lupherial-linux" > ../log.txt 2>&1
	drawProgressBar 3 1 "Coppying updated files:"
	cp -R "" "../bin/lupherial-macos" > ../log.txt 2>&1
	drawProgressBar 3 2 "Coppying updated files:"
	cp -R "" "../bin/lupherial-windows" > ../log.txt 2>&1
	drawProgressBar 3 3 "Coppying updated files:"

	drawProgressBar 3 0 "Removing old compiled zips: "
	rm -r "../out/lupherial-linux.zip" > ../log.txt 2>&1
	drawProgressBar 3 1 "Removing old compiled zips: "
	rm -r "../out/lupherial-macos.zip" > ../log.txt 2>&1
	drawProgressBar 3 2 "Removing old compiled zips: "
	rm -r "../out/lupherial-windows.zip" > ../log.txt 2>&1
	drawProgressBar 3 3 "Removing old compiled zips: "


	drawProgressBar 3 0 "Ziping New Version:"
	zip -r "../out/lupherial-linux.zip" "../bin/lupherial-linux" > ../log.txt 2>&1
	drawProgressBar 3 1 "Ziping New Version:"
	zip -r "../out/lupherial-macos.zip" "../bin/lupherial-macos" > ../log.txt 2>&1
	drawProgressBar 3 2 "Ziping New Version:"
	zip -r "../out/lupherial-windows.zip" "../bin/lupherial-windows" > ../log.txt 2>&1
	drawProgressBar 3 3 "Ziping New Version:"
fi

#-------------------
drawProgressBar 5 1 "Creating new release:"
# Get the latest release information
latest_release=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest)
drawProgressBar 5 2 "Creating new release:"
# Get the current version number
current_version=$(echo $latest_release | jq -r '.tag_name')
drawProgressBar 5 3 "Creating new release:"
# Increment the version number
new_version=$(echo $current_version | awk -F. -v OFS=. '{$NF++;print}')
drawProgressBar 5 4 "Creating new release:"
# Create the new release
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
-H "Content-Type: application/json" \
-d '{"tag_name": "'"$new_version"'", "name": "Lupherial: Release '"$new_version"'", "body": "We are excited to announce that our top-down RPG game is entering a health and well-being competition! With our game, you can embark on a journey of mental wellness and discover the impact of mental health on your life. Our engaging gameplay and immersive storytelling will take you on a journey of self-discovery and empowerment as you learn how to overcome mental health challenges.\\nOne of the key features of our game is procedural generation, which ensures that every playthrough is unique and challenging. Additionally, our enemy pathfinding and resource gathering mechanics add an extra layer of depth and excitement to the gameplay experience.\\nWe believe that our game has the power to make a positive impact on the mental well-being of players. By playing our game, you can learn important skills and strategies for managing mental health challenges, while also enjoying a fun and engaging gaming experience. Download now and join us on this journey towards greater mental wellness!\\nNote: This action was done automatically, if you discover a bug please contact Lupheastus"}' \
https://api.github.com/repos/Luphaestus/$REPO_NAME/releases > ../log.txt 2>&1
drawProgressBar 4 0 "Creating new release:"
# Get the latest release ID
release_id=$(curl --silent --header "Authorization: token $GITHUB_TOKEN" \
  --url "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | jq '.id')
drawProgressBar 5 5 "Creating new release:"

echo "└──────────────────────────────────────────────────────────────────────────────────────────────────────┘"
# Create a release asset
curl --header "Authorization: token $GITHUB_TOKEN" \
  --header "Content-Type: application/zip" \
  --url "https://uploads.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$release_id/assets?name=lupherial-windows.zip" \
  --data-binary "@../out/lupherial-windows.zip" \
  | pv --quiet --wait


# Create a release asset
curl --header "Authorization: token $GITHUB_TOKEN" \
  --header "Content-Type: application/zip" \
  --url "https://uploads.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$release_id/assets?name=lupherial-linux.zip" \
  --data-binary "@../out/lupherial-linux.zip" \
  | pv --quiet --wait
 
# Create a release asset
curl --header "Authorization: token $GITHUB_TOKEN" \
  --header "Content-Type: application/zip" \
  --url "https://uploads.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$release_id/assets?name=lupherial-macos.zip" \
  --data-binary "@../out/lupherial-macos.zip" \
  | pv --quiet --wait
 
echo "Synced with github"
