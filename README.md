# Encrypted Personal Diary on Linux
An Encrypted Diary writer that writes entries based on the date provided (Today's entry if no date specified). It exports all the entries to a pdf (The Diary) file. Entries can be marked up in HTML, then styled using CSS and even programmatically created using JS.


## Installation
PreInstallation: The user should have his own gpg key to be used for diary. The program needs the GPG user ID to be provided during installation.
run the `./install.sh` script provided
If installation goes wrong (Most probably wrong GPG user ID provided). run `./uninstall.sh` to undo installation.

## Usage
```
diary   write [ DD MM YYYY ]
        view [ html ]
        edit ( header | footer | style | script )
        genLoop [ <seconds> ]
```
- `write` writes/edits entries to the diary, it takes the date of which entries are to written/edited. If no date is provided current date is assumed.
- `view`
    * If no options are provided: Opens the diary pdf
    * If `html` is provided:      Opens the raw diary HTML in a browser (can be used to debug CSS styling and dynamic JS elements)
- `edit`
    * `header`  Opens markup file for how the diary pdf starts
    * `footer`  Opens markup file for how the diary pdf ends
    * `style`   Add your css styling here
    * `script`  Write your programmatic generation of diary content (JavaScript) here
- `genLoop` Stands for "Diary Generation Loop". Generates diary every <seconds> seconds. [Use along `diary view` & `diary write [ DD MM YYYY]` for live diary writing i.e. diary is generated every <second> seconds. thus all changes saved in the editor will be loaded every <second> seconds (Hint: Multiple diary commands can be invoked in different terminal tabs/sessions at the same time) ]

## Dependencies
- `gpg` for Encryption
- `wkhtmltopdf` for html markup of diary
- `tidy` for Auto-Formatting of HTML Markup
