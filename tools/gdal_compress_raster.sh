echo "🚀 GDAL Translating $1"

gdal_translate -ot Float32 -co COMPRESS=DEFLATE -co PREDICTOR=3 -co ZLEVEL=9 -co BIGTIFF=YES $1 $2

if [ $? -eq 0 ]; then
    echo "✅ GDAL Translate successful"
else
    echo "❌ GDAL Translate failed"
fi