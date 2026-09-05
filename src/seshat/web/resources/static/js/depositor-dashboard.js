function toggle_storage_request (event) {
    let wrapper = document.getElementById("storage-request-wrapper");
    let button  = document.getElementById("request-more-storage");
    if (wrapper === null) { return; }

    let is_visible = (wrapper.style.display !== "" && wrapper.style.display !== "none");
    wrapper.style.display = is_visible ? "none" : "block";
    if (button === null) { return; }

    button.classList.remove(is_visible ? "close" : "open");
    button.classList.add(is_visible ? "open" : "close");
    button.textContent = is_visible ? "Request more storage" : "Cancel storage request";
}

function submit_storage_request (event) {
    let data = {
        "new-quota": or_null(document.getElementById("new-quota").value),
        "reason":    value_from_quill("#quota-reason")
    };
    jQuery.ajax({
        url:         `/v3/profile/quota-request`,
        type:        "POST",
        contentType: "application/json",
        accepts:     { json: "application/json" },
        data:        JSON.stringify(data),
        dataType:    "json"
    }).done(function () {
        show_message ("success", "<p>Quota request has been sent.</p>");
        for (let element of document.querySelectorAll(".quota-requested")) { element.remove(); }
        for (let element of document.querySelectorAll(".storage-usage")) {
            let pending = document.createElement("span");
            pending.className   = "quota-requested";
            pending.textContent = `Request pending for ${data["new-quota"]}.00GB`;
            element.after(pending);
        }
        toggle_storage_request(null);
    }).fail(function () {
        show_message ("failure", "<p>Quota request could not be sent.</p>");
    });
}

function delete_session (event) {
    stop_event_propagation (event);
    let session_uuid = event.currentTarget.id;
    if (session_uuid.startsWith("session-")) { session_uuid = session_uuid.slice(8) }
    jQuery.ajax({
	type: "DELETE",
	url: `/v3/sessions/${session_uuid}`
    }).done(function () { window.location.pathname = "/my/dashboard"; })
      .fail(function (jqXHR, textStatus, errorThrown) {
          show_message ("failure", "<p>Failed to remove session.</p>");
      });
}

document.addEventListener("DOMContentLoaded", function () {
    new Quill("#quota-reason", { modules: quill_modules, theme: 'snow' });
    document.getElementById("request-more-storage")?.addEventListener("click", toggle_storage_request);
    document.getElementById("submit-storage-request")?.addEventListener("click", submit_storage_request);
    for (let element of document.querySelectorAll(".delete-session")) {
        element.addEventListener("click", delete_session);
    }
    if (typeof render_projects_selector === 'function') {
	render_projects_selector (null);
    }
});
