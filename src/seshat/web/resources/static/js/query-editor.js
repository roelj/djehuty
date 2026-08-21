function remove_previous_query_results () {
    document.querySelectorAll(".query-error").forEach(function (element) { element.remove(); });
    document.getElementById("query-results")?.remove();
    document.getElementById("query-output")?.remove();
    document.getElementById("query-output_wrapper")?.remove();
}

function query_error_message (response_text, fallback) {
    let message = fallback;
    try {
        let data = JSON.parse(response_text);
        message = data.error.message;
    }
    catch (err) { message = fallback; }

    if (message === "" || message === undefined || message === null) {
        message = "An unknown error occurred.";
    }
    return message;
}

function execute_query (editor) {
    let button_wrapper = document.getElementById("button-wrapper");
    button_wrapper.insertAdjacentHTML("afterend",
        "<div class=\"query-data-loader\">" +
            "<div class=\"title\">Loading data ...</div>" +
            "<div class=\"content\">Please wait for the results to appear.</div>" +
        "</div>");

    remove_previous_query_results ();
    fetch("/admin/sparql", {
        method:  "POST",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/sparql-update"
        },
        body: editor.getValue()
    })
        .then(function (response) {
            if (!response.ok) {
                return response.text().then(function (text) {
                    throw new Error(query_error_message (text, `Error: ${response.status}`));
                });
            }
            return response.json();
        })
        .then(function (data) {
            document.querySelector(".query-data-loader")?.remove();
            button_wrapper.insertAdjacentHTML("afterend",
                "<h3 id=\"query-results\">Query results</h3>");

            let query_results = document.getElementById("query-results");
            if (data.length == 0) {
                query_results.insertAdjacentHTML("afterend",
                    "<p id=\"query-output\">The query returned 0 rows.</p>");
            }
            else {
                query_results.insertAdjacentHTML("afterend",
                    "<pre id=\"query-output\" class=\"display\"></pre>");
                document.getElementById("query-output").textContent = JSON.stringify(data);
            }
        })
        .catch(function (error) {
            document.querySelector(".query-data-loader")?.remove();
            button_wrapper.insertAdjacentHTML("afterend",
                "<h3 id=\"query-results\">Query results</h3>" +
                "<div class=\"query-error\">" +
                    "<div class=\"title\">Error</div>" +
                    "<div class=\"content\"><pre></pre></div></div>");
            document.querySelector(".query-error .content pre").textContent = error.message;
        });
}

document.addEventListener("DOMContentLoaded", function () {
    ace.config.set('useStrictCSP', true);
    let editor = ace.edit("editor");
    let session = editor.getSession();
    editor.setTheme("ace/theme/crimson_editor");
    editor.setShowPrintMargin(false);
    editor.setAutoScrollEditorIntoView(true);
    editor.setOptions({ maxLines: 120,
                        minLines: 2,
                        enableBasicAutocompletion: true,
                        enableLiveAutocompletion: true });
    session.setMode("ace/mode/sparql");
    session.setTabSize(2);

    /* Add keybindings for copying the text and for running the query. */
    editor.commands.addCommand({
        name: "copyCommand",
        bindKey: {win: "Ctrl-C",  mac: "Command-C"},
        exec: function(editor) {
            document.getElementById("content").insertAdjacentHTML("afterend",
                "<textarea id=\"copyText\"></textarea>");
            let temp = document.getElementById("copyText");
            temp.value = editor.getSelectedText();
            temp.select();
            document.execCommand("copy");
            temp.remove();
            document.querySelector(".ace_text-input")?.focus();
        }, readOnly: true
    });

    editor.commands.addCommand({
        name: "executeQueryCommand",
        bindKey: {win: 'Ctrl-Enter',  mac: 'Command-Enter'},
        exec: execute_query, readOnly: true
    });

    document.getElementById("execute-query-button")?.addEventListener("click", function (event) {
        execute_query (editor);
    });
});
