document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".hide-for-javascript").forEach(function (element) {
	element.classList.remove("hide-for-javascript");
    });
    const tables = ["table-unpublished", "table-published", "table-review"];
    tables.forEach(function (table) {
	const element = document.getElementById(table);
	if (element) {
            jQuery(`#${table}`).DataTable({
		columnDefs: [
                    { type: "file-size", targets: 2 },
                    { orderable: false, targets: -1 }
		],
		order: [[3, "desc"]]
            });
            element.style.display = "block";
            document.getElementById(`${table}-loader`).remove();
	}
    });
});
