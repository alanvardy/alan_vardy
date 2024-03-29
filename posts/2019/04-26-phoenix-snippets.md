==title==
Visual Studio Code Snippets for Phoenix

==author==
Alan Vardy

==footer==

==description==
A dump of my current settings.json

==tags==
vscode, phoenix, elixir

==body==
There is currently no Phoenix snippets for VS Code so I have made some of my own. You will need to add this to a json file and make sure that your html.eex file is recognized by VS Code properly.

```json
{
 // Place your snippets for HTML (Eex) here. Each snippet is defined under a snippet name and has a prefix, body and
 // description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
 // $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the
 // same ids are connected.
 // Example:
 // "Print to console": {
 //  "prefix": "log",
 //  "body": [
 //   "console.log('$1');",
 //   "$2"
 //  ],
 //  "description": "Log output to console"
 // }
 "link": {
  "prefix": "link(phx)",
  "body": ["<%= link \"${1:name}\", to: Routes.${2:path}_path(@conn, :${3:page}${4:, item?}) %>"],
  "description": "Generates a link to the given URL"
 },
 "button": {
  "prefix": "button(phx)",
  "body": ["<%= button \"${1:name}\", to: \"${2:path}\" %>"],
  "description": "Generates a button"
 },
 "form_for": {
  "prefix": "form_for(phx)",
  "body": [
   "<%= form_for @changeset, Routes.${1:object}_path(@conn, :${2:create}), [], fn f -> %>",
   "<%= if @changeset.action do %>",
   "<div class=\"alert alert-danger\">",
   "<p>Oops, something went wrong! Please check the errors below</p>",
   "</div>",
   "<% end %>",
   "$0",
   "<%= submit \"Create $1\" %>",
   "<% end %>",
  ],
  "description": "Basic form"
 },
 "inputs_for": {
  "prefix": "inputs_for(phx)",
  "body": [
   "<%= inputs_for f, :${1:table}, fn f${2:t} -> %>",
   "$3",
   "<% end %>"
  ],
  "description": "Nested inputs for forms"
 },
 "checkbox": {
  "prefix": "checkbox(phx)",
  "body": [
   "<%= checkbox ${1:f}, :${2:field}, ${3:[]} %>",
  ],
  "description": "Form checkbox"
 },
 "color_input": {
  "prefix": "color_input(phx)",
  "body": [
   "<%= color_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Form color input"
 },
 "date_input": {
  "prefix": "date_input(phx)",
  "body": [
   "<%= date_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Form date input"
 },
 "date_select": {
  "prefix": "date_select(phx)",
  "body": [
   "<%= date_select ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Form date select"
 },
 "datetime_local_input": {
  "prefix": "datetime_local_input(phx)",
  "body": [
   "<%= datetime_local_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Form datetime input"
 },
 "datetime_select": {
  "prefix": "datetime_select(phx)",
  "body": [
   "<%= datetime_select ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates select tags for datetime."
 },
 "email_input": {
  "prefix": "email_input(phx)",
  "body": [
   "<%= email_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates an email input."
 },
 "file_input": {
  "prefix": "file_input(phx)",
  "body": [
   "<%= file_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a file input."
 },
 "hidden_input": {
  "prefix": "hidden_input(phx)",
  "body": [
   "<%= hidden_input ${1:f}, :${2:field}, ${3:[]} %>",
  ],
  "description": "Generates a hidden input."
 },
 "number_input": {
  "prefix": "number_input(phx)",
  "body": [
   "<%= number_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a number input."
 },
 "password_input": {
  "prefix": "password_input(phx)",
  "body": [
   "<%= password_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a number input."
 },
 "range_input": {
  "prefix": "range_input(phx)",
  "body": [
   "<%= range_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a range input."
 },
 "search_input": {
  "prefix": "search_input(phx)",
  "body": [
   "<%= search_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a search input."
 },
 "telephone_input": {
  "prefix": "telephone_input(phx)",
  "body": [
   "<%= telephone_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a telephone input."
 },
 "time_input": {
  "prefix": "time_input(phx)",
  "body": [
   "<%= time_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a time input."
 },
 "url_input": {
  "prefix": "url_input(phx)",
  "body": [
   "<%= url_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates an url input."
 },
 "time_select": {
  "prefix": "time_select(phx)",
  "body": [
   "<%= time_select ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a time input."
 },
 "text_input": {
  "prefix": "text_input(phx)",
  "body": [
   "<%= text_input ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a text input."
 },
 "text_area": {
  "prefix": "text_area(phx)",
  "body": [
   "<%= text_area ${1:f}, :${2:field}, ${3:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a textarea input."
 },
 "reset": {
  "prefix": "reset(phx)",
  "body": [
   "<%= reset(\"${1:Label}\", ${2:[]} %>",
  ],
  "description": "Generates a reset input to reset all the form fields to their original state."
 },
 "radio_button": {
  "prefix": "radio_button(phx)",
  "body": [
   "<%= radio_button ${1:f}, :${2:field}, ${3:value}, ${4:[]} %>",
  ],
  "description": "Generates a radio button."
 },
 "select": {
  "prefix": "select(phx)",
  "body": [
   "<%= select ${1:f}, :${2:field}, ${3:Enum}, ${4:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a select tag with the given Enum."
 },
 "multiple_select": {
  "prefix": "multiple_select(phx)",
  "body": [
   "<%= multiple_select ${1:f}, :${2:field}, ${3:Enum}, ${4:[]} %>",
   "<%= error_tag ${1:f}, :${2:field} %>",
  ],
  "description": "Generates a select tag with the given Enum."
 },
 "label": {
  "prefix": "label(phx)",
  "body": [
   "<%= label ${1:f}, :${2:field}, ${3:[]} %>",
  ],
  "description": "Generates a label tag."
 },
 "humanize": {
  "prefix": "humanize(phx)",
  "body": [
   "<%= humanize ${1:atom} %>",
  ],
  "description": "Converts an attribute/form field into its humanize version."
 },
}
```
