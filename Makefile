townsend-na:=https://www.shadedreliefarchive.com/download/USA_Townsend.zip
townsend-europe:=https://www.shadedreliefarchive.com/download/Europe.zip
townsend-africa:=https://www.shadedreliefarchive.com/download/Africa_Townsend.zip
townsend-oceania:=https://www.shadedreliefarchive.com/download/Australia_Townsend.zip
harrison:=https://www.shadedreliefarchive.com/download/USA_Harrison.zip
schutzler:=https://www.shadedreliefarchive.com/download/USA_Schutzler.zip
nelson:=https://www.shadedreliefarchive.com/download/Alaska_Nelson.zip
kuzdro-asia:=https://www.shadedreliefarchive.com/download/Southeast_Asia.zip
proj-us-27:=+proj=aea +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +lat_0=23 +datum=NAD27 +no_defs
proj-us-83:=+proj=aea +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +lat_0=23 +datum=NAD83 +no_defs
proj-alaska:=+proj=aea +lon_0=-154 +lat_1=55 +lat_2=65 +lat_0=50 +datum=NAD83 +no_defs
proj-europe:=+proj=laea +lon_0=21 +lat_0=51.5 +datum=WGS84 +no_defs
proj-africa:=+proj=laea +lon_0=20 +lat_0=0 +datum=WGS84 +no_defs
proj-oceania:=+proj=lcc +lon_0=140 +lat_0=0 +lat_1=-7.4 +lat_2=-38.2 +datum=WGS84 +no_defs
proj-asia:=+proj=merc +lat_ts=0 +lon_0=110

all: \
	clean \
	init \
	download \
	process \
	image \
	compress ; \

clean:
	rm -rf tmp/
	rm -rf images/

init:
	-mkdir tmp/
	-mkdir images/

download:
	curl $(townsend-na) -o tmp/townsend-na.zip ; \
	unzip -o tmp/townsend-na.zip -d tmp/ ; \
	rm -f tmp/townsend-na.zip ; \

	curl $(townsend-europe) -o tmp/townsend-eu.zip ; \
	unzip -o tmp/townsend-eu.zip -d tmp/ ; \
	rm -f tmp/townsend-eu.zip ; \

	curl $(townsend-africa) -o tmp/townsend-af.zip ; \
	unzip -o tmp/townsend-af.zip -d tmp/ ; \
	rm -f tmp/townsend-af.zip ; \

	curl $(townsend-oceania) -o tmp/townsend-oc.zip ; \
	unzip -o tmp/townsend-oc.zip -d tmp/ ; \
	rm -f tmp/townsend-oc.zip ; \

	curl $(harrison) -o tmp/harrison.zip ; \
	unzip -o tmp/harrison.zip -d tmp/ ; \
	rm -f tmp/harrison.zip ; \

	curl $(schutzler) -o tmp/schutzler.zip ; \
	unzip -o tmp/schutzler.zip -d tmp/ ; \
	rm -f tmp/schutzler.zip ; \

	curl $(nelson) -o tmp/nelson.zip ; \
	unzip -o tmp/nelson.zip -d tmp/ ; \
	rm -f tmp/nelson.zip ; \

	curl $(kuzdro-asia) -o tmp/kuzdro.zip ; \
	unzip -o tmp/kuzdro.zip -d tmp/ ; \
	rm -f tmp/kuzdro.zip ; \

process:
	gdalwarp -s_srs '${proj-us-27}' -t_srs EPSG:4326 tmp/USA_Townsend/USA_Townsend.tif tmp/townsend-na.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-europe}' -t_srs EPSG:4326 tmp/Europe/Europe.tif tmp/townsend-europe.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-africa}' -t_srs EPSG:4326 tmp/Africa_Townsend/Africa_Townsend.tif tmp/townsend-africa.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-oceania}' -t_srs EPSG:4326 tmp/Australia_Townsend/australia_townsend.tif tmp/townsend-oceania.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-us-83}' -t_srs EPSG:4326 tmp/USA_Harrison/usa_harrison.tif tmp/harrison.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-us-83}' -t_srs EPSG:4326 tmp/USA_Shutzler/usa_schutzler.tif tmp/schutzler.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-alaska}' -t_srs EPSG:4326 tmp/Alaska_Nelson/alaska_nelson.tif tmp/nelson.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-asia}' -t_srs EPSG:4326 tmp/Southeast_Asia/Southeast_Asia.tif tmp/kuzdro.tif -dstalpha -overwrite -q ; \

image:
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-na.tif images/townsendna.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-europe.tif images/townsendeurope.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-africa.tif images/townsendafrica.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-oceania.tif images/townsendoceania.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/harrison.tif images/harrison.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/schutzler.tif images/schutzler.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/nelson.tif images/nelson.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/kuzdro.tif images/kuzdro.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \

compress:
	mogrify -format png -resize 25% images/townsendna.png ; \
	mogrify -format png -resize 35% images/townsendeurope.png ; \
	mogrify -format png -resize 45% images/townsendafrica.png ; \
	mogrify -format png -resize 100% images/townsendoceania.png ; \
	mogrify -format png -resize 35% images/harrison.png ; \
	mogrify -format png -resize 35% images/schutzler.png ; \
	mogrify -format png -resize 100% images/nelson.png ; \
	mogrify -format png -resize 25% images/kuzdro.png ; \

tile:
	rio pmtiles tmp/townsend-na.tif tmp/townsend-na.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/townsend-europe.tif tmp/townsend-europe.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/townsend-africa.tif tmp/townsend-africa.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/townsend-oceania.tif tmp/townsend-ocenia.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/harrison.tif tmp/harrison.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/schutzler.tif tmp/schutzler.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/nelson.tif tmp/nelson.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/kuzdro.tif tmp/kuzdro.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \

join:
	tile-join -o tmp/rasters.pmtiles -pk --force \
	tmp/townsend-na.pmtiles \
	tmp/townsend-europe.pmtiles \
	tmp/harrison.pmtiles \
	tmp/schutzler.pmtiles \
	tmp/kuzdro.pmtiles ; \

