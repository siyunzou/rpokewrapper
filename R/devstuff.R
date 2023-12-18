library(devtools)
library(usethis)
library(desc)
#devtools::install_github("r-lib/desc")


# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "rpokewrapper")

#Set your name
my_desc$set("Authors@R", "person('Siyun', 'Zou', email = 'sz3351@nyu.edu', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "My Pokemon API Wrapper")
# The description of your package
my_desc$set(Description = "This a Pokemon API Wrapper that assist with pulling some statistics from the Pokemon API.")
# The urls
my_desc$set("URL", "http://this")
my_desc$set("BugReports", "http://that")
# Save everything
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license()

# Get the dependencies
use_package("httr")
use_package("jsonlite")
use_package("curl")
use_package("attempt")
use_package("purrr")

# Clean your description
use_tidy_description()

devtools::check()
# Then build it with:
devtools::build()
