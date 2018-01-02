"""
Original Author: SilentSpike (https://github.com/SilentSpike)
Modified: Dorbedo for TFAR

The functions searches all functions headers and creates an documentation for public functions

Supported header sections:
 - Name (the function name)
 - Author(s) (with description below)
 - Arguments
 - Return Value
 - Example(s)
 - Public (by default function will only be documented if set to "Yes")

EXAMPLES
    document_functions core --debug
        Crawl only functions in addons/core and only reports debug messages.

"""
#!/usr/bin/python3
# -*- coding: utf-8 -*-
# pylint: disable=W0702

import os
import sys
import re
import argparse

class FunctionFile:
    def __init__(self, directory="."):
        self.directory = directory

        # False unless specified in processing
        self.debug = False

        # Empty until imported from file
        self.path = ""
        self.header = ""

        # Defaults until header is processed
        self.public = False
        self.authors = []
        self.description = ""
        self.arguments = []
        self.return_value = []
        self.example = ""

        # Filepath should only be logged once
        self.logged = False

    def import_header(self, file_path):
        self.path = file_path

        with open(file_path) as file:
            code = file.read()

        header_match = re.match(r"#include\s\"script_component.hpp\"\n\n\s*/\*.+?\*/", code, re.S)
        if header_match:
            self.header = header_match.group(0)
        else:
            self.feedback("Missing header", 3)

    def has_header(self):
        return bool(self.header)

    def process_header(self, debug=False):
        # Detailed debugging occurs here so value is set
        self.debug = debug

        # Preemptively cut away the comment characters (and leading/trailing whitespace)
        self.header_text = "\n".join([x[3:].strip() for x in self.header.splitlines()])

        # Split the header into expected sections
        self.sections = re.split(r"^(Name|Author|Argument|Return Value|Example|Public)s?:\s?", self.header_text, 0, re.M)

        # If public section is missing we can't continue
        public_raw = self.get_section("Public")
        if not public_raw:
            self.feedback("Public value undefined", 3)
            return

        # Determine whether the header is public
        self.public = self.process_public(public_raw)

        # Don't bother to process the rest if private
        # Unless in debug mode
        if not self.public and not self.debug:
            return

        # Retrieve the raw sections text for processing
        author_raw = self.get_section("Author")
        arguments_raw = self.get_section("Argument")
        return_value_raw = self.get_section("Return Value")
        example_raw = self.get_section("Example")
        name_raw = self.get_section("Name")

        # Author and description are stored in first section
        if author_raw:
            self.authors = self.process_author(author_raw)
            self.description = self.process_description(author_raw)

        if name_raw:
            self.name = self.process_name(name_raw)

        if arguments_raw:
            self.arguments = self.process_arguments(arguments_raw)

        # Process return
        if return_value_raw:
            self.return_value = self.process_return_value(return_value_raw)

        # Process example
        if example_raw:
            self.example = example_raw.strip()

    def get_section(self, section_name):
        try:
            section_text = self.sections[self.sections.index(section_name) + 1]
            return section_text
        except ValueError:
            self.feedback("Missing \"{}\" header section".format(section_name), 2)
            return ""

    def process_public(self, raw):
        # Raw just includes an EOL character
        public_text = raw[:-1]

        if not re.match(r"(Yes|No)", public_text, re.I):
            self.feedback("Invalid public value \"{}\"".format(public_text), 2)

        return public_text.capitalize() == "Yes"

    def is_public(self):
        return self.public

    def process_author(self, raw):
        # Authors are listed on the first line
        authors_text = raw.splitlines()[0]

        # Seperate authors are divided by commas
        return authors_text.split(", ")

    def process_name(self, raw):
        # Functionname
        return raw.splitlines()[0]

    def process_description(self, raw):
        # Just use all the lines after the authors line
        description_text = "<br>".join(raw.splitlines(1)[1:])

        return description_text

    def process_arguments(self, raw):
        lines = raw.splitlines()

        if lines[0] == "None":
            return []

        if lines.count("") == len(lines):
            self.feedback("No arguments provided (use \"None\" where appropriate)", 2)
            return []

        if lines[-1] == "":
            lines.pop()
        else:
            self.feedback("No blank line after arguments list", 1)

        arguments = []
        for argument in lines:
            valid = re.match(r"^(\d+):\s(.+?)\<([\s\w]+?)\>(\s\(default: (.+)\))?$", argument)

            if valid:
                arg_index = valid.group(1)
                arg_name = valid.group(2)
                arg_types = valid.group(3)
                arg_default = valid.group(5)
                arg_notes = []

                if arg_index != str(len(arguments)):
                    self.feedback("Argument index {} does not match listed order".format(arg_index), 1)

                if arg_default == None:
                    arg_default = ""

                arguments.append([arg_index, arg_name, arg_types, arg_default, arg_notes])
            else:
                # Notes about the above argument won't start with an index
                # Only applies if there exists an above argument
                if re.match(r"^(\d+):", argument) or not arguments:
                    self.feedback("Malformed argument \"{}\"".format(argument), 2)
                    arguments.append(["?", "Malformed", "?", "?", []])
                else:
                    arguments[-1][-1].append(argument)

        return arguments

    def process_return_value(self, raw):
        return_value = raw.strip()

        if return_value == "None":
            return []

        valid = re.match(r"^(.+?)\<([\s\w]+?)\>", return_value)

        if valid:
            return_name = valid.group(1)
            return_types = valid.group(2)
        else:
            self.feedback("Malformed return value \"{}\"".format(return_value), 2)
            return ["Malformed",""]

        return [return_name, return_types]

    def document(self, component):
        str_list = []

        # Title
        str_list.append("<table border=\"1\">\n")
        str_list.append("  <thead>\n")
        str_list.append("    <tr>\n")
        str_list.append("      <th scope=\"colgroup\" colspan=\"2\" width=\"640px\">\n")
        str_list.append("        <a name=\"{0}\">{0}</a>\n".format(self.name))
        str_list.append("      </th>\n")
        str_list.append("    </tr>\n")
        str_list.append("  </thead>\n")
        str_list.append("  <tbody>\n")
        str_list.append("    <tr>\n")
        str_list.append("      <td colspan=\"2\" align=\"left\">\n")
        str_list.append("        <p>{}</p>\n".format(self.description))
        str_list.append("      </td>\n")
        str_list.append("    </tr>\n")
        str_list.append("    <tr>\n")
        str_list.append("      <td valign=\"top\" width=\"50%\">\n")
        str_list.append("        <strong><sub>Parameters</sub></strong>\n")
        str_list.append("        <ol start=\"0\">\n")
        if self.arguments:
            for argument in self.arguments:
                str_list.append("          <li><kbd>{2}</kbd> - {1}</li>\n".format(*argument))
        else:
            str_list.append("          <br>None\n")

        str_list.append("        </ol>\n")
        str_list.append("      </td>\n")
        str_list.append("      <td valign=\"top\" width=\"50%\">\n")
        str_list.append("        <strong><sub>Returns</sub></strong>\n")
        if self.return_value:
            str_list.append("          <li><kbd>{1}</kbd> - {0}</li>\n".format(*self.return_value))
        else:
            str_list.append("          <br>None\n")

        str_list.append("      </td>\n")
        str_list.append("    </tr>\n")
        str_list.append("    <tr>\n")
        str_list.append("      <td colspan=\"2\" align=\"left\">\n")
        str_list.append("        <strong>Example</strong>\n")
        str_list.append("        <pre><code>{}</code></pre>\n".format(self.example))
        str_list.append("      </td>\n")
        str_list.append("    </tr>\n")

        str_list.append("    <tr>\n")
        str_list.append("      <td colspan=\"2\" align=\"left\">\n")
        str_list.append("        <strong>Author(s):</strong>\n")
        for author in self.authors:
            str_list.append("          <li>{}</li>\n".format(author))
        str_list.append("      </td>\n")
        str_list.append("    </tr>\n")
        str_list.append("  </tbody>\n")
        str_list.append("</table>\n")
        str_list.append("\n<hr>\n")

        return ''.join(str_list)

    def log_file(self, error=False):
        # When in debug mode we only want to see the files with errors
        if not self.debug or error:
            if not self.logged:
                rel_path = os.path.relpath(self.path, self.directory)

                self.write("Processing... {}".format(rel_path), 1)
                self.logged = True

    def feedback(self, message, level=0):
        priority_str = ["Info","Warning","Error","Aborted"][level]

        self.log_file(level > 0)
        self.write("{0}: {1}".format(priority_str, message))

    def write(self, message, indent=2):
        to_print = ["  "]*indent
        to_print.append(message)
        print("".join(to_print))


def documentcontents(componentfunctions):
    str_list = []
    str_list.append("<h2>Index of API functions</h2>\n")
    str_list.append("<table border=\"1\">\n")
    str_list.append("  <tbody>\n")
    str_list.append("    <tr>\n")
    str_list.append("      <td>\n")
    str_list.append("        <ul style=\"list-style-type:square\">\n")

    for function in componentfunctions:
        str_list.append("          <li><code><a href=\"{0}\">{0}</a></code></li>\n". \
            format(function.name))

    str_list.append("        </ul>\n")
    str_list.append("      </td>\n")
    str_list.append("    </tr>\n")
    str_list.append("  </tbody>\n")
    str_list.append("</table>\n<br>\n<hr>\n")
    return ''.join(str_list)

def document_functions(components):
    os.makedirs('../docs/functions/', exist_ok=True)

    for component in components:
        output = os.path.join('../docs/functions/',component) + ".md"
        with open(output, "w") as file:
            file.write(documentcontents(components[component]))
            for function in components[component]:
                file.write(function.document(component))

def crawl_dir(directory, debug=False):
    components = {}

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".sqf"):
                file_path = os.path.join(root, file)

                # Attempt to import the header from file
                function = FunctionFile(directory)
                function.import_header(file_path)

                # Undergo data extraction and detailed debug
                if function.has_header():
                    function.process_header(debug)

                    if function.is_public() and not debug:
                        # Add functions to component key (initalise key if necessary)
                        component = os.path.basename(os.path.dirname(root))
                        components.setdefault(component,[]).append(function)

                        function.feedback("Publicly documented")

    document_functions(components)

def main():
    print("""
    #########################
    # Documenting Functions #
    #########################
    """)

    parser = argparse.ArgumentParser()
    parser.add_argument('directory', nargs="?", type=str, default=".", help='only crawl specified module addon folder')
    parser.add_argument('--debug', action="store_true", help='only check for header debug messages')
    args = parser.parse_args()

    # abspath is just used for the terminal output
    prospective_dir = os.path.abspath(os.path.join('../addons/',args.directory))
    if os.path.isdir(prospective_dir):
        print("Directory: {}\n".format(prospective_dir))
        crawl_dir(prospective_dir, args.debug)
    else:
        print("Invalid directory: {}".format(prospective_dir))

if __name__ == "__main__":
    main()

