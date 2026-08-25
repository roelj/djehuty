function gather_form_data () {
    return {
	"name":      or_null(jQuery("#name").val()),
	"namespace": or_null(jQuery("#namespace").val())
    }
}

function save_project (event) {
    stop_event_propagation (event);
    let project_uuid = event.data["project_uuid"];
    let form_data = gather_form_data ();
    jQuery.ajax({
	url: `/v3/projects/${project_uuid}`,
	type: "PUT",
	contentType: "application/json",
	accepts: { json: "application/json" },
	data: JSON.stringify (form_data)
    }).done(function() {
	show_message ("success", "<p>Saved changes.</p>");
    }).fail(function (jqXHR, textStatus, errorThrown) {
        let json = jqXHR.responseJSON;
        let message = "<p>Failed to save project. Please try again at a later time.</p>";
        if (json) { message = `<p>Failed to save project: ${json.message}</p>`; }
        show_message ("failure", message);
    });
}


function activate (project_uuid) {
    jQuery(".hide-for-javascript").removeClass("hide-for-javascript");
    jQuery("#save").on("click", { "project_uuid": project_uuid }, save_project);
}
