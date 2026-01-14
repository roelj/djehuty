function render_in_form (text) { return [text].join(""); }

function or_null (value) { return (value == "" || value == "<p><br></p>") ? null : value; }
function or_empty (value) { return (value === undefined || value == null || value == "") ? "" : value;}
function show_message (type, message) {
    let element = document.getElementById("message");
    if (element === null) { return; }
    if (element.classList.contains("transparent")) {
        element.classList.remove("transparent");
        element.innerHTML = "";
    }
    element.classList.add(type);
    element.insertAdjacentHTML("beforeend", message);
    element.style.display = "block";
    setTimeout(() => {
        element.classList.add("fading-out");
        element.addEventListener("transitionend", () => {
            element.classList.remove(type, "fading-out");
            element.classList.add("transparent");
            element.innerHTML = "<p>&nbsp;</p>";
        }, { once: true });
    }, 20000);
}

function stop_event_propagation (event) {
    if (event !== null) {
        event.preventDefault();
        event.stopPropagation();
    }
}

function install_sticky_header() {
    const submenu = document.getElementById("submenu");
    const message = document.getElementById("message");
    const content_wrapper = document.getElementById("content-wrapper");
    if (submenu === null || message === null || content_wrapper === null) { return; }
    const submenu_offset = submenu.offsetTop;

    function scroll_handler() {
        let is_sticky = window.scrollY >= submenu_offset;
        submenu.classList.toggle("sticky", is_sticky);
        message.classList.toggle("sticky-message", is_sticky);
	let h1 = document.querySelector("h1");
	if (h1) { h1.classList.toggle("sticky-margin", is_sticky); }
        if (is_sticky) {
            message.style.width = `${content_wrapper.offsetWidth}px`;
        } else if (message.classList.contains("transparent")) {
            message.classList.remove("transparent");
            message.textContent = "";
            message.style.display = "none";
        }
    }

    window.addEventListener("scroll", scroll_handler, { passive: true });
    window.addEventListener("resize", scroll_handler, { passive: true });
}

function install_touchable_help_icons() {
    document.querySelectorAll(".help-icon").forEach(icon => {
        icon.addEventListener("click", () => {
            let text = icon.querySelector(".help-text");
	    if (text) {
		let is_visible = text.offsetParent !== null || getComputedStyle(text).display !== "none";
		icon.classList.toggle("help-icon-clicked", !is_visible);
	    }
        });
    });
}

function toggle_categories (event = null) {
    stop_event_propagation (event);
    const categories = document.getElementById("expanded-categories");
    if (categories === null) { return; }
    const is_open = categories.classList.toggle("open");
    const button = document.getElementById("expand-categories-button");
    button.textContent = is_open ? "Hide categories" : "Select categories";
}

function toggle_collaborators(dataset_uuid, may_edit_metadata, event) {
    stop_event_propagation(event);

    let expanded_collaborators = document.getElementById("expanded-collaborators");
    if (expanded_collaborators === null) { return; }
    let button = document.getElementById("expand-collaborators-button");
    let is_visible = expanded_collaborators.classList.contains("open");

  function show_collaborators() {
      expanded_collaborators.style.display = "block";
      expanded_collaborators.classList.add("open");
      button.textContent = "Hide collaborators";
  }

  function hide_collaborators() {
      expanded_collaborators.style.display = "none";
      expanded_collaborators.classList.remove("open");
      button.textContent = may_edit_metadata ? "Manage collaborators" : "Show collaborators";
  }

  if (is_visible) {
    hide_collaborators();
  } else {
    if (!document.getElementById("add_collaborator")) {
      render_collaborators_for_dataset(dataset_uuid, may_edit_metadata, show_collaborators);
    } else {
      show_collaborators();
    }
  }
}

function fill_collaborator (email, full_name, account_uuid) {
    const input_text = full_name === null ? email : `${full_name}, (${email})`;
    document.getElementById('add_collaborator').value = input_text;
    document.getElementById('account_uuid').value = account_uuid;
    let element = document.getElementById('collaborator-ac');
    if (element) { element.remove(); }
    document.getElementById('add_collaborator').classList.remove('input-for-ac');
}

function add_collaborator_event (event) {
    stop_event_propagation (event);
    fill_collaborator (event.data["email"], event.data["full_name"], event.data["uuid"]);
}

function autocomplete_collaborator (event, item_id) {
    let current_text = document.getElementById("add_collaborator").value.trim();
    let existing_collaborators = [...document.querySelectorAll(".contributor-uuid")].map(el => el.value);
    if (current_text == "") {
	let element = document.getElementById("collaborator-ac");
	if (element) { element.remove(); }
        document.getElementById("add_collaborator").classList.remove("input-for-ac");
    } else if (current_text.length > 2) {
        fetch("/v3/accounts/search", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ "search_for": current_text, "exclude": existing_collaborators })
        }).then(response => response.json())
          .then(data => {
	      let element = document.getElementById('collaborator-ac');
	      if (element) { element.remove(); }
              const unordered_list = document.createElement("ul");
              for (const item of data) {
                  const account_text = item.full_name ? `${item.full_name}, ${item.email}` : item.email;
                  const anchor = document.createElement("a");
                  anchor.href = "#";
                  anchor.textContent = account_text;
                  anchor.addEventListener("click", event => {
                      event.data = { "email": item.email,
                                     "full_name": item.full_name,
                                     "uuid": item.uuid
                                   };
                      add_collaborator_event(event);
                  });

                  const list_item = document.createElement("li");
                  list_item.appendChild(anchor);
                  unordered_list.appendChild(list_item);
              }

	      const wrapper = document.createElement("div");
	      wrapper.id = "collaborator-ac";
	      wrapper.className = "autocomplete";
	      wrapper.appendChild(unordered_list);
              const add_collaborator = document.getElementById("add_collaborator");
              add_collaborator.classList.add("input-for-ac");
              add_collaborator.after(wrapper);
          }).catch(error => { console.log(`Error: ${error.message}`); });
    }
}

function add_author_event (event) {
    stop_event_propagation (event);
    if (event.data && event.data["uuid"]) {
        add_author (event.data["uuid"], event.data["item_id"]);
    } else {
        new_author (event.data["item_id"]);
    }
}

function autocomplete_author (event, item_id) {
    let current_text = document.getElementById("authors").value.trim();
    if (current_text == "") {
	let element = document.getElementById("authors-ac");
	if (element) { element.remove(); }
        document.getElementById("authors").classList.remove("input-for-ac");
    } else if (current_text.length > 2) {
        fetch("/v2/account/authors/search", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ "search": current_text })
        }).then(response => response.json())
          .then(data => {
	      let element = document.getElementById("authors-ac");
	      if (element) { element.remove(); }
              const unordered_list = document.createElement("ul");
              const new_author_text = data.length === 0
                    ? "It seems the author is not registered in our system. Click the button below to register a new author."
                    : "Do you want to create a new author record? Then click on the button below.";

              for (const item of data) {
                  let name = item.full_name;
                  if (item.orcid_id != null && item.orcid_id !== "") {
                      name += ` (${item.orcid_id})`;
                  }

                  const anchor = document.createElement("a");
                  anchor.href = "#";
                  anchor.textContent = name;
                  anchor.addEventListener("click", event => {
                      event.data = { "uuid": item.uuid, "item_id": item_id };
                      add_author_event(event);
                  });

                  const list_item = document.createElement("li");
                  list_item.appendChild(anchor);
                  unordered_list.appendChild(list_item);
              }

              const new_author_description = document.createElement("span");
              new_author_description.id = "new-author-description";
              new_author_description.textContent = new_author_text;

              const new_author_anchor = document.createElement("a");
              new_author_anchor.href = "#";
              new_author_anchor.textContent = "Create new author record";
              new_author_anchor.addEventListener("click", event => {
                  event.data = { "item_id": item_id };
                  add_author_event(event);
              });

              const new_author_button = document.createElement("div");
              new_author_button.id = "new-author";
              new_author_button.className = "a-button";
              new_author_button.appendChild(new_author_anchor);

              new_author_description.appendChild(new_author_button);
              unordered_list.appendChild(new_author_description);

	      const wrapper = document.createElement("div");
	      wrapper.id = "authors-ac";
	      wrapper.className = "autocomplete";
	      wrapper.appendChild(unordered_list);
              const authors_input = document.getElementById("authors");
              authors_input.classList.add("input-for-ac");
              authors_input.after(wrapper);
          }).catch(error => { console.log(`Error: ${error.message}`); });
    }
}

function add_funding_event (event) {
    stop_event_propagation (event);
    add_funding (event.data["uuid"], event.data["item_id"]);
}

function new_funding_event (event) {
    stop_event_propagation (event);
    new_funding (event.data["item_id"]);
}

function autocomplete_funding (event, item_id) {
    let current_text = document.getElementById("funding").value.trim();
    if (current_text == "") {
	let element = document.getElementById("funding-ac");
	if (element) { element.remove(); }
        document.getElementById("funding").classList.remove("input-for-ac");
    } else if (current_text.length > 2) {
        fetch("/v2/account/funding/search", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ "search": current_text })
        }).then(response => response.json())
          .then(data => {
	      let element = document.getElementById("funding-ac");
	      if (element) { element.remove(); }
              const unordered_list = document.createElement("ul");
              for (const item of data) {
                  const anchor = document.createElement("a");
                  anchor.href = "#";
                  anchor.textContent = item.title;
                  anchor.addEventListener("click", event => {
                      event.data = { "uuid": item.uuid, "item_id": item_id };
                      add_funding_event(event);
                  });

                  const list_item = document.createElement("li");
                  list_item.appendChild(anchor);
                  unordered_list.appendChild(list_item);
              }

              const new_funding_anchor = document.createElement("a");
              new_funding_anchor.href = "#";
              new_funding_anchor.textContent = "Create funding record";
              new_funding_anchor.addEventListener("click", event => {
                  event.data = { "item_id": item_id };
                  new_funding_event(event);
              });

              const new_funding_button = document.createElement("div");
              new_funding_button.id = "new-funding";
              new_funding_button.className = "a-button";
              new_funding_button.appendChild(new_funding_anchor);
              unordered_list.appendChild(new_funding_button);

	      const wrapper = document.createElement("div");
	      wrapper.id = "funding-ac";
	      wrapper.className = "autocomplete";
	      wrapper.appendChild(unordered_list);
              const funding_input = document.getElementById("funding");
              funding_input.classList.add("input-for-ac");
              funding_input.after(wrapper);
          }).catch(error => { console.log(`Error: ${error.message}`); });
    }
}

function toggle_cite_collect (event, action) {
    stop_event_propagation (event);

    const other = action === "collect" ? "cite" : "collect";
    const label = action === "collect" ? "Collect" : "Citation";
    const item = document.getElementById(action);
    const other_item = document.getElementById(other);
    const btn = document.getElementById(`${action}-btn`);
    const other_btn = document.getElementById(`${other}-btn`);

    if (item === null || other_item === null) { return; }
    const is_visible = item.classList.contains("open");
    const other_is_visible = other_item.classList.contains("open");

    if (is_visible) {
        item.classList.remove("open");
        item.addEventListener("transitionend", () => {
            item.style.display = "none";
            btn.classList.remove("close");
            btn.classList.add("open");
            btn.textContent = label;
        }, { once: true });

        if (!other_is_visible) {
            other_btn.classList.remove("close", "secondary");
        }
    } else {
        other_item.classList.remove("open");
        other_item.addEventListener("transitionend", () => {
            other_item.style.display = "none";
            other_btn.classList.remove("open");
            other_btn.classList.add("secondary");
        }, { once: true });

        item.style.display = "grid";
        item.classList.add("open");
        item.addEventListener("transitionend", () => {
            btn.classList.remove("open", "secondary");
            btn.classList.add("close");
            btn.textContent = label;
        }, { once: true });
    }
}

function toggle_citation (event) {
    return toggle_cite_collect (event, "cite");
}
function toggle_collect (event) {
    return toggle_cite_collect (event, "collect");
}

function add_tag_event (event) {
    stop_event_propagation (event);
    const tag_input = document.getElementById('tag');
    tag_input.value = event.data["selected_tag"] + '; ';
    tag_input.focus();
    add_tag(event.data["item_id"]);
}

function autocomplete_tags (event, item_id) {
    let current_text = document.getElementById("tag").value.trim();
    if (current_text == "") {
	let element = document.getElementById("tag-ac");
	if (element) { element.remove(); }
        document.getElementById("tag").classList.remove("input-for-ac");
        return;
    }
    if (current_text.length <= 2) { return; }

    fetch("/v3/tags/search", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ "search_for": current_text })
    }).then(response => response.json())
      .then(data => {
	  let element = document.getElementById("tag-ac");
	  if (element) { element.remove(); }
	  if (data && data.length) {
              const unordered_list = document.createElement("ul");
              for (const item of data) {
                  const anchor = document.createElement("a");
                  anchor.href = "#";
                  anchor.textContent = item;
                  anchor.addEventListener("click", event => {
                      event.data = { "item_id": item_id, "selected_tag": item };
                      add_tag_event(event);
                  });
                  const list_item = document.createElement("li");
                  list_item.appendChild(anchor);
                  unordered_list.appendChild(list_item);
              }

	      const wrapper = document.createElement("div");
	      wrapper.id = "tag-ac";
	      wrapper.className = "autocomplete";
	      wrapper.appendChild(unordered_list);
              document.getElementById("tag").classList.add("input-for-ac");
              document.getElementById("wrap-input-tag").after(wrapper);
          } else {
              document.getElementById("tag").classList.remove("input-for-ac");
          }
      }).catch(() => {
	  let element = document.getElementById("tag-ac");
	  if (element) { element.remove(); }
          document.getElementById("tag").classList.remove("input-for-ac");
      });
}
