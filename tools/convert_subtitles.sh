echo "🚀 Converting $1"

iconv -f CP1250 -t UTF-8 $1 > $1

if [ $? -eq 0 ]; then
    echo "✅ Conversion successful"
else
    echo "❌ Conversion failed"
fi