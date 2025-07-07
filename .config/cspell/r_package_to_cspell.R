# Check if package is available#' Export R Package Function Names to CSpell Dictionary
#'
#' This function extracts all function names from an R package and writes them
#' to a text file that can be used as a custom dictionary for CSpell.
#'
#' @param package_name Character string. Name of the R package to extract functions from.
#' @param file_path Character string. Path where the dictionary file should be written.
#' @param append Logical. Whether to append to existing file (TRUE) or overwrite (FALSE).
#'
#' @return Invisible TRUE if successful, stops with error if package not found.
#'
#' @examples
#' \dontrun{
#' # Create dictionary for base R functions
#' package_to_cspell_dict("base", "base_functions.txt")
#'
#' # Create dictionary for ggplot2 functions
#' package_to_cspell_dict("ggplot2", "ggplot2_functions.txt")
#'
#' # Append to existing dictionary
#' package_to_cspell_dict("dplyr", "my_dictionary.txt", append = TRUE)
#' }
#'
#' @export
package_to_cspell_dict <- function(package_name, file_path = "~/.config/cspell/r-functions.txt", append = TRUE) {
  # Validate inputs
  

  if (!is.character(package_name) || length(package_name) != 1) {
    stop("package_name must be a single character string")
  }

  if (!is.character(file_path) || length(file_path) != 1) {
    stop("file_path must be a single character string")
  }

  if (!is.logical(append) || length(append) != 1) {
    stop("append must be a single logical value")
  }

  # Create directory if it doesn't exist
  dir_path <- dirname(file_path)
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
  }
  if (!requireNamespace(package_name, quietly = TRUE)) {
    stop(paste("Package", package_name, "is not installed or available"))
  }

  # Get the package namespace
  tryCatch(
    {
      pkg_ns <- asNamespace(package_name)
    },
    error = function(e) {
      stop(paste("Could not access namespace for package", package_name))
    }
  )

  # Extract all exported function names
  exported_functions <- getNamespaceExports(package_name)

  # Get all objects in the namespace and filter for functions
  all_objects <- ls(pkg_ns, all.names = TRUE)
  all_functions <- character(0)

  for (obj_name in all_objects) {
    tryCatch(
      {
        obj <- get(obj_name, envir = pkg_ns)
        if (is.function(obj)) {
          all_functions <- c(all_functions, obj_name)
        }
      },
      error = function(e) {
        # Skip objects that can't be accessed
        NULL
      }
    )
  }

  # Combine exported and internal functions, remove duplicates
  all_function_names <- unique(c(exported_functions, all_functions))

  # Remove any names that are not valid identifiers or contain special characters
  # that might cause issues in spell checking
  valid_names <- all_function_names[grepl("^[a-zA-Z][a-zA-Z0-9._]*$", all_function_names)]

  # Create the dictionary content
  # Include the package name itself
  dictionary_words <- unique(c(package_name, valid_names))

  # Sort alphabetically for consistent output
  dictionary_words <- sort(dictionary_words)

  # Read existing content if appending
  existing_words <- character(0)
  if (append && file.exists(file_path)) {
    tryCatch(
      {
        existing_content <- readLines(file_path, warn = FALSE)
        # Remove any empty lines or comments
        existing_words <- existing_content[nzchar(existing_content) & !grepl("^#", existing_content)]
      },
      error = function(e) {
        warning("Could not read existing file, will overwrite instead")
      }
    )
  }

  # Combine with existing words if appending and deduplicate
  if (length(existing_words) > 0) {
    dictionary_words <- unique(c(existing_words, dictionary_words))
  }

  # Final deduplication and sorting
  dictionary_words <- unique(dictionary_words)
  dictionary_words <- sort(dictionary_words)

  # Create file content
  file_content <- dictionary_words

  # Write to file
  tryCatch(
    {
      writeLines(file_content, file_path)
      cat("Successfully wrote", length(dictionary_words), "words to", file_path, "\n")
      cat("Package name and", length(dictionary_words) - 1, "function names included\n")
    },
    error = function(e) {
      stop(paste("Could not write to file:", e$message))
    }
  )

  invisible(TRUE)
}
