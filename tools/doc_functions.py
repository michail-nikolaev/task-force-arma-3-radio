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
    doc_functions core --debug
        Crawl only functions in addons/core and only reports debug messages.

"""
#!/usr/bin/python3
# -*- coding: utf-8 -*-
# pylint: disable=W0702
# pylint: disable=C0301

import os
import re
import argparse
import logging

def main():
    """Main"""

    parser = argparse.ArgumentParser(prog='Document SQF functions')
    parser.add_argument('directory', nargs="?", type=str, help='only crawl specified component addon folder')
    parser.add_argument('--output', default='tfar', choices=['tfar', 'ace'], help='The style of the output')
    parser.add_argument('--loglevel', default=30, type=int, help='The Loglevel (default: 30)')
    parser.add_argument('--logfile', type=str, help='Write log to file')
    parser.add_argument('--version', action='version', version='%(prog)s 1.0')
    args = parser.parse_args()

    logging.basicConfig(format='%(levelname)s:%(message)s', level=args.loglevel, filename=args.logfile)
    logging.info('Creating documentation')
    logging.debug(args)

    addonsdir = os.path.abspath(os.path.normpath(__file__ + '/../../addons'))
    docfolder = os.path.abspath(os.path.normpath(__file__ + '/../../docs/functions'))

    logging.debug("AddOn path: %s", addonsdir)
    logging.debug("Document path: %s", docfolder)

    all_components = {}
    if args.directory:
        logging.info('Documenting only component: %s', args.directory)
        cur_component = Component(os.path.join(addonsdir, args.directory))
        if cur_component.functions:
            all_components[cur_component.name] = cur_component
            cur_component.style = args.output
    else:
        logging.info('Documenting all components')
        for folder in os.listdir(addonsdir):
            if os.path.isdir(os.path.join(addonsdir, folder)):
                cur_component = Component(os.path.join(addonsdir, folder))
                if cur_component.functions:
                    all_components[cur_component.name] = cur_component
                    cur_component.style = args.output

    if all_components:
        logging.debug(all_components)
        create_documentations(all_components, docfolder)
    else:
        logging.debug('No components found')

def create_documentations(all_components, docfolder):
    """Document all components"""
    if not os.path.exists(docfolder):
        logging.debug("Creating folder: %s", docfolder)
        os.makedirs(docfolder)
    for item in all_components:
        filepath = os.path.join(docfolder, '{}.md'.format(all_components[item].name))
        if os.path.exists(filepath):
            logging.debug("Removing old file: %s", filepath)
            os.remove(filepath)
        logging.debug("Writing Component: %s", all_components[item].name)
        docfile = open(filepath, 'w+')
        docfile.write(document_component(all_components[item]))
        for function in all_components[item].functions:
            logging.debug("Writing function: %s", function.name)
            if all_components[item].style == 'ace':
                docfile.write(document_function_ace(function))
            else:
                docfile.write(document_function_tfar(function))
        docfile.close()

class FunctionFile:
    """Function"""
    def __init__(self, filepath):

        logging.debug("Processing: %s", filepath)

        self.path = filepath
        self.header = ""
        self.import_header()
        self.component = ""

        self.name = ""
        self.public = False
        self.authors = []
        self.description = []
        self.arguments = []
        self.return_value = []
        self.example = ""

    def import_header(self):
        """imports the header"""
        logging.debug("   Importing Header: %s", self.path)
        file = open(self.path)
        code = file.read()
        file.close()

        header_match = re.match(r"(#include\s\"script_component.hpp\"\n\n\s*)?(/\*.+?\*/)", code, re.S)
        if header_match:
            logging.debug("   Header is matching")
            self.header = header_match.group(2)
        else:
            logging.debug("   Header is not matching")

    def has_header(self):
        """Function has a header"""
        return bool(self.header)

    def process_header(self):
        """Analyze the header"""

        logging.debug("   Processing header")
        # Detailed debugging occurs here so value is set

        # Preemptively cut away the comment characters (and leading/trailing whitespace)

        header_text = self.header.strip()
        if header_text.startswith('/*'):
            header_text = header_text[2:]
        if header_text.endswith('*/'):
            header_text = header_text[:-2]

        result = []
        for line in header_text.splitlines():
            line = line.strip()
            if line.startswith('*'):
                result.append(line[1:])
            else:
                result.append(line)
        header_text = '\n'.join(result)

        # Split the header into expected sections
        self.sections = re.split(r"^(Name|Author|Argument|Return Value|Example|Public)s?:\s?", header_text, 0, re.M)

        logging.debug("   Header Sections: %s", self.sections)

        # If public section is missing we can't continue
        public_raw = self.get_section("Public")
        if not public_raw:
            logging.warning('Public value undefined in %s', self.path)
            return

        # Determine whether the header is public
        self.public = self.process_public(public_raw)

        # Don't bother to process the rest if private
        # Unless in debug mode
        if not self.public:
            logging.debug("Function is not public: %s", self.path)
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
            logging.debug("   Description: %s", self.description)

        if name_raw:
            self.name = self.process_name(name_raw)

        if arguments_raw:
            self.arguments = self.process_arguments(arguments_raw)

        # Process return
        if return_value_raw:
            self.return_value = self.process_arguments(return_value_raw)

        # Process example
        if example_raw:
            self.example = example_raw.strip()

    def get_section(self, section_name):
        """returns a header section"""
        try:
            section_text = self.sections[self.sections.index(section_name) + 1]
            return section_text
        except ValueError:
            logging.debug('   Missing "%s" header section in %s', section_name, self.path)
            return ""

    def process_public(self, raw):
        """Raw just includes an EOL character"""
        public_text = raw[:-1]

        if not re.match(r"(Yes|No)", public_text, re.I):
            logging.warning('   Invalid public value "%s"', public_text)

        return public_text.capitalize() == "Yes"

    def is_public(self):
        """function is public"""
        return self.public

    def process_author(self, raw):
        """process the author"""
        # Authors are listed on the first line
        authors_text = raw.splitlines()[0]
        # Seperate authors are divided by commas
        return authors_text.split(", ")

    def process_name(self, raw):
        """process the functionname"""
        return raw.splitlines()[0]

    def process_description(self, raw):
        """process the description"""
        # Just use all the lines after the authors line
        return [line.rstrip() for line in raw.splitlines(1)[1:]]
    def process_arguments(self, raw):
        """process the arguments"""
        lines = raw.splitlines()

        if lines[0] == "None":
            return []

        if lines.count("") == len(lines):
            logging.warning("   No arguments provided (use \"None\" where appropriate)")
            return []

        if lines[-1] == "":
            lines.pop()
        else:
            logging.warning("   No blank line after arguments list")

        arguments = []
        for argument in lines:
            valid = re.match(r"^((\d+):\s)?(.+?)\<([\s\w\/]+?)\>(\s\(default: (.+?)\))?(.+?)?$", argument)

            if valid:
                arg_index = valid.group(2)
                arg_name = valid.group(3)
                arg_types = valid.group(4)
                arg_default = valid.group(6)
                arg_notes = valid.group(7)

                if arg_default is None:
                    arg_default = ""
                if arg_notes is None:
                    arg_notes = ""

                arguments.append([arg_index, arg_name, arg_types, arg_default, arg_notes])
            else:
                # Notes about the above argument won't start with an index
                # Only applies if there exists an above argument
                if arguments or re.match(r"^(\d+):", argument):
                    logging.warning('Malformed argument "%s" in %s', argument, self.path)
                    arguments.append(["?", "Malformed", "?", "?", "?"])
                else:
                    if arguments:
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
            logging.warning('   Malformed return value "%s"', return_value)
            return ["Malformed", ""]

        return [return_name, return_types]

class Component:
    """defines a component to be defined"""
    def __init__(self, path_to_component):
        self.path = path_to_component
        self.name = self.get_componentname()
        self.functions = []
        self.style = ''
        self.get_functions()
        logging.debug("Component %s functions: %s", self.name, self.functions)
        if not self.functions:
            del self

    def get_functions(self):
        """gets all functions from inside a component"""
        for root, dirs, files in os.walk(self.path):
            for file in files:
                if file.endswith(".sqf"):
                    file_path = os.path.join(root, file)

                    function = FunctionFile(file_path)
                    function.component = self.name
                    function.import_header()

                    if function.has_header():
                        logging.debug("Function %s has header", function.path)
                        function.process_header()

                        if function.is_public():
                            logging.debug("Function %s is public", function.name)
                            self.functions.append(function)
                        else:
                            logging.debug("Function %s is not public", function.name)
                            del function
                    else:
                        logging.debug("Function %s has NO header", file_path)
                        del function
                    if 'function' in locals():
                        logging.info("Documenting file: %s", file_path)
                    else:
                        logging.info("Skipping file: %s", file_path)

    def get_componentname(self):
        """returns the name of the component"""
        #component_file = open(os.path.join(self.path, "script_component.hpp"), 'r')
        name = os.path.basename(self.path)
        return name

def document_function_ace(function):
    """returns the function documentation in the style of ace"""
    str_list = []

    # Title
    str_list.append("\n## ace_{}_fnc_{}\n".format(function.component, os.path.basename(function.path)[4:-4]))
    # Description
    str_list.append("__Description__\n\n" + '\n'.join(function.description) + '\n')
    # Arguments
    if function.arguments:
        if function.arguments[0][0]:
            str_list.append("__Parameters__\n\nIndex | Description | Datatype(s) | Default Value\n--- | --- | --- | ---\n")
            for argument in function.arguments:
                str_list.append("{} | {} | {} | {}\n".format(*argument))
            str_list.append("\n")
        else:
            str_list.append("__Parameters__\n\nDescription | Datatype(s) | Default value\n--- | --- | ---\n{} | {} | {} \n\n".format(\
                function.arguments[0][1], function.arguments[0][2], function.arguments[0][3]))
    else:
        str_list.append("__Parameters__\n\nNone\n\n")

    # Return Value
    if function.return_value:
        if function.return_value[0][0]:
            str_list.append("__Return Value__\n\nIndex | Description | Datatype(s) | Default Value\n--- | --- | --- | ---\n")
            for argument in function.return_value:
                str_list.append("{} | {} | {} | {}\n".format(*argument))
            str_list.append("\n")
        else:
            str_list.append("__Return Value__\n\nDescription | Datatype(s)\n--- | ---\n{} | {} \n\n".format(\
                function.return_value[0][1], function.return_value[0][2]))
    else:
        str_list.append("__Return Value__\n\nNone\n\n")

    # Example
    str_list.append("__Example__\n\n```sqf\n{}\n```\n\n".format(function.example))
    # Authors
    str_list.append("\n__Authors__\n\n")
    for author in function.authors:
        str_list.append("- {}\n".format(author))
    # Horizontal rule
    str_list.append("\n---\n")

    return ''.join(str_list)

def document_component(component):
    """Document the component header"""
    str_list = []
    if component.style == 'tfar':
        # TFAR header
        str_list.append('<h2>Index of API functions</h2>\n')
        str_list.append('<table border="1">\n  <tbody>\n    <tr>\n      <td>\n        <ul style="list-style-type:square">\n')
        for function in component.functions:
            str_list.append('          <li><code><a href="{0}">{0}</a></code></li>\n'.format(function.name))
        str_list.append('        </ul>\n      </td>\n    </tr>\n  </tbody>\n</table>\n<br><hr>\n')
    elif component.style == 'ace':
        # ACE header
        str_list.append('')
    logging.debug("Contents: %s", str_list)
    return ''.join(str_list)

def document_function_tfar(function):
    """Document the function"""
    str_list = []

    # Title
    str_list.append('<table border="1">\n')
    str_list.append('  <thead>\n')
    str_list.append('    <tr>\n')
    str_list.append('      <th scope="colgroup" colspan="2" width="640px">\n')
    str_list.append('        <a name="{0}">{0}</a>\n'.format(function.name))
    str_list.append('      </th>\n')
    str_list.append('    </tr>\n')
    str_list.append('  </thead>\n')
    str_list.append('  <tbody>\n')
    str_list.append('    <tr>\n')
    str_list.append('      <td colspan="2" align="left">\n')
    str_list.append('        <p>{}</p>\n'.format('<br>'.join(function.description)))
    str_list.append('      </td>\n')
    str_list.append('    </tr>\n')
    str_list.append('    <tr>\n')
    str_list.append('      <td valign="top" width="50%">\n')
    str_list.append('        <strong><sub>Parameters</sub></strong>\n')
    str_list.append('        <ol start=\"0\">\n')
    if function.arguments:
        for argument in function.arguments:
            if argument[0]:
                str_list.append('          <li><kbd>{2}</kbd> - {1}</li>\n'.format(*argument))
            else:
                str_list.append('          <kbd>{2}</kbd> - {1}\n'.format(*argument))
    else:
        str_list.append('          None\n')
    str_list.append('        </ol>\n')
    str_list.append('      </td>\n')
    str_list.append('      <td valign="top" width="50%">\n')
    str_list.append('        <strong><sub>Returns</sub></strong>\n')
    str_list.append('        <ol start="0">\n')
    if function.return_value:
        for argument in function.return_value:
            if argument[0]:
                str_list.append('          <li><kbd>{2}</kbd> - {1}</li>\n'.format(*argument))
            else:
                str_list.append('          <kbd>{2}</kbd> - {1}\n'.format(*argument))
    else:
        str_list.append('          None\n')
    str_list.append('        </ol>\n')
    str_list.append('      </td>\n')
    str_list.append('    </tr>\n')
    str_list.append('    <tr>\n')
    str_list.append('      <td colspan="2" align="left">\n')
    str_list.append('        <strong>Example</strong>\n')
    str_list.append('        <pre><code>{}</code></pre>\n'.format(function.example))
    str_list.append('      </td>\n')
    str_list.append('    </tr>\n')

    str_list.append('    <tr>\n')
    str_list.append('      <td colspan="2" align="left">\n')
    str_list.append('        <strong>Author(s):</strong>\n')
    for author in function.authors:
        str_list.append('          <li>{}</li>\n'.format(author))
    str_list.append('      </td>\n')
    str_list.append('    </tr>\n')
    str_list.append('  </tbody>\n')
    str_list.append('</table>\n')
    str_list.append('\n<hr>\n')

    return ''.join(str_list)

if __name__ == "__main__":
    main()
