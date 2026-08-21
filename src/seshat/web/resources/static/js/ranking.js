const capitalize = (i) => (i[0].toUpperCase() + i.substring(1));

function parameters_for_api_calls (order) {
    let parameters = {
        "limit": 10,
        "order_direction": "desc",
        "order": order
    };

    // This procedure is used by both institutional pages which filter by 'group_ids'
    // and category pages which filter by 'categories'.  So one of these variables
    // won't be defined, but that's expected.
    try {
        if (categories !== "") { parameters["categories"] = categories; }
    } catch (error) {}

    try {
        if (group_ids !== "") { parameters["group_ids"] = group_ids; }
    } catch (error) {}

    return parameters;
}

function latest_datasets () {
    const parameters = build_query_parameters (parameters_for_api_calls ("published_date"));
    let loader    = document.getElementById("latest-datasets-loader");
    let container = document.getElementById("latest-datasets");

    fetch(`/v3/datasets?${parameters}`, {
        method:  "GET",
        headers: { "Accept": "application/json" }
    }).then(function (response) {
        if (!response.ok) {
            throw new Error(`Error: ${response.status} ${response.statusText}`);
        }
        return response.json();
    }).then(function (data) {
        let output = '<ul class="latest-datasets">';
        for (let item of Object.values(data)) {
            if (is_empty_object (item)) { continue; }
            output += '<li><div class="latest-item"><div class="latest-title"><a class="corporate-identity" href="/datasets/'+ escape_html(item.uuid) +'">';
            output += escape_html(item.title) + '</a></div></div></li>';
        }

        output += "</ul>";
        if (loader !== null) { loader.style.display = "none"; }
        container.insertAdjacentHTML("beforeend", output);
    }).catch(function () {
        if (loader !== null) { loader.style.display = "none"; }
        container.insertAdjacentHTML("beforeend", "<p>Could not load the latest datasets.</p>");
    });
}

function top_datasets (item_type) {
    let wrapper = document.getElementById("top-datasets-wrapper");
    wrapper.classList.add("loader");

    document.querySelectorAll("#top-datasets tbody tr").forEach(function (row) { row.style.opacity = "0.15"; });
    document.querySelectorAll("#top-buttons .active").forEach(function (element) { element.classList.remove("active"); });
    document.querySelectorAll(`.top-${item_type}`).forEach(function (element) { element.classList.add("active"); });

    const parameters = build_query_parameters (parameters_for_api_calls (item_type));
    fetch(`/v3/datasets/top/${item_type}?${parameters}`, {
        method:  "GET",
        headers: { "Accept": "application/json" }
    }).then(function (response) {
        if (!response.ok) { throw new Error(`Error: ${response.status} ${response.statusText}`); }
        return response.json();
    }).then(function (data) {
        let output = '<table id="top-datasets"><thead>';
        output += `<tr class="corporate-identity-background"><th>Dataset</th><th># ${capitalize(item_type)}</th></tr>`;
        output += '</thead><tbody>';
        for (let item of Object.values(data)) {
            if (is_empty_object (item)) { continue; }
            output += '<tr><td>';
            output += '<a href="/datasets/'+ escape_html(item.container_uuid) +'">';
            output += escape_html(item.title) + '</a>';
            output += '</td>';
            output += '<td>' + escape_html(item[item_type]) + '</td></tr>';
        }

        output += "</tbody></table>";
        document.getElementById("top-datasets")?.remove();
        wrapper.classList.remove("loader");
        wrapper.insertAdjacentHTML("beforeend", output);
    }).catch(function () {
        wrapper.classList.remove("loader");
        wrapper.insertAdjacentHTML("beforeend", "<p>Could not load the top datasets.</p>");
    });
}

document.addEventListener("DOMContentLoaded", function () {
    for (let item_type of ["downloads", "views", "shares", "cites"]) {
        document.querySelectorAll(`li.top-${item_type} a`).forEach(function (element) {
            element.addEventListener("click", function (event) {
                event.preventDefault();
                event.stopPropagation();
                top_datasets (item_type);
            });
        });
    }
    top_datasets("downloads");
    latest_datasets();
});
