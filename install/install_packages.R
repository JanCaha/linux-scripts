default_lib_path <- .libPaths()[1]

# Check if the directory exists and create it if it does not
if (Sys.getenv("R_LIBS_USER") != "") {
    print(paste("R_LIBS_USER is set to: ", Sys.getenv("R_LIBS_USER")))

    if (!dir.exists(Sys.getenv("R_LIBS_USER"))) {
        dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)
        print("\tDirectory created")
    } else {
        print("\tDirectory already exists")
    }

    default_lib_path <- Sys.getenv("R_LIBS_USER")
} else {
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
    lib=default_lib_path
)