SERIESPATH=./series
PATCHESPATH=./patches
for SERIES in `ls $SERIESPATH` ; do
	#echo $SERIES
	for PATCH in `cat $SERIESPATH/$SERIES`; do
		#echo $PATCH
		if [ ! `find $PATCHESPATH -name $PATCH` ]; then
			echo "$SERIESPATH/$SERIES: patch $PATCH was not found !"
		fi
	done
done
