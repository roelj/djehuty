function toggle_storage_request (event) {
    let storage_request_div = jQuery("#storage-request-wrapper");
    if (storage_request_div.is(":visible")) {
        jQuery("#storage-request-wrapper").slideUp(150, function (){
            jQuery("#request-more-storage")
                .removeClass("close")
                .addClass("open")
                .text("Request more storage");
        });
    } else {
        jQuery("#storage-request-wrapper").slideDown(150, function (){
            jQuery("#request-more-storage")
                .removeClass("open")
                .addClass("close")
                .text("Cancel storage request");
        });
    }

}

function submit_storage_request (event) {
    let data = {
        "new-quota": or_null(jQuery("#new-quota").val()),
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
        jQuery(".quota-requested").remove();
        jQuery(".storage-usage").after(`<span class="quota-requested">Request pending for ${data["new-quota"]}.00GB</span>`);
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

jQuery(document).ready(function (){
    new Quill("#quota-reason", { modules: quill_modules, theme: 'snow' });
    jQuery("#request-more-storage").on("click", toggle_storage_request);
    jQuery("#submit-storage-request").on("click", submit_storage_request);
    jQuery(".delete-session").on("click", delete_session);
});
