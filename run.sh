#!/bin/bash

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Roy van der Veen <roy@ijsco-media.nl> wrote this file. As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------

# News sources. If you add one, keep in mind to bump the random modulus.

TITLE_CNN=$(curl -s http://rss.cnn.com/rss/cnn_latest.rss | xmllint --nocdata --xpath '/rss/channel/item[1]/description/text()' -)
TITLE_BBC=$(curl -s http://feeds.bbci.co.uk/news/world/rss.xml | xmllint --nocdata --xpath '/rss/channel/item[1]/title/text()' -)
TITLE_DUTCHNEWS=$(curl -s https://www.dutchnews.nl/feed/ | xmllint --nocdata --xpath '/rss/channel/item[1]/title/text()' -)
TITLE_9GAG=$(curl -s http://9gagrss.com/feed/ | xmllint --nocdata --xpath '/rss/channel/item[1]/title/text()' -)
TITLE_REDDIT=$(curl -s 'https://www.reddit.com/r/nottheonion.rss' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: text/html,applcation/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -H 'Connection: keep-alive' -H 'TE: trailers' | sed 's/<title>/\n<title>/g' | sed 's/<\/title>/<\/title>\n/g' | grep -Po '<title>.*</title>' | sed 's/<title>//g' | sed 's/<\/title>//g' | sed -n '2p')
TITLE_REDDIT_GAMING=$(curl -s 'https://www.reddit.com/r/gaming.rss' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: text/html,applcation/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -H 'Connection: keep-alive' -H 'TE: trailers' | sed 's/<title>/\n<title>/g' | sed 's/<\/title>/<\/title>\n/g' | grep -Po '<title>.*</title>' | sed 's/<title>//g' | sed 's/<\/title>//g' | sed -n '2p')
TITLE_ONION=$(curl -s https://www.theonion.com/rss | xmllint --nocdata --xpath '/rss/channel/item[1]/title/text()' -)
TITLE_HACKADAY=$(curl -s https://hackaday.com/feed/ | xmllint --nocdata --xpath '/rss/channel/item[1]/title/text()' -)

set -e

ARR[0]=$TITLE_CNN
ARR[1]=$TITLE_BBC
ARR[2]=$TITLE_DUTCHNEWS
ARR[3]=$TITLE_9GAG
ARR[4]=$TITLE_REDDIT
ARR[5]=$TITLE_REDDIT_GAMING
ARR[6]=$TITLE_ONION
ARR[7]=$TITLE_HACKADAY

RAND_TITLE=$[ $RANDOM % 8 ]
echo $RAND_TITLE

echo ${ARR[0]}
echo ${ARR[1]}
echo ${ARR[2]}
echo ${ARR[3]}
echo ${ARR[4]}
echo ${ARR[5]}
echo ${ARR[6]}
echo ${ARR[7]}

PREFIX_ARR[0]="("
PREFIX_ARR[1]="Baroque-style scene with ("
PREFIX_ARR[2]="Anime scene with ("
PREFIX_ARR[3]="Gothic painting of ("
PREFIX_ARR[4]="Documentary-style photography of ("
PREFIX_ARR[5]="Selfie with ("
PREFIX_ARR[6]="Futuristic style photo of ("

RAND_PREFIX=$[ $RANDOM % 7 ]
echo $RAND_PREFIX

SUFFIX_ARR[0]=")"
SUFFIX_ARR[1]="). Concept art, detail, sharp focus"
SUFFIX_ARR[2]="). Calm, realistic, Volumetric Lighting"
SUFFIX_ARR[3]="). Clear definition, unique and one-of-a-kind piece."
SUFFIX_ARR[4]="). Gloomy, dramatic, stunning, dreamy"
SUFFIX_ARR[5]="). Anime, cartoon"

RAND_SUFFIX=$[ $RANDOM % 6 ]
echo $RAND_SUFFIX

NEG="ugly, tiling, poorly drawn hands, poorly drawn feet, poorly drawn face, out of frame, extra limbs, disfigured, deformed, body out of frame, bad anatomy, watermark, signature, cut off, low contrast, underexposed, overexposed, bad art, beginner, amateur, distorted face, blurry, draft, grainy"

RPI=""
if [[ -f "/sys/firmware/devicetree/base/model" ]]; then
    RPI="--rpi"
fi

echo $RPI

TITLE=${ARR[$RAND_TITLE]}
SUFFIX=${SUFFIX_ARR[$RAND_SUFFIX]}
PREFIX=${PREFIX_ARR[$RAND_PREFIX]}

TIMESTAMP=$(date "+%s")
DIR=$(pwd)

echo $DIR
echo $TITLE
echo $TIMESTAMP

PROMPT=${PREFIX}${TITLE}${SUFFIX}

# Run stable diffusion
${DIR}/OnnxStream/src/build/sd --models-path ${DIR}/weights --steps 28 $RPI --neg-prompt "$NEG" --prompt "$PROMPT" && cp result.png "arts/result-$TIMESTAMP.png"

echo "$TITLE" >> "arts/result-$TIMESTAMP.txt"
echo "$PROMPT" >> "arts/result-$TIMESTAMP.txt"
echo "$NEG" >> "arts/result-$TIMESTAMP.txt"

