# Find Your Zotero Group ID

Retrieves a list of your Zotero group libraries and their IDs. Use this
function to find the correct `group_id` parameter for
[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md)
when working with group libraries.

## Usage

``` r
find_zotero_group(
  group_name = NULL,
  user_id = Sys.getenv("ZOTERO_USER_ID"),
  api_key = Sys.getenv("ZOTERO_API_KEY")
)
```

## Arguments

- group_name:

  Character string or NULL. Optional group name to filter results. If
  provided, only returns groups matching this name (case-sensitive). If
  `NULL` (default), returns all groups you have access to.

- user_id:

  Character string or numeric. Your Zotero user ID. Default reads from
  the `ZOTERO_USER_ID` environment variable. Find your ID at
  https://www.zotero.org/settings/security

- api_key:

  Character string. Your Zotero API key. Default reads from the
  `ZOTERO_API_KEY` environment variable. Get your key from
  https://www.zotero.org/settings/keys

## Value

A data frame (tibble) with columns:

- group_id:

  Character. The group library ID to use in API calls

- name:

  Character. The human-readable group name

The data frame is also printed to the console for easy viewing.

## Authentication

This function requires:

- A valid Zotero API key with group library access

- Your Zotero user ID

Set these up using
[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md).

## Usage

Once you've found your group ID, use it in
[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md):

    # Find your group
    groups <- find_zotero_group()
    # Note the group_id for your desired group

    # Use it to fetch sources
    sources <- get_zotero_sources(
      "Collection Path",
      group_id = 1234567  # Your group_id
    )

## See also

[`get_zotero_sources`](https://verbose-guacamole-l18vr83.pages.github.io/reference/get_zotero_sources.md)
for fetching sources from a group library

[`setup_zotero_credentials`](https://verbose-guacamole-l18vr83.pages.github.io/reference/setup_zotero_credentials.md)
for configuring API access

## Examples

``` r
if (FALSE) { # \dontrun{
# List all groups you belong to
find_zotero_group()

# Find a specific group
find_zotero_group(group_name = "CRUK Research Team")

# With explicit credentials (not recommended - use .Renviron instead)
find_zotero_group(
  user_id = "1234567",
  api_key = "a1b2c3d4e5f6g7h8i9j0"
)

# Example output:
# # A tibble: 3 × 2
#   group_id name
#   <chr>    <chr>
# 1 6230705  CRUK Cancer Intelligence
# 2 1234567  Research Collaboration
# 3 9876543  Statistics Working Group
} # }
```
