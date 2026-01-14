ctest --test-dir build-qt -N | grep -i 'providerconnection.*gpkg'

ctest --test-dir build-qt -R '^PyQgsProviderConnectionGpkg$' --output-on-failure -V