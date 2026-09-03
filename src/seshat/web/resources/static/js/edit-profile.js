function save_profile (notify=true, on_success=jQuery.noop) {

    let categories   = document.querySelectorAll("input[name='categories']:checked");
    let category_ids = [];
    for (let category of categories) {
        category_ids.push(category.value);
    }

    let form_data = {
        "first_name":     or_null(document.getElementById("first_name").value),
        "last_name":      or_null(document.getElementById("last_name").value),
        "job_title":      or_null(document.getElementById("job_title").value),
        "location":       or_null(document.getElementById("location").value),
        "biography":      or_null(document.getElementById("biography").value),
        "twitter":        or_null(document.getElementById("twitter").value),
        "linkedin":       or_null(document.getElementById("linkedin").value),
        "website":        or_null(document.getElementById("website").value),
        "categories":     category_ids
    };

    jQuery.ajax({
        url:         "/v3/profile",
        type:        "PUT",
        contentType: "application/json",
        accepts:     { json: "application/json" },
        data:        JSON.stringify(form_data),
    }).done(function () {
        if (notify) { show_message ("success", "<p>Saved changes.</p>"); }
        on_success ();
    }).fail(function () {
        if (notify) {
            show_message ("failure", "<p>Failed to save your profile. Please try again at a later time.</p>");
        }
    });
}

function render_categories_for_profile () {
    jQuery.ajax({
        url:         "/v3/profile/categories",
        data:        { "limit": 10000 },
        type:        "GET",
        accepts:     { json: "application/json" },
    }).done(function (categories) {
        for (let category of categories) {
            jQuery(`#category_${category["uuid"]}`).prop("checked", true);
            jQuery(`#category_${category["parent_uuid"]}`).prop("checked", true);
            jQuery(`#subcategories_${category["parent_uuid"]}`).show();
        }
    }).fail(function () {
        show_message ("failure", "Failed to retrieve categories.");
    });
}

function remove_profile_image () {
    jQuery.ajax({
        url:         "/v3/profile/picture",
        type:        "DELETE",
        accepts:     { json: "application/json" }
    }).done (function () {
        jQuery("#upload-profile-image").removeClass("profile-image");
        jQuery(".dz-button").show();
    }).fail (function () {
        show_message ("failure", "<p>Failed to remove profile image.</p>");
    });
}

function activate () {
    render_categories_for_profile ();
    install_sticky_header();
    install_touchable_help_icons();
    document.getElementById("save")?.addEventListener("click", function () { save_profile(); });
    document.getElementById("remove-image")?.addEventListener("click", function () { remove_profile_image(); });
    document.getElementById("expand-categories-button")?.addEventListener("click", toggle_categories);
    const fileUploader = new Dropzone("#upload-profile-image", {
        url:               "/v3/profile/picture",
        dictDefaultMessage: "Upload your profile picture",
        paramName:         "file",
        maxFilesize:       10000,
        maxFiles:          1,
        parallelUploads:   1,
        ignoreHiddenFiles: false,
        createImageThumbnails: false,
        disablePreviews:   true,
        init: function() {},
        error: function(file, response, xhr) {
            show_message ("failure", `<p>${response.message}</p>`);
        },
        success: function (file, response) {
            save_profile (false, function () { location.reload(); });
        },
        accept: function(file, done) {
            done();
        }
    });

    fileUploader.on("complete", function(file) {
        fileUploader.removeFile(file);
    });

}
