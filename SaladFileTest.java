import org.broadinstitute.heterodon.Eval;
import org.broadinstitute.heterodon.Exec;
import org.broadinstitute.heterodon.ExecAndEval;

public class SaladFileTest {
    public static void main(String[] args) {
        String saladScript = String.join(
                System.getProperty("line.separator"),
                "import json",
                "import logging",
                "",
                "from cwltool.load_tool import fetch_document, resolve_tool_uri, validate_document",
                "from cwltool.loghandler import _logger",
                "",
                "",
                "def cwltool_salad(path):",
                "    _logger.setLevel(logging.WARN)",
                "    uri, tool_file_uri = resolve_tool_uri(path)",
                "    document_loader, workflowobj, uri = fetch_document(uri)",
                "    document_loader, avsc_names, processobj, metadata, uri \\",
                "        = validate_document(document_loader, workflowobj, uri, preprocess_only=True)",
                "    return json.dumps(processobj, indent=4)",
                ""
        );
        ExecAndEval execAndEval = new ExecAndEval();
        Object saladResult = execAndEval.apply(saladScript, "cwltool_salad('" + args[0] + "')");
        System.out.println(saladResult);
    }
}
