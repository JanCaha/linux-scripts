# Check if the directory exists and create it if it does not
if (Sys.getenv("R_LIBS_USER") != "") {
    print(paste("R_LIBS_USER is set to: ", Sys.getenv("R_LIBS_USER")))

    if (!dir.exists(Sys.getenv("R_LIBS_USER"))) {
        dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)
        print("\tDirectory created")
    }
    {
        print("\tDirectory already exists")
    }
}
else {
    print("R_LIBS_USER is not set")
}

# Install the required packages
install.packages(c(
    "tidyverse", 
    "tidymodels",
    "tidyclust",
    "here",
    "shiny",
    "terra", 
    "sf", 
    "sabre",
    "SpatialKDE",
    "devtools",
    "remotes",
    "easystats"
    ),
    lib=Sys.getenv("R_LIBS_USER")
)