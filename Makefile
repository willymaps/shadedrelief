townsend-na:=https://www.shadedreliefarchive.com/download/USA_Townsend.zip
townsend-europe:=https://www.shadedreliefarchive.com/download/Europe.zip
harrison:=https://www.shadedreliefarchive.com/download/USA_Harrison.zip
schutzler:=https://www.shadedreliefarchive.com/download/USA_Schutzler.zip
kuzdro-asia:=https://www.shadedreliefarchive.com/download/Southeast_Asia.zip
proj-27:=+proj=aea +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +lat_0=23 +datum=NAD27 +no_defs
proj-83:=+proj=aea +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +lat_0=23 +datum=NAD83 +no_defs
proj-europe:=+proj=laea +lon_0=21 +lat_0=51.5 +datum=WGS84 +no_defs
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
	curl $(townsend-na) -o tmp/townsend.zip ; \
	unzip -o tmp/townsend.zip -d tmp/ ; \
	rm -f tmp/townsend.zip ; \

	curl $(townsend-europe) -o tmp/townsend.zip ; \
	unzip -o tmp/townsend.zip -d tmp/ ; \
	rm -f tmp/townsend.zip ; \

	curl $(harrison) -o tmp/harrison.zip ; \
	unzip -o tmp/harrison.zip -d tmp/ ; \
	rm -f tmp/harrison.zip ; \

	curl $(schutzler) -o tmp/schutzler.zip ; \
	unzip -o tmp/schutzler.zip -d tmp/ ; \
	rm -f tmp/schutzler.zip ; \

	curl $(kuzdro-asia) -o tmp/kuzdro.zip ; \
	unzip -o tmp/kuzdro.zip -d tmp/ ; \
	rm -f tmp/kuzdro.zip ; \

process:
	gdalwarp -s_srs '${proj-27}' -t_srs EPSG:4326 tmp/USA_Townsend/USA_Townsend.tif tmp/townsend-na.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-europe}' -t_srs EPSG:4326 tmp/Europe/Europe.tif tmp/townsend-europe.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-83}' -t_srs EPSG:4326 tmp/USA_Harrison/usa_harrison.tif tmp/harrison.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-83}' -t_srs EPSG:4326 tmp/USA_Shutzler/usa_schutzler.tif tmp/schutzler.tif -dstalpha -overwrite -q ; \
	gdalwarp -s_srs '${proj-asia}' -t_srs EPSG:4326 tmp/Southeast_Asia/Southeast_Asia.tif tmp/kuzdro.tif -dstalpha -overwrite -q ; \

image:
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-na.tif images/townsendna.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/townsend-europe.tif images/townsendeurope.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/harrison.tif images/harrison.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/schutzler.tif images/schutzler.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \
	gdalwarp -t_srs EPSG:3857 -ot Byte -of png tmp/kuzdro.tif images/kuzdro.png -dstalpha -overwrite -q --config GDAL_PAM_ENABLED false ; \

compress:
	mogrify -format png -resize 35% images/*.png ; \

tile:
	rio pmtiles tmp/townsend-na.tif tmp/townsend-na.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/townsend-europe.tif tmp/townsend-europe.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/harrison.tif tmp/harrison.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/schutzler.tif tmp/schutzler.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \
	rio pmtiles tmp/kuzdro.tif tmp/kuzdro.pmtiles --format PNG --zoom-levels 0..8 --resampling bilinear ; \

join:
	tile-join -o tmp/rasters.pmtiles -pk --force \
	tmp/townsend-na.pmtiles \
	tmp/townsend-europe.pmtiles \
	tmp/harrison.pmtiles \
	tmp/schutzler.pmtiles \
	tmp/kuzdro.pmtiles ; \

