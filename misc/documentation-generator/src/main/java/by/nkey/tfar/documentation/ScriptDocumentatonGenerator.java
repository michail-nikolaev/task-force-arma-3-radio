package by.nkey.tfar.documentation;

import com.google.common.base.Joiner;
import com.google.common.base.Splitter;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Multimap;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

/**
 * @author nkey
 * @since 22.04.2014
 */
public class ScriptDocumentatonGenerator {

    public static void main(String[] args) throws IOException {
        Map<String, String> descriptions = new TreeMap<>();
        Multimap<String, String> parameters = ArrayListMultimap.create();
        Map<String, String> returns = new TreeMap<>();
        Map<String, String> examples = new TreeMap<>();
        Multimap<String, String> authors = ArrayListMultimap.create();


        try (DirectoryStream<Path> sqfs = Files.newDirectoryStream(Paths.get("../../arma3/@task_force_radio/addons/task_force_radio/functions"))) {

            ImmutableList<Path> paths = ImmutableList.copyOf(sqfs.iterator());
            List<Path> functions = paths.stream()
                            .filter(file -> file.toFile().getName().endsWith(".sqf"))
                            .filter(file -> file.toFile().getName().startsWith("fn_"))
                            .collect(Collectors.toList());

            for (Path sqf : functions) {
                String functionName = sqf.toFile().getName().replaceAll("fn_", "TFAR_fnc_").replaceAll(".sqf", "");
                String content = new String(Files.readAllBytes(sqf));
                if (content.contains("/*") && content.contains("/*")) {
                    String documentation = StringUtils.substringBetween(content, "/*", "*/");

                    Splitter newLineSplitter = Splitter.on('\n').trimResults().omitEmptyStrings();

                    String authorText = StringUtils.substringBetween(documentation, "Author(s):", "Description");

                    List<String> authorsList = newLineSplitter.splitToList(authorText);
                    authors.putAll(functionName, authorsList);

                    String description =
                            Joiner.on('\n').join(newLineSplitter.splitToList(StringUtils.substringBetween(documentation, "Description:", "Parameters")));
                    descriptions.put(functionName, description);

                    List<String> parameter =
                            newLineSplitter.splitToList(StringUtils.substringBetween(documentation, "Parameters:", "Returns"));
                    parameters.putAll(functionName, parameter);

                    String returnsResult =
                            Joiner.on('\n').join(newLineSplitter.splitToList(StringUtils.substringBetween(documentation, "Returns:\r\n", "\r\n")));
                    returns.put(functionName, returnsResult);

                    String example =
                            Joiner.on('\n').join(newLineSplitter.splitToList(StringUtils.substringAfter(documentation, "Example:")));
                    examples.put(functionName, example);
                }
            }
        }

        StringBuilder index = new StringBuilder();
        StringBuilder content = new StringBuilder();

        ImmutableMap<String, String> authorToLink = ImmutableMap.<String, String>builder()
                .put("Nkey", "https://github.com/michail-nikolaev")
                .put("NKey", "https://github.com/michail-nikolaev")
                .put("Garth de Wet (LH)", "https://github.com/CorruptedHeart")
                .put("L-H", "https://github.com/CorruptedHeart").build();

        for (String function : descriptions.keySet()) {
            index.append("* [").append(function).append("](#").append(function).append(")\n");

            content.append("#### <a name=\"").append(function).append("\">").append(function).append("</a>\n\n");
            content.append("**Author(s):**\n\n");
            for (String author : authors.get(function)) {
                String link = authorToLink.get(author);
                content.append("* [").append(author).append("](").append(link).append(")\n");
            }
            content.append("\n**Parameters:** \n\n");

            for (String parameter : parameters.get(function)) {
                if (!parameter.toLowerCase().contains("array: radio")) {
                    content.append("* ");
                }
                content.append(parameter).append("\n");
            }

            content.append("\n**Returns:**\n\n * ").append(returns.get(function)).append("\n\n");
            content.append("\n**Description:**\n\n").append(descriptions.get(function)).append("\n\n");

            if (examples.get(function) != null) {
                content.append("\n**Example:**\n\n```\n").append(examples.get(function)).append("\n```\n\n");
            }

            content.append("\n\n");

        }

        System.out.println("## API Index\n");
        System.out.println(index.toString());

        System.out.println("\n## Functions\n");
        System.out.println(content.toString());

    }
}
